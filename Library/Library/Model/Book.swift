//
//  Book.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

class Bok: Codable & FirebaseItem {
    let abilities: [AbilityElement]
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [TypeElement]
    var recordIdentifier: String = ""
    
    init(name: String, id: Int, types: [TypeElement], abilities: [AbilityElement], sprites: Sprites) {
        // let types = types[0] ?? ""
        // let abilities = abilities[0] ?? ""
        (self.name, self.id, self.types, self.abilities, self.sprites) = (name, id, types, abilities, sprites)
    }
    
    
    struct AbilityElement: Codable {
        let ability: TypeClass
        let isHidden: Bool
        let slot: Int
        
        enum CodingKeys: String, CodingKey {
            case ability
            case isHidden = "is_hidden"
            case slot
        }
    }
    
    struct TypeClass: Codable {
        let name: String
        let url: String
    }
    
    struct Sprites: Codable {
        let backDefault, /*backFemale,*/ backShiny/*, backShinyFemale*/: String
        let frontDefault, /*frontFemale,*/ frontShiny/*, frontShinyFemale*/: String
        
        enum CodingKeys: String, CodingKey {
            case backDefault = "back_default"
            //            case backFemale = "back_female"
            case backShiny = "back_shiny"
            //            case backShinyFemale = "back_shiny_female"
            case frontDefault = "front_default"
            //            case frontFemale = "front_female"
            case frontShiny = "front_shiny"
            //            case frontShinyFemale = "front_shiny_female"
        }
    }
    
    struct TypeElement: Codable {
        let slot: Int
        let type: TypeClass
    }
    
}


