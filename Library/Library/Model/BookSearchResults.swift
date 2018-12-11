

import Foundation

// individual entry
struct BookSearchResults: Codable {
    let kind: String
    let totalItems: Int
    let items: [Item]
    
}
