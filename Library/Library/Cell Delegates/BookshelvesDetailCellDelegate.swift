//
//  BookshelvesDetailCellDelegate.swift
//  Library
//
//  Created by Benjamin Hakes on 12/13/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

protocol BookshelvesDetailCellDelegate: class {
    func buyButtonClicked(onCell: BookshelvesDetailTableViewCell, with url: URL)
}
