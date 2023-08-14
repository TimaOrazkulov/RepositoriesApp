import Foundation
import Combine

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

extension UserSessionManager: UserSessionCreater {
    func createUserSession(token: String) {
        self.token = token
    }
}

extension UserSessionManager: UserSessionDestroyer {
    func destroyUserSession() {
        token = nil
    }
}
