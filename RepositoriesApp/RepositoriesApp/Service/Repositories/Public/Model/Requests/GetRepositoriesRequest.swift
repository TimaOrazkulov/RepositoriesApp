import Foundation

struct GetRepositoriesRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case query = "q"
        case page
        case perPage
        case sort
    }
    
    let query: String
    let page: Int
    let perPage: Int
    let sort: Sort
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode("\(query.text) \(query.kind.rawValue)", forKey: .query)
//        try container.encode(page, forKey: .page)
//        try container.encode(perPage, forKey: .perPage)
//        try container.encode(sort, forKey: .sort)
//    }
}

//extension GetRepositoriesRequest {
//    struct Query: Encodable {
//        let text: String
//        let kind: Kind
//    }
//}
//
//extension GetRepositoriesRequest.Query {
//    enum Kind: String, Encodable {
//        case name = "in:name"
//        case description = "in:description"
//    }
//}

// MARK: - Sort

extension GetRepositoriesRequest {
    enum Sort: String, Encodable {
        case stars
        case forks
        case helpWantedIssues = "help-wanted-issues"
        case updated
    }
}
