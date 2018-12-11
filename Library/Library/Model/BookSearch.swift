// To parse the JSON, add this file to your project and do:
//
//   let books = try? newJSONDecoder().decode(Books.self, from: jsonData)

import Foundation

struct BooksSearch: Codable {
    let kind: String
    let totalItems: Int
    let items: [Item]
}

struct Item: Codable {
    let kind: Kind
    let id, etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
    let searchInfo: SearchInfo?
}

struct AccessInfo: Codable {
    let country: Country?
    let viewability: Viewability
    let embeddable, publicDomain: Bool
    let textToSpeechPermission: TextToSpeechPermission?
    let epub, pdf: Epub
    let webReaderLink: String
    let accessViewStatus: AccessViewStatus
    let quoteSharingAllowed: Bool
}

enum AccessViewStatus: String, Codable {
    case none = "NONE"
    case sample = "SAMPLE"
    case fullPublicDomain = "FULL_PUBLIC_DOMAIN"
}

enum Country: String, Codable {
    case gb = "GB"
    case us = "US"
    case nl = "NL"
}

struct Epub: Codable {
    let isAvailable: Bool
    let acsTokenLink: String?
}

enum TextToSpeechPermission: String, Codable {
    case allowed = "ALLOWED"
    case allowedForAccess = "ALLOWED_FOR_ACCESSIBILITY"
}

enum Viewability: String, Codable {
    case noPages = "NO_PAGES"
    case partial = "PARTIAL"
    case allPages = "ALL_PAGES"
}

enum Kind: String, Codable {
    case booksVolume = "books#volume"
}

struct SaleInfo: Codable {
    let country: Country?
    let saleability: Saleability
    let isEbook: Bool
    let listPrice, retailPrice: SaleInfoListPrice?
    let buyLink: String?
    let offers: [Offer]?
}

struct SaleInfoListPrice: Codable {
    let amount: Double
    let currencyCode: CurrencyCode
}

enum CurrencyCode: String, Codable {
    case gbp = "GBP"
    case usd = "USD"
    case eur = "EUR"
}

struct Offer: Codable {
    let finskyOfferType: Int
    let listPrice, retailPrice: OfferListPrice
    let giftable: Bool?
    let rentalDuration: RentalDuration?
}

struct OfferListPrice: Codable {
    let amountInMicros: Int
    let currencyCode: CurrencyCode
}

struct RentalDuration: Codable {
    let unit: String
    let count: Int
}

enum Saleability: String, Codable {
    case forSale = "FOR_SALE"
    case forSaleAndRental = "FOR_SALE_AND_RENTAL"
    case notForSale = "NOT_FOR_SALE"
    case free = "FREE"
}

struct SearchInfo: Codable {
    let textSnippet: String
}

struct VolumeInfo: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publisher, publishedDate, description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let readingModes: ReadingModes
    let pageCount: Int?
    let printType: PrintType
    let categories: [String]?
    let maturityRating: MaturityRating
    let allowAnonLogging: Bool
    let contentVersion: String
    let panelizationSummary: PanelizationSummary?
    let imageLinks: ImageLinks?
    let language: Language
    let previewLink: String
    let infoLink: String
    let canonicalVolumeLink: String
}

struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String
}

struct IndustryIdentifier: Codable {
    let type: TypeEnum
    let identifier: String
}

enum TypeEnum: String, Codable {
    case isbn10 = "ISBN_10"
    case isbn13 = "ISBN_13"
    case other = "OTHER"
}

enum Language: String, Codable {
    case en = "en"
    case nl = "nl"
}

enum MaturityRating: String, Codable {
    case notMature = "NOT_MATURE"
    case mature = "MATURE"
}

struct PanelizationSummary: Codable {
    let containsEpubBubbles, containsImageBubbles: Bool
}

enum PrintType: String, Codable {
    case book = "BOOK"
}

struct ReadingModes: Codable {
    let text, image: Bool
}
