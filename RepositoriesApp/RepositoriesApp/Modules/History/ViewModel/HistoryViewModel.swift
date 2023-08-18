import SwiftUI

final class HistoryViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    
    private let repositoriesProvider = DependencyContainer.shared.resolve(RepositoriesStorageProvider.self)!
    
    init() {
        repositories = repositoriesProvider.getLastSeenRepositories()
    }
}
