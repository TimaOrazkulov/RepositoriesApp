import Swinject

struct SessionAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserSessionManager.self) { _ in
            UserSessionManager()
        }.inObjectScope(.container)

        container.register(AuthCredentialsProvider.self) { r in
            r.resolve(UserSessionManager.self)!
        }

        container.register(UserSessionDestroyer.self) { r in
            r.resolve(UserSessionManager.self)!
        }

        container.register(UserSessionCreater.self) { r in
            r.resolve(UserSessionManager.self)!
        }
    }
}
