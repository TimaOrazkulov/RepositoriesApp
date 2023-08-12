//
//  RepositoriesStore.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import Foundation
import Cache

final class ViewedRepositoriesStore {
    static let shared = ViewedRepositoriesStore()

    private lazy var storage = try? Storage<String, [Repository]>(
        diskConfig: diskConfig,
        memoryConfig: memoryConfig,
        transformer: TransformerFactory.forCodable(ofType: [Repository].self)
    )

    private let diskConfig = DiskConfig(name: Constants.diskConfigName.rawValue)
    private let memoryConfig = MemoryConfig()

    func getViewedRepositories() throws -> [Repository] {
        try storage?.object(forKey: Constants.key.rawValue) ?? []
    }

    func addViewed(repository: Repository) throws {
        guard var repositories = try? storage?.object(forKey: Constants.key.rawValue) else {
            return
        }

        if repositories.count == 20 {
            repositories.removeFirst()
        }

        repositories.append(repository)
        try storage?.setObject(repositories, forKey: Constants.key.rawValue)
    }
}

private extension ViewedRepositoriesStore {
    enum Constants: String {
        case diskConfigName = "Viewed Repositories"
        case key = "viewedRepos"
    }
}
