import Alamofire
import Foundation

// MARK: - Constants

private enum Constants {
    static let acceptableStatusCodes = 200..<300
    static let serverErrorStatusCodes = 500...
}

// MARK: - ErrorURLRequestValidator

final class ErrorURLRequestValidator {
    func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> Result<Void, Error> {
        switch response.statusCode {
        case Constants.acceptableStatusCodes:
            return .success(())
        case Constants.serverErrorStatusCodes:
            do {
                let networkError = try getNetworkError(from: data)
                return .failure(networkError)
            } catch {
                let networkError = NetworkError(message: "server_unavailable_description".localized())
                return .failure(networkError)
            }
        default:
            do {
                let networkError = try getNetworkError(from: data)
                return .failure(networkError)
            } catch {
                return .failure(error)
            }
        }
    }

    private func getNetworkError(from data: Data?) throws -> NetworkError {
        guard let data else {
            let error = AFError.responseValidationFailed(reason: .dataFileNil)
            throw error
        }

        return try JSONDecoder.default.decode(NetworkError.self, from: data)
    }
}
