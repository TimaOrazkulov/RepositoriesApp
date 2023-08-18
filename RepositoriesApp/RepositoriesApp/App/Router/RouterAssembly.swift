import Swinject

struct RouterAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Router.self) { r in
            Router()
        }.inObjectScope(.container)
    }
}
