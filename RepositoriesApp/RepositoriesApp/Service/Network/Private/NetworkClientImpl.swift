import Foundation
import Alamofire
import Combine

final class NetworkClientImpl: NetworkClient {
    private let session: Session
    private let baseURLProvider: BaseURLProvider

    private let errorRequestValidator = ErrorURLRequestValidator()

    init(
        session: Session,
        baseURLProvider: BaseURLProvider
    ) {
        self.session = session
        self.baseURLProvider = baseURLProvider
    }

    func request<Parameters: Encodable, Response: Decodable>(
        _ relativePath: String,
        method: HTTPMethod,
        parameters: Parameters,
        headers: HTTPHeaders?
    ) -> AnyPublisher<Response, Error> {
        let request = session.request(
            baseURLProvider.baseURL + relativePath,
            method: method,
            parameters: parameters,
            encoder: ParameterEncoderFactory().makeParameterEncoder(for: method),
            headers: headers
        )

        let validation = errorRequestValidator.validate(request:response:data:)
        return request
            .validate(validation)
            .toFuture()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
