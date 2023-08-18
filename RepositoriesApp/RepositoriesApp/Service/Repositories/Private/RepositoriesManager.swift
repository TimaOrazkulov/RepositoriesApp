import Alamofire
import Combine
import Foundation

// MARK: - RepositoriesManager

final class RepositoriesManager {
    typealias RepositoriesSet = Set<Repository>
    typealias RepositoriesList = [Repository]
    
    @FileStorage<RepositoriesSet>(path: "Repositories/checkRepos.json") var checkedRepos
    @FileStorage<RepositoriesList>(path: "Repositories/seenRepos.json") var seenRepos
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        checkedRepos = checkedRepos ?? []
        seenRepos = seenRepos ?? []
    }
}

// MARK: - RepositoriesProvider

extension RepositoriesManager: RepositoriesProvider {
    func getRepositories() -> AnyPublisher<[Repository], Error> {
        networkClient.get("/repositories")
    }
    
    func getRepositories(with request: GetRepositoriesRequest) -> AnyPublisher<GetRepositoriesResponse, Error> {
        networkClient.get("/search/repositories", parameters: request)
    }
}

// MARK: - RepositoriesStorageProvider

extension RepositoriesManager: RepositoriesStorageProvider {
    func getLastSeenRepositories() -> [Repository] {
        seenRepos?.reversed() ?? []
    }
    
    func isChecked(repository: Repository) -> Bool {
        checkedRepos?.contains(repository) ?? false
    }
    
    func setChecked(repository: Repository) {
        checkedRepos?.insert(repository)
        guard let seenRepos else {
            return
        }
        
        if seenRepos.count > 20, !seenRepos.contains(repository) {
            self.seenRepos?.removeFirst()
        }
        self.seenRepos?.append(repository)
    }
}
