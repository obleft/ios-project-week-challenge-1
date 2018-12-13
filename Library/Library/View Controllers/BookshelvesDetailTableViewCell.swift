//
//  BookshelvesDetailTableViewCell.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class BookshelvesDetailTableViewCell: UITableViewCell {

    var book: Book?
    weak var delegateVariable: BookshelvesDetailCellDelegate?
    
    static let reuseIdentifier = "bookshelvesDetailCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var isbn_13Label: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var hasReadButton: UIButton!
    
    @IBAction func hasReadButtonClicked(_ sender: Any) {
        
        guard let book = book else {fatalError("unable to access book before editing has read property")}
        
        if book.hasRead == true {
            hasReadButton.backgroundColor = buyButton.backgroundColor
            hasReadButton.setTitle("Mark Read", for: .normal)
            book.hasRead = false
            
            // update the local data model
            Model.shared.setBook(book: book)
            
            // update firebase
            Model.shared.updateBook(for: book){}
        } else {
            hasReadButton.backgroundColor = .red
            hasReadButton.setTitle("Mark Unread", for: .normal)
            book.hasRead = true
            
            // update the local data model
            Model.shared.setBook(book: book)
            
            // update firebase
            Model.shared.updateBook(for: book){}
        }
    }
    
    @IBAction func buyButtonClicked(_ sender: Any) {
        
        guard let book = book else {fatalError("unable to access book")}
        
        if let isbn = book.ISBN_13, isbn != ""{
            var strURlToOpen = "https://www.amazon.com/s?field-keywords="
            strURlToOpen += isbn
            guard let url = URL(string: strURlToOpen) else {return}
            
            delegateVariable?.buyButtonClicked(onCell: self, with: url)
            
        }
    }
    
}
