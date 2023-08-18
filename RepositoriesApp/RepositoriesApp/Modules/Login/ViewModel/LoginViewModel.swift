import Combine
import Foundation

final class LoginViewModel: ObservableObject {
    @Published var userIsLoading = false
    @Published var showError = false

    var error: Error?

    private let userProfileProvider = DependencyContainer.shared.resolve(UserProfileProvider.self)!
    private let userSessionCreater = DependencyContainer.shared.resolve(UserSessionCreater.self)!
    private var router = DependencyContainer.shared.resolve(Router.self)!

    private var cancellables: Set<AnyCancellable> = []

    func getUser(with token: String) {
        userIsLoading = true
        let cancellable = userProfileProvider.getUser(with: [.authToken(token)])
        cancellable.sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                self?.error = error
                self?.showError = true
                fallthrough
            case .finished:
                self?.userIsLoading = false
            }
        } receiveValue: { [weak self] user in
            guard let self else {
                return
            }

            userSessionCreater.createUserSession(token: token)
            userProfileProvider.user = user
            router.showRepositories()
        }.store(in: &cancellables)
    }
}
