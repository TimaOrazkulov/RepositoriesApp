import Foundation
import Alamofire

final class NetworkAdapter: RequestAdapter {
    private let authCredentialsProvider: AuthCredentialsProvider

    init(authCredentialsProvider: AuthCredentialsProvider) {
        self.authCredentialsProvider = authCredentialsProvider
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var headers = urlRequest.headers
        headers.add(
            HTTPHeader(name: "accept", value: "application/vnd.github+json")
        )
        if let token = authCredentialsProvider.token {
            headers.add(
                .authToken(token)
            )
        }

        var urlRequest = urlRequest
        urlRequest.headers = headers
        completion(.success(urlRequest))
    }
}

extension HTTPHeader {
    static func authToken(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: "Bearer \(value)")
    }
}
