import Foundation
import Combine

final class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = true
    @Published var error: Error?

    private let networkClient = assembler.resolver.resolve(NetworkClient.self)!
    private let repositoriesProvider = assembler.resolver.resolve(RepositoriesProvider.self)!
    private let router = assembler.resolver.resolve(Router.self)!

    private var cancellables: Set<AnyCancellable> = []
    
    private var page = 1
    private let limit = 10
    private var shouldDownloadNextPage = true

    func getRepositories() {
        isLoading = true
        let cancellable: AnyPublisher<[Repository], Error> = networkClient.get(
            "/user/repos",
            parameters: GetRepositoriesRequest(
                page: page,
                limit: limit
            )
        )
        cancellable.sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                self?.error = error
                fallthrough
            case .finished:
                self?.isLoading = false
            }
        } receiveValue: { [weak self] repositories in
            guard let self else {
                return
            }

            self.shouldDownloadNextPage = repositories.count == limit
            let repositories = repositories.map { repository in
                var repository = repository
                repository.isChecked = self.isCheckedRepository(repository: repository)
                return repository
            }

            if self.repositories.isEmpty {
                self.repositories = repositories
            } else {
                self.repositories.append(contentsOf: repositories)
            }
        }.store(in: &cancellables)
    }

    func showRepository(repository: Repository) {
        setCheckedRepository(repository: repository)
    }

    func showHistory() {
        router.showHistory()
    }

    func paginateIfNeeded(repository: Repository) {
        guard repositories.last == repository else {
            return
        }
        
        page += 1
        if shouldDownloadNextPage {
            getRepositories()
        }
    }

    private func isCheckedRepository(repository: Repository) -> Bool {
        repositoriesProvider.isChecked(repository: repository)
    }

    private func setCheckedRepository(repository: Repository) {
        let index = repositories.firstIndex { repository.id == $0.id }
        guard let index else {
            return
        }

        repositories[index].isChecked = true
        repositoriesProvider.setChecked(repository: repository)
    }
}
