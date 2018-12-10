

import Foundation

// individual entry
struct BookSearchResults: Codable{
    let id: Int
    let name: String
    let types: [Pokemon.TypeElement]
    let abilities: [Pokemon.AbilityElement]
    let sprites: Pokemon.Sprites
    
}
