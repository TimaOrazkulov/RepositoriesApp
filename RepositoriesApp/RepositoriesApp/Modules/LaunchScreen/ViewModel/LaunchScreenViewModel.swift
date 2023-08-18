import Foundation
import Combine

final class LaunchScreenViewModel: ObservableObject {
    @Published var showError = false
    var error: Error?

    private let router = DependencyContainer.shared.resolve(Router.self)!
    private let authCredentialsProvider = DependencyContainer.shared.resolve(AuthCredentialsProvider.self)!
    private let userProfileProvider = DependencyContainer.shared.resolve(UserProfileProvider.self)!

    private var cancellables: Set<AnyCancellable> = []

    func showNextScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else {
                return
            }

            authCredentialsProvider.isActive ? getUser() : router.showLogin()
        }
    }

    private func getUser() {
        userProfileProvider.getUser().sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                self?.showError = true
                self?.error = error
            }
        } receiveValue: { [weak self] user in
            self?.userProfileProvider.user = user
            self?.router.showRepositories()
        }.store(in: &cancellables)
    }
}
