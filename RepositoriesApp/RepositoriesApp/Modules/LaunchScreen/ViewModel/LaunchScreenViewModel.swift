//
//  LaunchScreenViewModel.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import Foundation

final class LaunchScreenViewModel: ObservableObject {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    func showNextScreen() async {
        // 1 second = 1_000_000_000 nanoseconds
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        if AuthenticationStore.shared.getToken() != nil {
            router.showRepositories()
        } else {
            router.showLogin()
        }
    }
}
