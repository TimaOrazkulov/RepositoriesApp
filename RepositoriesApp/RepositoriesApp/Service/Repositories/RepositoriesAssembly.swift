import Swinject

struct RepositoriesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RepositoriesProvider.self) { _ in
            RepositoriesManager()
        }
    }
}
