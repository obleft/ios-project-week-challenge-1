//
//  CellSubclassDelegate.swift
//  Library
//
//  Created by Benjamin Hakes on 12/11/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

protocol CellSubclassDelegate: class {
    func saveButtonTapped(cell: SearchTableViewCell)
}
