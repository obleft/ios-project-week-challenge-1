//
//  Categories.swift
//  Library
//
//  Created by Benjamin Hakes on 12/11/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

struct Categories: Codable{
    let categoies: [Category]
}

struct Category: Codable{
    let category: [String]
}
