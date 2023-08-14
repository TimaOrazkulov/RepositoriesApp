//
//  LaunchScreenViewModel.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import Foundation
import Combine

final class LaunchScreenViewModel: ObservableObject {
    private let router: Router
    private let networkClient: NetworkClient
    private let authCredentialsProvider: AuthCredentialsProvider

    private var cancellables: Set<AnyCancellable> = []

    init(
        router: Router,
        networkClient: NetworkClient,
        authCredentialsProvider: AuthCredentialsProvider
    ) {
        self.router = router
        self.networkClient = networkClient
        self.authCredentialsProvider = authCredentialsProvider
    }

    func showNextScreen() {
        authCredentialsProvider.isActive ? getUser() : router.showLogin()
    }

    private func getUser() {
        let cancellable: Future<User, Error> = networkClient.get("/user")
        cancellable.sink { error in
            print(error)
        } receiveValue: { [weak self] user in
            guard let self else {
                return
            }

            print("USER:")
            print(user)
            router.showRepositories()
        }.store(in: &cancellables)
    }
}
