import Foundation

protocol UserSessionCreater: AnyObject {
    func createUserSession(token: String)
}
