import Foundation

struct NetworkError: Error, Decodable {
    let message: String
}
