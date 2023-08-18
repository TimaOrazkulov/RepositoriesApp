import Alamofire
import Combine

protocol UserProfileProvider: AnyObject {
    var user: User? { get set }
    
    func getUser(with headers: [HTTPHeader]) -> AnyPublisher<User, Error>
}

extension UserProfileProvider {
    func getUser(with headers: [HTTPHeader] = []) -> AnyPublisher<User, Error> {
        getUser(with: headers)
    }
}
