//
//  Categories.swift
//  Library
//
//  Created by Benjamin Hakes on 12/11/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

class Category: Codable & FirebaseItem{
    let name: String
    let books: [Book]?
    var id: String
    
    init(id: String,name: String,books: [Book]?) {
        // let types = types[0] ?? ""
        // let abilities = abilities[0] ?? ""
        (self.id, self.name, self.books) = (id, name, books)
    }
}
