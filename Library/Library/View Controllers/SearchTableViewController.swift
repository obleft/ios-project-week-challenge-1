//
//  SearchTableViewController.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, SearchTableCellDelegate {
    
    
    var onComplete: (() -> Void)? = nil
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        searchBar.delegate = self
        // TODO: Update updatehandler
        Model.shared.updateHandler = { self.tableView.reloadData() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.delegate = self
        // TODO: Update updatehandler
        Model.shared.updateHandler = { self.tableView.reloadData() }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
        
        Model.shared.deleteResults()
        
        Model.shared.search(for: searchTerm){
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Model.shared.numberOfResults()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else {fatalError("Unable to retrieve and cast cell")}
        // Configure the cell...
        
        // Configure the cell...
        let book = Model.shared.result(at: indexPath.row)
        
        // if book is already saved in the model, change the button to red and make sure that the book cannot be saved again
        for index in 0..<Model.shared.count(){
            
            let bookToCheck = Model.shared.book(forIndex: index)
            
            
            if(bookToCheck.id == book.id){
                cell.saveButton.backgroundColor = .red
                cell.saveButton.setTitle("Added", for: .normal)
                break
            } else {
                cell.saveButton.backgroundColor = colorWithHexString(hexString: "1676ff")
                cell.saveButton.setTitle("Save", for: .normal)
            }
        }
        
        // set cell delegate
        cell.delegateVariable = self
        
        // fill out the cell labels
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.authors
        cell.subtitleLabel.text = book.subtitle
        cell.tableView = self
        cell.row = indexPath.row
        
        // make sure that the imageLinks value is not nil or ""
        // if it is, early return the cell
        if book.imageLinks == nil || book.imageLinks == "" {
            cell.onComplete = { self.navigationController?.popViewController(animated: true) }
            return cell // early return cell
        }
        
        // add an 's' to conform a image URL resource to https, per Apple requirements
        var imageUrlString = book.imageLinks ?? "not_a_url"
        if imageUrlString.count > 1 {
            imageUrlString.insert("s", at: imageUrlString.index(imageUrlString.startIndex, offsetBy: 4))
        }
        
        // try to get the image and if successful assign it to bookImageView.image
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
                print("unable to get book thumbnail")
            }
        }
        
        cell.onComplete = { self.navigationController?.popViewController(animated: true) }
        

        return cell
    }
    
    // if save to collection click on a book that has already been added
    // show dialog box
    func saveToCollection(onCell: SearchTableViewCell) {
        showInputDialog()
    }
    
    
    func showInputDialog() {
        //Create the alert controller.
        let alert = UIAlertController(title: "Book already Added", message: "", preferredStyle: .alert)
        
        
        //the accept action doing nothing
        let acceptAction = UIAlertAction(title: "Accept", style: .destructive)
        
        //adding the actions to alertController
        alert.addAction(acceptAction)
        
        // Presenting the alert
        self.present(alert, animated: true, completion: nil)
    }


}

extension SearchTableViewController{
    
    func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
