//
//  DataRequest + Future.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 13.08.2023.
//

import Alamofire
import Combine
import Foundation

extension DataRequest {
    func toFuture<Response: Decodable>() -> Future<Response, Error> {
        Future { promise in
            self.responseDecodable(
                of: Response.self,
                queue: DispatchQueue.global(qos: .userInitiated),
                decoder: JSONDecoder()
            ) { response in
                switch response.result {
                case let .success(result):
                    promise(.success(result))
                case let .failure(error):
                    if let error = error.asNetworkError {
                        promise(.failure(error))
                    } else {
                        promise(.failure(error))
                    }
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
