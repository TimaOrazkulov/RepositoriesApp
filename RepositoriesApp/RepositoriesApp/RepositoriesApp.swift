//
//  RepositoriesAppApp.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import SwiftUI

@main
struct RepositoriesApp: App {
    @ObservedObject var router = Router.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                LaunchScreen(viewModel: LaunchScreenViewModel(router: router))
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .login:
                            LoginView()
                        case .history:
                            LoginView()
                        case .repositories:
                            RepositoriesView()
                        }
                    }
            }
        }
    }
}
