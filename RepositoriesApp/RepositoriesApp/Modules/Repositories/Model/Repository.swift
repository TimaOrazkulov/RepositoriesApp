import Foundation

struct Repository: Codable, Hashable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName
        case description
        case htmlUrl
        case owner
    }   

    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let htmlUrl: String
    let owner: Owner
    var isChecked = false
}

extension Repository {
    struct Owner: Codable, Hashable, Identifiable {
        let id: Int
        let login: String
        let avatarUrl: String
    }
}
