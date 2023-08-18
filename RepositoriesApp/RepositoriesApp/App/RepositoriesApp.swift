import SwiftUI

@main
struct RepositoriesApp: App {
    @ObservedObject var router = DependencyContainer.shared.resolve(Router.self)!

    var body: some Scene {
        return WindowGroup {
            NavigationStack(path: $router.path) {
                LaunchScreen().modifier(NavigationDestinationModifier())
            }
        }
    }
}
