

import Foundation

// individual entry
struct BookSearchResults: Codable{
    let id: Int
    let name: String
    let types: [Book.TypeElement]
    let abilities: [Book.AbilityElement]
    let sprites: Book.Sprites
    
}
