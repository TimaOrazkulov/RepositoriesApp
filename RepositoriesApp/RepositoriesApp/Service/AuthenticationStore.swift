import KeychainAccess
import Foundation

enum KeychainKey: String {
    case token
}

final class AuthenticationStore {
    static let shared = AuthenticationStore()

    private let keyChainStorage = Keychain()

    func store(token: String) {
        keyChainStorage[KeychainKey.token.rawValue] = token
    }

    func getToken() -> String? {
        keyChainStorage[KeychainKey.token.rawValue]
    }

    func removeToken() {
        keyChainStorage[KeychainKey.token.rawValue] = nil
    }

    func clear() {
        do {
            try keyChainStorage.removeAll()
        } catch (let error) {
            assertionFailure("Can't clear keychain store: \(error.localizedDescription)")
        }
    }
}

