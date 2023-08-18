//
//  Router.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import SwiftUI

final class Router: ObservableObject {
    @Published var path: [Route] = []

    func showLogin() {
        path.removeAll()
        path.append(.login)
    }

    func showRepositories() {
        path.append(.repositories)
    }

    func showHistory() {
        path.append(.history)
    }

    func pop() {
        path.removeLast()
    }
}
