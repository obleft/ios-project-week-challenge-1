//
//  AddToBookshelfTableViewController.swift
//  Library
//
//  Created by Benjamin Hakes on 12/12/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class AddToBookshelfTableViewController: UITableViewController, AddToBookshelfCellDelegate {
    
    // declare vars
    var category: Category?
    var booksAvailableToAdd: [Book] = []
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        let activity = UIActivityIndicatorView()
        activity.style = .gray
        activity.startAnimating()
        navigationItem.titleView = activity
        
        guard let category = category else {fatalError("failed to get category")}
        // Fetch records from Firebase and then reload the table view
        // Note: this may be significantly delayed.
        Firebase<Book>.fetchRecords { books in
            if let books = books {
                Model.shared.setBooks(books: books)
        
                // when fetch finishes, a
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.navigationItem.titleView = nil
                    self.title = "Add to \(category.name)"
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let category = category else {fatalError("failed to get category")}
        var countBooksInCategory: Int
        if let books = category.books {
            countBooksInCategory = books.count
        } else {
            countBooksInCategory = 0
        }
        return (Model.shared.count() - countBooksInCategory)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddToBookshelfTableViewCell.reuseIdentifier, for: indexPath) as? AddToBookshelfTableViewCell else {fatalError("failed to deque add to bookshelf cast cell")}

        // Configure the cell...
        guard let category = category else {fatalError("failed to get category")}
        let books = Model.shared.getBooks()
        booksAvailableToAdd = books
        
        // create the booksAvailableToAdd array
        if let booksInCategory = category.books{
            for bookInCategory in booksInCategory{
//                var adjuster = 0
                for index in 0..<booksAvailableToAdd.count{
                    if books[index].id == bookInCategory.id{
                        self.booksAvailableToAdd.remove(at: (index))
                    }
                }
            }
        }
        
        
        let book = booksAvailableToAdd[indexPath.row]
        // set the cell's delegate
        cell.delegateVariable = self
        
        // assign the book to the cell's book
        cell.book = book
        cell.category = category
        
        // fill out the cell labels
        cell.titleLabel.text = book.title
        cell.isbn_13Label.text = book.ISBN_13
        cell.authorLabel.text = book.authors
        cell.subtitleLabel.text = book.subtitle
        
        
        if var imageUrlString = book.imageLinks, imageUrlString != "" {
            imageUrlString.insert("s", at: imageUrlString.index(imageUrlString.startIndex, offsetBy: 4))
            
            DispatchQueue.global(qos: .background).async {
                do
                {
                    let data = try Data.init(contentsOf: URL.init(string:imageUrlString)!)
                    DispatchQueue.main.async {
                        let image: UIImage = UIImage(data: data)!
                        cell.bookImageView.image = image
                    }
                }
                catch {
                    // error
                    print("unable to get Book picture")
                }
            }
        }

        return cell
    }

    func addBookToCategoryClicked(onCell: AddToBookshelfTableViewCell) {
        tableView?.reloadData()
    }
    
}
