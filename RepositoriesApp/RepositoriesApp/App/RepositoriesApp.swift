import SwiftUI

let assembler = AssemblerFactory().makeAssembler()

@main
struct RepositoriesApp: App {
    @ObservedObject var router = Router.shared

    var body: some Scene {
        let modulesFactory = ModulesFactory(assembler: assembler)
        return WindowGroup {
            NavigationStack(path: $router.path) {
                modulesFactory.makeLaunchScreen()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .login:
                            modulesFactory.makeLogin()
                        case .history:
                            modulesFactory.makeHistory()
                        case .repositories:
                            modulesFactory.makeRepositories()
                        }
                    }
            }
        }
    }
}
