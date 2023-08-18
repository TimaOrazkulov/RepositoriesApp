import SwiftUI

struct NavigationDestinationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .login:
                    LoginView()
                case .history:
                    HistoryView()
                case .repositories:
                    RepositoriesView()
                }
            }
    }
}
