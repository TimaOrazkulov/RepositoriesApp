import Swinject

struct BaseURLAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BaseURLProvider.self) { r in
            BaseURLProviderImpl()
        }
    }
}
