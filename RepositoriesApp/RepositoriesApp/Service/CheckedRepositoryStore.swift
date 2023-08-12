//
//  CheckedRepositoryStore.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 11.08.2023.
//

import Foundation
import Cache

final class CheckedRepositoriesStore {
    static let shared = ViewedRepositoriesStore()

    private lazy var storage = try? Storage<Repository, Bool>(
        diskConfig: diskConfig,
        memoryConfig: memoryConfig,
        transformer: TransformerFactory.forCodable(ofType: Bool.self)
    )

    private let diskConfig = DiskConfig(name: Constants.diskConfigName.rawValue)
    private let memoryConfig = MemoryConfig()

    func setChecked(repository: Repository) throws {
        try storage?.setObject(true, forKey: repository)
    }

    func isChecked(repository: Repository) throws -> Bool {
        try storage?.object(forKey: repository) ?? false
    }
}

private extension CheckedRepositoriesStore {
    enum Constants: String {
        case diskConfigName = "Checked Repositories"
    }
}
