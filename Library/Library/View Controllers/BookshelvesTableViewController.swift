//
//  BookshelvesTableViewController.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class BookshelvesTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isEnabled = false
        let activity = UIActivityIndicatorView()
        activity.style = .gray
        activity.startAnimating()
        navigationItem.titleView = activity
        
        // Fetch records from Firebase and then reload the table view
        // Note: this may be significantly delayed.
        var index = 0
        FirebaseCategories<Category>.fetchRecords { categories in
            if let categories = categories {
                Model.shared.setCategories(categories: categories)
                
                // Comment this out to show what it looks like while waiting
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.navigationItem.titleView = nil
                    self.title = "Bookshelves"
                }
            }
            index += 1
        }
    }
    
    
    @IBAction func addCategory(_ sender: Any) {
        showInputDialog()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Model.shared.countCategories()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookshelvesTableViewCell.reuseIdentifier, for: indexPath) as? BookshelvesTableViewCell else {fatalError("unable to dequeue cell")}

        let category = Model.shared.category(forIndex: indexPath.row)
        
        cell.textLabel?.text = category.name
        
        guard let count = category.books?.count else {
            cell.detailTextLabel?.text = "0"
            return cell}
        
        cell.detailTextLabel?.text = String(count)
        // Configure the cell...
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let indexPath = tableView.indexPathForSelectedRow
            else { return }
        guard let destination = segue.destination as? BookshelvesDetailTableViewController
            else { return }
        
        let category = Model.shared.category(forIndex: indexPath.row)
        destination.category = category
        destination.title = category.name
        
        
    }
    
    func showInputDialog() {
        //Create the alert controller.
        let alert = UIAlertController(title: "Add New Bookshelf", message: "(category)", preferredStyle: .alert)
        
        //Add the text field. You can configure it however you need.
        alert.addTextField { (userField) in
            userField.placeholder = "Category Name"
        }
        
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        //the confirm action taking the inputs
        let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
            guard let userField = alert?.textFields?[0] else {
                print("Issue with Alert TextFields")
                return
            }
            guard let newCategoryName = userField.text else {
                print("Issue with TextFields Text")
                return
            }
            
            let newCategory = Category(id: "", name: newCategoryName.capitalized, books: nil)
            
            Model.shared.addNewCategory(category: newCategory){
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            
            
            // Condition Logic
        })
        
        //adding the actions to alertController
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        // Presenting the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        // remove book from all categories that it exists in
        Model.shared.deleteCategory(at: indexPath.row) {
            tableView.reloadData()
        }
        
    }

}
