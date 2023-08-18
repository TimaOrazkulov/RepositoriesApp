import Foundation

struct GetRepositoriesResponse: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
}
