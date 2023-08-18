//
//  User.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 12.08.2023.
//

import Foundation

struct User: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case login
        case url
        case avatarURL = "avatarUrl"
    }

    let login: String
    let url: String
    let avatarURL: String
}
