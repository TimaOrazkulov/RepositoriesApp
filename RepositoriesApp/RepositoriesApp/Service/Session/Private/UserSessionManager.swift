import Foundation
import Combine

// MARK: - AuthCredentialsProvider

final class UserSessionManager: AuthCredentialsProvider {
    @Published var isActive = false

    @ProtectedStorage(key: "Token") var token {
        didSet {
            guard oldValue != token else {
                return
            }

            updateUserSession()
        }
    }

    init() {
        updateUserSession()
    }

    func updateUserSession() {
        isActive = (token != nil)
    }
}

// MARK: - UserSessionCreater

extension UserSessionManager: UserSessionCreater {
    func createUserSession(token: String) {
        self.token = token
    }
}

// MARK: - UserSessionDestroyer

extension UserSessionManager: UserSessionDestroyer {
    func destroyUserSession() {
        token = nil
    }
}
