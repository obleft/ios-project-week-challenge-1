//
//  AllBooksTableViewCell.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class AllBooksTableViewCell: UITableViewCell {

    static let reuseIdentifier = "allBooksCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!

}
