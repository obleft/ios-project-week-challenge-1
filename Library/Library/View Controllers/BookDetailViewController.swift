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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let book = book else { return }
        titleLabel.text = book.title
        
        let imageUrlString = book.imageLinks ?? ""
        
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
                fatalError("unable to get Book picture")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
