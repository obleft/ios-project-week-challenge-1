//
//  AddToBookshelfCellDelegate.swift
//  Library
//
//  Created by Benjamin Hakes on 12/12/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

protocol AddToBookshelfCellDelegate: class {
    func addBookToCategoryClicked(onCell: AddToBookshelfTableViewCell)
}

