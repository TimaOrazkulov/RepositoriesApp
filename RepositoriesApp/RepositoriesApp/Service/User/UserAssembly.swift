import Swinject

struct UserAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserProfileProvider.self) { _ in
            UserProfileStorage()
        }
    }
}
