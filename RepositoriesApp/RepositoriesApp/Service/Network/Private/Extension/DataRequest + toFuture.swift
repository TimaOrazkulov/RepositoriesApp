import Alamofire
import Combine
import Foundation

extension DataRequest {
    func toFuture<Response: Decodable>() -> Future<Response, Error> {
        Response.self is any Sequence.Type ? toFutureSequence() : toFutureDecodable()
    }

    private func toFutureDecodable<Response: Decodable>() -> Future<Response, Error> {
        Future { promise in
            self.responseDecodable(
                of: Response.self,
                queue: DispatchQueue.global(qos: .userInitiated),
                decoder: JSONDecoder.default
            ) { response in
                switch response.result {
                case let .success(result):
                    promise(.success(result))
                case let .failure(error):
                    promise(.failure(error.asNetworkError ?? error))    
                }
            }
        }
    }

    private func toFutureSequence<Response: Decodable>() -> Future<Response, Error> {
        Future { promise in
            self.responseData(
                queue: DispatchQueue.global(qos: .userInitiated)
            ) { response in
                switch response.result {
                case let .success(data):
                    do {
                        let array = try JSONDecoder.default.decode(Response.self, from: data)
                        promise(.success(array))
                    } catch (let error) {
                        promise(.failure(error))
                    }
                case let .failure(error):
                    promise(.failure(error.asNetworkError ?? error))
                }
            }
        }
    }
}

extension Error {
    fileprivate var asNetworkError: Error? {
        unwrapError(from: self, ofType: NetworkError.self)
    }

    private func unwrapError<T: Error>(from error: Error, ofType type: T.Type) -> Error? {
        if let targetError = error as? T {
            return targetError
        }

        guard let afError = error.asAFError else {
            return nil
        }

        switch afError {
        case let .requestRetryFailed(retryError, _):
            return unwrapError(from: retryError, ofType: type)
        case let .sessionTaskFailed(error):
            if let error = error as? URLError {
                return NetworkError(message: error.localizedDescription)
            } else {
                fallthrough
            }
        default:
            guard let underlyingError = afError.underlyingError else {
                return nil
            }

            return unwrapError(from: underlyingError, ofType: type)
        }
    }
}
