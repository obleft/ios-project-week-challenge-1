//
//  SearchTableViewCell.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "searchResultCell"
    var row: Int = 0
    
    var onComplete: (() -> Void)? = nil
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBAction func saveToCollection(_ sender: Any) {
        
        let book = Model.shared.results[row]
        Model.shared.deleteResults()
        Model.shared.addNewBook(book: book){}
    }
    
    
}
