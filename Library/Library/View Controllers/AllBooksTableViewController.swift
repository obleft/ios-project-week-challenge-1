//
//  AllBooksTableViewController.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class AllBooksTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isEnabled = false
        let activity = UIActivityIndicatorView()
        activity.style = .gray
        activity.startAnimating()
        navigationItem.titleView = activity
        
        // Fetch records from Firebase and then reload the table view
        // Note: this may be significantly delayed.
        Firebase<Book>.fetchRecords { books in
            if let books = books {
                Model.shared.setBooks(books: books)
                
                // Comment this out to show what it looks like while waiting
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.navigationItem.titleView = nil
                    self.title = "Library"
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Model.shared.count()
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllBooksTableViewCell.reuseIdentifier, for: indexPath) as? AllBooksTableViewCell else {fatalError("Unable to retrieve and cast cell")}
        // Configure the cell...
        
        // Configure the cell...
        let book = Model.shared.book(forIndex: indexPath.row)
        
        // assign the book to the cell's book
        cell.book = book
        // fill out the cell labels
        cell.titleLabel.text = book.title
        cell.isbn_13Label.text = book.ISBN_13
        cell.authorLabel.text = book.authors
        cell.subtitleLabel.text = book.subtitle
        cell.buyButton.setTitle("Buy", for: .normal)
        
        // if the book has been read, update the has read button
        if book.hasRead == true {
            cell.hasReadButton.backgroundColor = .red
            cell.hasReadButton.setTitle("Mark Unread", for: .normal)
        }
        
        var imageUrlString = book.imageLinks ?? ""
        imageUrlString.insert("s", at: imageUrlString.index(imageUrlString.startIndex, offsetBy: 4))
        
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
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        // FIXME: Delete an item, update Firebase, update model, and reload data
        Model.shared.deleteBook(at: indexPath){
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let indexPath = tableView.indexPathForSelectedRow
            else { return }
        guard let destination = segue.destination as? BookDetailViewController
            else { return }
        
        destination.row = indexPath.row
        destination.book = Model.shared.book(forIndex: indexPath.row)
    }

}
