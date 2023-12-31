import Foundation
import Combine

final class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = true
    @Published var showError = false
    var error: Error?

    private let repositoriesStorageProvider = DependencyContainer.shared.resolve(RepositoriesStorageProvider.self)!
    private let repositoriesProvider = DependencyContainer.shared.resolve(RepositoriesProvider.self)!
    private let router = DependencyContainer.shared.resolve(Router.self)!

    private var allRepositories: [Repository] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private var page = 1
    private let perPage = 30
    private var shouldDownloadNextPage = true
    private var searchedText = ""

    func getRepositories() {
        isLoading = true
        let cancellable = repositoriesProvider.getRepositories()
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

            let repositories = setRepositoriesChecked(repositories: repositories)
            self.repositories = repositories
            allRepositories = repositories
        }.store(in: &cancellables)
    }
    
    func getRepositories(via text: String) {
        guard !text.isEmpty else {
            repositories = allRepositories
            return
        }
        
        if text != searchedText {
            repositories = []
        }

        isLoading = true
        let cancellable = repositoriesProvider.getRepositories(
            with: GetRepositoriesRequest(
                query: text,
                page: page,
                perPage: perPage,
                sort: .stars
            )
        )
        
        cancellable
            .sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                self?.error = error
                fallthrough
            case .finished:
                self?.isLoading = false
            }
        } receiveValue: { [weak self] response in
            guard let self else {
                return
            }

            self.shouldDownloadNextPage = response.incompleteResults
            let repositories = setRepositoriesChecked(repositories: response.items)
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

    func paginateIfNeeded(repository: Repository, search text: String) {
        guard repositories.last == repository else {
            return
        }
        
        page = text == searchedText ? (page + 1) : 1
        if shouldDownloadNextPage {
            getRepositories(via: text)
        }
    }

    private func setRepositoriesChecked(repositories: [Repository]) -> [Repository] {
        repositories.map { repository in
            var repository = repository
            repository.isChecked = repositoriesStorageProvider.isChecked(repository: repository)
            return repository
        }
    }

    private func isCheckedRepository(repository: Repository) -> Bool {
        repositoriesStorageProvider.isChecked(repository: repository)
    }

    private func setCheckedRepository(repository: Repository) {
        let index = repositories.firstIndex { repository.id == $0.id }
        guard let index else {
            return
        }

        repositories[index].isChecked = true
        repositoriesStorageProvider.setChecked(repository: repository)
    }
}
