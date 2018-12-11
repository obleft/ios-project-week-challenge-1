//
//  Book.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

class Book: Codable & FirebaseItem {

    
    
    var id: String
    let etag: String
    let title, subtitle: String
//    let authors: [String]
//    let publisher, publishedDate, description: String?
//    let industryIdentifiers: [IndustryIdentifier]
//    let readingModes: ReadingModes
//    let pageCount: Int?
//    let printType: PrintType
//    let categories: [String]?
//    let maturityRating: MaturityRating
//    let allowAnonLogging: Bool
//    let contentVersion: String
//    let panelizationSummary: PanelizationSummary
    let imageLinks: String?
//    let language: Language
//    let previewLink: String
//    let infoLink: String
//    let canonicalVolumeLink: String
    
    init(id: String, etag: String, title: String, subtitle: String, imageLinks: String) {
        // let types = types[0] ?? ""
        // let abilities = abilities[0] ?? ""
        (self.id, self.etag, self.title, self.subtitle, self.imageLinks) = (id, etag, title, subtitle, imageLinks)
    }
}
