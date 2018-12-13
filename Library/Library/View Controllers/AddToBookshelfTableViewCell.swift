//
//  AddToBookshelfTableViewCell.swift
//  Library
//
//  Created by Benjamin Hakes on 12/12/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit
import SafariServices

class AddToBookshelfTableViewCell: UITableViewCell {

    // declare vars
    static let reuseIdentifier = "addToBookshelfCell"
    var book: Book?
    var category: Category?
    weak var delegateVariable: AddToBookshelfCellDelegate?
    
    // add IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var isbn_13Label: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var addToCategoryButton: UIButton!
    
    // add the book clicked to the category and remove it from the "potentials" list
    @IBAction func addBookToCategoryClicked(_ sender: UIButton) {
 
        // safely unwrapp book and category
        guard let book = book else {fatalError("unable to access book before editing has read property")}
        guard let category = category else {fatalError("unable to access category")}
        
        // if books already has a value in it
        if var books = category.books {
            books.append(book)
            category.books = books
            delegateVariable?.addBookToCategoryClicked(onCell: self)
            Model.shared.updateCategory(for: category) {}
            
        } else{ // if it is nil or empty
            var books: [Book] = []
            books.append(book)
            category.books = books
            delegateVariable?.addBookToCategoryClicked(onCell: self)
            Model.shared.updateCategory(for: category) {}
    
        }
    }
}
