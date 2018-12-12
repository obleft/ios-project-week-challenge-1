//
//  SWAPI.swift
//  Star Wars Search
//
//  Created by Benjamin Hakes on 12/5/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

class GoogleBooksAPI {
    
    // enter new endpoint here
    static let endpoint = "https://www.googleapis.com/books/v1/volumes"
    // Add the completion last
    static func searchForBooks(with searchTerm: String, completion: @escaping ([Book]?, Error?) -> Void) {
        
        // Establish the base url for our search
        guard let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")
            else {
                fatalError("Unable to construct baseURL")
        }
        
        // Decompose it into its components
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Unable to resolve baseURL to components")
        }
        
        // Create the query item using `search` and the search term
        let searchQueryItem = URLQueryItem(name: "q", value: searchTerm)
        
        // Create a query item #2 to get max results (40)
        let searchQueryItem2 = URLQueryItem(name: "maxResults", value: "40")
        
        
        // Create a query item #3 to restrict languages
        let searchQueryItem3 = URLQueryItem(name: "langRestrict", value: "en")
        
        // Add in the search terms
        urlComponents.queryItems = [searchQueryItem, searchQueryItem2, searchQueryItem3]
        
        // Recompose all those individual components back into a fully
        // realized search URL
        guard let searchURL = urlComponents.url else {
            NSLog("Error constructing search URL for \(searchTerm)")
            completion(nil, NSError())
            return
        }
        
        // Create a GET request
        var request = URLRequest(url: searchURL)
        request.httpMethod = "GET" // basically "READ"
        
        // Asynchronously fetch data
        // Once the fetch completes, it calls its handler either with data
        // (if available) _or_ with an error (if one happened)
        // There's also a URL Response but we're going to ignore it
        let dataTask = URLSession.shared.dataTask(with: request) {
            // This closure is sent three parameters:
            data, _, error in
            
            // Rehydrate our data by unwrapping it
            guard error == nil, let data = data else {
                if let error = error { // this will always succeed
                    NSLog("Error fetching data: \(error)")
                    completion(nil, error) // we know that error is non-nil
                }
                return
            }
            
            // We know now we have no error *and* we have data to work with
            
            // Convert the data to JSON
            // We need to convert snake_case decoding to camelCase
            // Oddly there is no kebab-case equivalent
            // Note issues with naming and show similar thing
            // For example: https://github.com/erica/AssetCatalog/blob/master/AssetCatalog%2BImageSet.swift#L295
            // See https://randomuser.me for future
            do {
                // Declare, customize, use the decoder
                let jsonDecoder = JSONDecoder()
                
                // Perform decoding into [Book] stored in Book
                let searchResults = try jsonDecoder.decode(BookSearchResults.self, from: data)
                
                // create an empty array of books
                var books: [Book] = []
                
                
                for item in searchResults.items{
                    //guard let volumeInfo = item.volumeInfo else {continue}
                
                    let title: String = item.volumeInfo.title
                    let subtitle: String = item.volumeInfo.subtitle ?? ""
                    let etag: String = item.etag
                    let id: String = item.id
                    //let authors: [String]
//                    let publisher: String? = item.volumeInfo.publisher
//                    let publishedDate: String? = item.volumeInfo.publishedDate
//                    let description: String? = item.volumeInfo.description
//                    //let industryIdentifiers: [IndustryIdentifier]
//                    //let readingModes: ReadingModes
//                    let pageCount: Int?  = item.volumeInfo.pageCount
//                    //let printType: PrintType
//                    //let categories: [Category]
//                    //let maturityRating: MaturityRating
//                    let allowAnonLogging: Bool = item.volumeInfo.allowAnonLogging
//                    let contentVersion: String = item.volumeInfo.contentVersion
                    let imageLinks: String = item.volumeInfo.imageLinks?.thumbnail ?? ""
//                    //let language: Language
//                    let previewLink : String = item.volumeInfo.previewLink
//                    let infoLink: String = item.volumeInfo.infoLink
//                    let canonicalVolumeLink: String = item.volumeInfo.canonicalVolumeLink
//                    //let averageRating: Double? = item.volumeInfo.averageRating?
                    //let ratingsCount: Int? = item.volumeInfo.ratingsCount?
                    //let panelizationSummary: PanelizationSummary?
                    var userReview = ""
                    var hasRead = false
                    // get isbn from industry identifiers later
                    var ISBN_13 = "1111111111111"
                    
                
                    let book = Book(id: id, etag: etag, title: title, subtitle: subtitle, imageLinks: imageLinks, hasRead: hasRead, userReview: userReview, ISBN_13: ISBN_13)
                    
                    books.append(book)
                }
                
        
                // Send back the results to the completion handler
                completion(books, nil)
                
            } catch {
                NSLog("Unable to decode data into pokemon: \(error)")
                completion(nil, error)
                //        return
            }
        }
        
        // A data task needs to be run. To start it, you call `resume`.
        // "Newly-initialized tasks begin in a suspended state, so you need to call this method to start the task."
        dataTask.resume()
    }
}
