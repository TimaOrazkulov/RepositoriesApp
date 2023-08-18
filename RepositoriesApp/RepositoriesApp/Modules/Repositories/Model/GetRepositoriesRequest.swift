import Foundation

struct GetRepositoriesRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case page
        case limit = "per_page"
    }
    let page: Int
    let limit: Int
}
