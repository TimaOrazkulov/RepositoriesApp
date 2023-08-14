import Alamofire
import Foundation

final class ParameterEncoderFactory {
    func makeParameterEncoder(for method: HTTPMethod) -> ParameterEncoder {
        switch method {
        case .get:
            return URLEncodedFormParameterEncoder(
                encoder: URLEncodedFormEncoder(
                    arrayEncoding: .noBrackets,
                    dateEncoding: .iso8601,
                    keyEncoding: .convertToSnakeCase
                )
            )
        default:
            return JSONParameterEncoder(encoder: JSONEncoder())
        }
    }
}
