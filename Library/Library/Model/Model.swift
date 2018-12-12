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
    private var categories: [Category] = []
    
    // MARK: - Book Methods
    
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
    
    func setBooks(books: [Book]) {
        Model.shared.books = books
    }
    
    func setBook(book: Book) {
        
        for index in 0..<books.count {
            if books[index].id == book.id{
                books[index] = book
                return
            }
        }
        fatalError("Error: Trying to set a book that doesn't exist")
    }
    
    // MARK: - Catagory Methods
    
    func countCategories() -> Int {
        return categories.count
    }
    
    func category(forIndex index: Int) -> Category {
        return categories[index]
    }
    
    func moveCategory(from index: Int, to destinationIndex: Int) {
        let category = categories.remove(at: index)
        categories.insert(category, at: destinationIndex)
    }
    
    func setCategories(categories: [Category]) {
        Model.shared.categories = categories
    }
    
    // MARK: Core Firebase Management Methods for Book
    
    
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
    
    // MARK: Core Firebase Management Methods for Category
    
    func addNewCategory(category: Category, completion: @escaping () -> Void) {
        
        // append it to our devices array, updating our local model <-- local
        categories.append(category)
        
        // save it by pushing it to the firebase thing <-- remote
        FirebaseCategories<Category>.save(item: category){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        delegate?.modelDidUpdate()
    }
    
    func deleteCategory(at index: Int, completion: @escaping () -> Void) {
        //
        let category = categories[index]
        
        //
        categories.remove(at: index)
        
        // remote
        FirebaseCategories<Category>.delete(item: category){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        
    }
    
    
    func updateCategory(for category: Category, completion: @escaping () -> Void) {
        //
        
        // TODO: do we need this?
        //device.uuid = UUID().uuidString
        
        // remote
        FirebaseCategories<Category>.save(item: category){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        delegate?.modelDidUpdate()
    }
    
    func removeBookFromAllCategories(for book: Book, completion: @escaping () -> Void) {
        
        // remove all the references to the to-be-deleted book
        for category in categories{
            if var books = category.books{
                if books.count > 0{
                    var adjuster: Int = 0
                    for index in 0..<books.count{
                        if books[index - adjuster].id == book.id{
                            print("\(books[index - adjuster].id) and \(book.id) ")
                            books.remove(at: index - adjuster)
                            adjuster += 1
                            category.books = books
                            FirebaseCategories<Category>.save(item: category){ success in
                                guard success else {return}
                                DispatchQueue.main.async { completion()}
                            }
                        }
                    }
                }
            }
        }
        
        delegate?.modelDidUpdate()
    }
    
    func removeBookFromCategory(for book: Book, in category: Category, completion: @escaping () -> Void) {
        
        // remove all the references to the to-be-deleted book
        if var books = category.books{
            if books.count > 0{
                var adjuster: Int = 0
                for index in 0..<books.count{
                    if books[index - adjuster].id == book.id{
                        print("\(books[index - adjuster].id) and \(book.id) ")
                        books.remove(at: index - adjuster)
                        adjuster += 1
                        category.books = books
                        FirebaseCategories<Category>.save(item: category){ success in
                            guard success else {return}
                            DispatchQueue.main.async { completion()}
                        }
                    }
                }
            }
        }
        
        delegate?.modelDidUpdate()
    }
    
    // MARK: Core Model & Methods for Search
    
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
