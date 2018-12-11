//
//  Model.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

class Model {
    
    static let shared = Model()
    private init() {}
    var delegate: ModelUpdateClient?
    
    
    typealias UpdateHandler = () -> Void
    var updateHandler: UpdateHandler? = nil
    
    private var books: [Book] = []
    
    func count() -> Int {
        return books.count
    }
    
    func book(forIndex index: Int) -> Book {
        return books[index]
    }
    
    func moveBook(from index: Int, to destinationIndex: Int) {
        let book = books.remove(at: index)
        books.insert(book, at: destinationIndex)
    }
    
    func setBook(books: [Book]) {
        Model.shared.books = books
    }
    
    // MARK: Core Database Management Methods
    
    
    func addNewBook(book: Book, completion: @escaping () -> Void) {
        
        // append it to our devices array, updating our local model <-- local
        books.append(book)
        
        // save it by pushing it to the firebase thing <-- remote
        Firebase<Book>.save(item: book){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        delegate?.modelDidUpdate()
    }
    
    func deleteBook(at indexPath: IndexPath, completion: @escaping () -> Void) {
        //
        let book = books[indexPath.row]
        
        //
        books.remove(at: indexPath.row)
        
        // remote
        Firebase<Book>.delete(item: book){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        
    }
    
    
    func updateBook(for book: Book, completion: @escaping () -> Void) {
        //
        
        // TODO: do we need this?
        //device.uuid = UUID().uuidString
        
        // remote
        Firebase<Book>.save(item: book){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        delegate?.modelDidUpdate()
    }
    
    // MARK: Core Search Functionality
    
    func search(for string: String, completion: @escaping () -> Void) {
        GoogleBooksAPI.searchForBooks(with: string) { results, error in
            if let error = error {
                NSLog("Error fetching Pokemon: \(error)")
                return
            }
            
            // Great opportunity to use nil coalescing to convert
            // a nil result into the empty array
            // TODO: Update here
            
            self.results = results ?? []
        }
    }
    
    var results: [Book] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updateHandler?()
            }
        }
    }
    
    func numberOfResults() -> Int {
        return results.count
    }
    
    func result(at index: Int) -> Book {
        return results[index]
    }
    
    func deleteResults(){
        results = []
    }
    
}
