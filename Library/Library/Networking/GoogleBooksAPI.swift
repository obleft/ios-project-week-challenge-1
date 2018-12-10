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
    static let endpoint = "https://pokeapi.co/api/v2/pokemon/"
    // Add the completion last
    static func searchForBooks(with searchTerm: String, completion: @escaping ([Book]?, Error?) -> Void) {
        
        // Establish the base url for our search
        guard let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/\(searchTerm.lowercased())/")
            else {
                fatalError("Unable to construct baseURL")
        }
        
        // Decompose it into its components
        guard let urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Unable to resolve baseURL to components")
        }
        
        // Create the query item using `search` and the search term
        // let searchQueryItem = URLQueryItem(name: "search", value: searchTerm)
        
        // Add in the search term
        // urlComponents.queryItems = [searchQueryItem]
        
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
                
                // Perform decoding into [Pokemoon] stored in PersonSearchResults
                let searchResults = try jsonDecoder.decode(BookSearchResults.self, from: data)
                
                let name = searchResults.name
                let id = searchResults.id
                let types = searchResults.types
                let abilities = searchResults.abilities
                let sprites = searchResults.sprites
                
                let book = Book(name: name, id: id, types: types, abilities: abilities, sprites: sprites)
                
                let books = [book]
                
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
