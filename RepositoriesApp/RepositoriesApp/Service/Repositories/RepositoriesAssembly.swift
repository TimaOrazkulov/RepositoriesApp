import Swinject

struct RepositoriesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RepositoriesManager.self) { r in
            RepositoriesManager(
                networkClient: r.resolve(NetworkClient.self)!
            )
        }
        
        container.register(RepositoriesStorageProvider.self) { r in
            r.resolve(RepositoriesManager.self)!
        }
        container.register(RepositoriesProvider.self) { r in
            r.resolve(RepositoriesManager.self)!
        }
    }
}
