import Alamofire
import Combine

final class UserProfileManager: UserProfileProvider {
    @FileStorage(path: "User/userProfile.json") var user: User?
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getUser(with headers: [HTTPHeader]) -> AnyPublisher<User, Error> {
        networkClient.get("/user", headers: headers)
    }
}
