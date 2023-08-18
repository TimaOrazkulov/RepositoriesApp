import Foundation

protocol RepositoriesStorageProvider: AnyObject {
    func getLastSeenRepositories() -> [Repository]
    func setChecked(repository: Repository)
    func isChecked(repository: Repository) -> Bool
}
