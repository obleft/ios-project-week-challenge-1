//
//  SearchTableViewController.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

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

        return cell
    }


}
