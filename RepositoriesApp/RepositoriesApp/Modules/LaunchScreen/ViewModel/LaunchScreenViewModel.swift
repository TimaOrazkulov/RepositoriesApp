import Foundation
import Combine

final class LaunchScreenViewModel: ObservableObject {
    @Published var showError = false
    var error: Error?

    private let router = assembler.resolver.resolve(Router.self)!
    private let networkClient = assembler.resolver.resolve(NetworkClient.self)!
    private let authCredentialsProvider = assembler.resolver.resolve(AuthCredentialsProvider.self)!
    private let userProfileProvider = assembler.resolver.resolve(UserProfileProvider.self)!

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
        networkClient.get("/user").sink { [weak self] completion in
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
