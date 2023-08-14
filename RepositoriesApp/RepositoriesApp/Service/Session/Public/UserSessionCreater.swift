//
//  UserSessionCreater.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 13.08.2023.
//

import Foundation

protocol UserSessionCreater: AnyObject {
    func createUserSession(token: String)
}
