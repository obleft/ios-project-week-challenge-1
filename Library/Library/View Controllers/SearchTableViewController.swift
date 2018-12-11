//
//  SearchTableViewController.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    
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
        
        // fill out the cell labels
        cell.titleLabel.text = book.title
        cell.idLabel.text = book.id
        cell.subtitleLabel.text = book.subtitle
        
        cell.row = indexPath.row
        
        var imageUrlString = book.imageLinks ?? ""
        imageUrlString.insert("s", at: imageUrlString.index(imageUrlString.startIndex, offsetBy: 4))

        print(imageUrlString)
        
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
        
        cell.onComplete = { self.navigationController?.popViewController(animated: true) }
        

        return cell
    }


}
