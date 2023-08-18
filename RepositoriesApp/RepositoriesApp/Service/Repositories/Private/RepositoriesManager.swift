import Foundation

final class RepositoriesManager: RepositoriesProvider {
    typealias RepositoriesSet = Set<Repository>
    typealias RepositoriesList = [Repository]

    @FileStorage<RepositoriesSet>(path: "Repositories/checkRepos.json") var checkedRepos
    @FileStorage<RepositoriesList>(path: "Repositories/seenRepos.json") var seenRepos

    init() {
        checkedRepos = checkedRepos ?? []
        seenRepos = seenRepos ?? []
    }

    func getLastSeenRepositories() -> [Repository] {
        seenRepos ?? []
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
