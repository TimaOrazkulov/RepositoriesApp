import Combine

protocol RepositoriesProvider: AnyObject {
    func getRepositories() -> AnyPublisher<[Repository], Error>
    func getRepositories(with request: GetRepositoriesRequest) -> AnyPublisher<GetRepositoriesResponse, Error>
}
