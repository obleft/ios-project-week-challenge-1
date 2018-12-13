//
//  BookDetailViewController.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    var book: Book?
    var row: Int?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookQRCodeView: UIImageView!
    @IBOutlet weak var bookReviewTextView: UITextView!
    @IBOutlet weak var hasReadButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let book = book else { return }
        (titleLabel.text, subtitleLabel.text, authorLabel.text, isbnLabel.text) = (book.title, book.subtitle, book.authors, book.ISBN_13)
        bookReviewTextView.text = book.userReview ?? ""
        
        if book.hasRead == true {
            hasReadButton.backgroundColor = .red
            hasReadButton.setTitle("Mark Unread", for: .normal)
        }
        
        if let isbn = book.ISBN_13, isbn != ""{
            var strURlToQR = "https://www.amazon.com/s?field-keywords="
            strURlToQR += isbn
            let qrImage = generateQRCOde(from: strURlToQR)
            bookQRCodeView.image = qrImage
        }
        
        var imageUrlString = book.imageLinks ?? ""
        imageUrlString.insert("s", at: imageUrlString.index(imageUrlString.startIndex, offsetBy: 4))
        
        DispatchQueue.global(qos: .background).async {
            do
            {
                let data = try Data.init(contentsOf: URL.init(string:imageUrlString)!)
                DispatchQueue.main.async {
                    let image: UIImage = UIImage(data: data)!
                    self.bookImageView.image = image
                }
            }
            catch {
                // error
                print("unable to get Book picture")
            }
        }
    }
    
    @IBAction func editReview(_ sender: Any) {
        
        bookReviewTextView.isUserInteractionEnabled = true
        bookReviewTextView.isEditable = true
        bookReviewTextView.backgroundColor = .gray
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(stopEditingReview(_:)))
    }
    
    @objc
    func stopEditingReview(_ sender: Any) {
        
        guard let book = book else {fatalError("unable to access book before editing review")}
        book.userReview = bookReviewTextView.text
        
        // update the local data model
        Model.shared.setBook(book: book)
        
        // update firebase
        Model.shared.updateBook(for: book){}
        
        bookReviewTextView.isUserInteractionEnabled = false
        bookReviewTextView.isEditable = false
        bookReviewTextView.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editReview(_:)))
    }
    
    
    
    @IBAction func hasReadButtonClicked(_ sender: Any) {
        
        guard let book = book else {fatalError("unable to access book before editing has read property")}
        
        if book.hasRead == true {
            hasReadButton.backgroundColor = .blue
            hasReadButton.setTitle("Mark Read", for: .normal)
            book.hasRead = false
            
            // update the local data model
            Model.shared.setBook(book: book)
            
            // update firebase
            Model.shared.updateBook(for: book){}
        } else {
            hasReadButton.backgroundColor = .red
            hasReadButton.setTitle("Mark Unread", for: .normal)
            book.hasRead = true
            
            // update the local data model
            Model.shared.setBook(book: book)
            
            // update firebase
            Model.shared.updateBook(for: book){}
        }
    }
    
    func generateQRCOde(from string: String)-> UIImage? {
        
        let data = string.data(using: String.Encoding.utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 1, y: 1)
            
            if let output = filter.outputImage?.transformed(by: transform){
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
