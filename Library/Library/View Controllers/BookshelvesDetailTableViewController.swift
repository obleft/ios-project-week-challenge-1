//
//  BookshelvesDetailTableViewController.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class BookshelvesDetailTableViewController: UITableViewController {

    var category: Category?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isEnabled = false
        let activity = UIActivityIndicatorView()
        activity.style = .gray
        activity.startAnimating()
        navigationItem.titleView = activity
        
        guard let category = category else {fatalError("unable to access category")}
        
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
                    self.title = "\(category.name)"
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let category = category else {fatalError("failed to get category")}
        var countBooksInCategory: Int
        if let books = category.books {
            countBooksInCategory = books.count
        } else {
            countBooksInCategory = 0
        }
        return (countBooksInCategory)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookshelvesDetailTableViewCell.reuseIdentifier, for: indexPath) as? BookshelvesDetailTableViewCell else {fatalError("failed to deque add to bookshelf cast cell")}

        // Configure the cell...
        guard let category = category else {fatalError("failed to get category")}
        guard let books = category.books else {fatalError("failed to get book in category")}

        let book = books[indexPath.row]
        
        // assign the book to the cell's book
        cell.book = book
        // fill out the cell labels
        
        cell.titleLabel.text = book.title
        cell.isbn_13Label.text = book.ISBN_13
        cell.authorLabel.text = book.authors
        cell.subtitleLabel.text = book.subtitle
        
        // make sure that the imageLinks value is not nil or ""
        // if it is, early return the cell
        if book.imageLinks == nil || book.imageLinks == "" {
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
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        guard let category = category else {fatalError("unable to access category")}
        guard let books = category.books else {fatalError("unable to access category")}
        
        let book = books[indexPath.row]
        
        // remove book from all categories that it exists in
        Model.shared.removeBookFromCategory(for: book, in: category) {
            tableView.reloadData()
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let destination = segue.destination as? AddToBookshelfTableViewController
            else { return }
        
        destination.category = category
        
    }


}
