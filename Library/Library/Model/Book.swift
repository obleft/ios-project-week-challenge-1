//
//  Book.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

class Book: Codable & Equatable & FirebaseItem {
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
    

    var id: String
    let etag: String
    let title, subtitle: String
    let authors: String?
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
    var hasRead: Bool
    var userReview: String?
    var ISBN_13: String?
    
    init(id: String, etag: String, title: String, subtitle: String, authors: String?, imageLinks: String, hasRead: Bool, userReview: String?, ISBN_13: String?) {
        // let types = types[0] ?? ""
        // let abilities = abilities[0] ?? ""
        (self.id, self.etag, self.title, self.subtitle, self.authors, self.imageLinks, self.hasRead, self.userReview, self.ISBN_13) = (id, etag, title, subtitle, authors, imageLinks, hasRead, userReview, ISBN_13)
    }
}
