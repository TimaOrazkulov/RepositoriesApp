import Combine

protocol UserProfileProvider: AnyObject {
    var user: User? { get set }
}
