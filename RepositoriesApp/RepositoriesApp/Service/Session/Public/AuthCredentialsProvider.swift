import Foundation

protocol AuthCredentialsProvider: AnyObject {
    var isActive: Bool { get }
    var token: String? { get }
}
