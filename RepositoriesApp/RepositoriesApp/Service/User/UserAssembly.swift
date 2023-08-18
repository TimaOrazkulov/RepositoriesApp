import Swinject

struct UserAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserProfileProvider.self) { r in
            UserProfileManager(
                networkClient: r.resolve(NetworkClient.self)!
            )
        }
    }
}
