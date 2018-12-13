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
    var tableView: SearchTableViewController?
    var delegateVariable: SearchTableCellDelegate?
    var row: Int = 0
    
    var onComplete: (() -> Void)? = nil
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBAction func saveToCollection(_ sender: Any) {
        
        guard let titleText = saveButton.currentTitle else {return}
        if titleText == "Added"{
            // create the alert
            delegateVariable?.saveToCollection(onCell: self)
        }
        saveButton.backgroundColor = .red
        saveButton.setTitle("Added", for: .normal)
        let book = Model.shared.results[row]
        Model.shared.addNewBook(book: book){
        }
    }

}
