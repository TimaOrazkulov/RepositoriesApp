import Foundation

protocol RepositoriesProvider: AnyObject {
    func getLastSeenRepositories() -> [Repository]
    func setChecked(repository: Repository)
    func isChecked(repository: Repository) -> Bool
}
