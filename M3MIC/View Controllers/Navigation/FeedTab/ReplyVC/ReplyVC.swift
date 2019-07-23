//
//  ReplyVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class ReplyVC: UIViewController, CategoryCellDelegate {
    
    func passCollectionCellImage(with gif: UIImage, sender: CategoryCell) {
        guard let gifVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "createVC") as? CreateReplyVC else { return }
        gifVC.image = gif
        gifVC.post = post
        navigationController?.pushViewController(gifVC, animated: true)
    }
    
    // MARK: - Properties
    let categories = ["funny", "cool", "happy", "sad", "hungry", "angry", "love"]
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var gifSearchBar: UISearchBar!
    @IBOutlet weak var gifTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        fetchGifImages()
    }
    
    @IBAction func trendingButtonTapped(_ sender: Any) {
        GifController.shared.fetchGifUrls(searchTerm: "trending") { (success) in
            if success {
                print("Url fetch successful")
            }
            guard let gifs = GifController.shared.gifs else { print("Could not unwrap gif urls") ; return }
            
            GifController.shared.fetchGifsFromUrls(tinygifs: gifs, category: "other", completion: { (success) in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toGifDetailVC", sender: self)
                }
            })
        }
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        loadViewIfNeeded()
        usernameLabel.text = post.username
        timestampLabel.text = Date(timeIntervalSince1970: post.timestamp).stringWith(dateStyle: .short, timeStyle: .short)
        messageLabel.text = post.message
    }
}

// MARK: - TableView Methods
extension ReplyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell") as? CategoryCell
        let category = categories[indexPath.row]
        cell?.categoryLabel.text = category
        cell?.category = category
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - SearchBar Methods
extension ReplyVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = gifSearchBar.text, !searchText.isEmpty else { print("Search text empty") ; return }
        
        self.gifSearchBar.text = ""
        self.dismissKeyboard()
        
        GifController.shared.fetchGifUrls(searchTerm: searchText) { (success) in
            if success {
                print("Url fetch successful")
            }
            guard let gifs = GifController.shared.gifs else { print("Could not unwrap gif urls") ; return }
            
            GifController.shared.fetchGifsFromUrls(tinygifs: gifs, category: "other", completion: { (success) in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toGifDetailVC", sender: self)
                }
            })
        }
    }
}

// MARK: - FetchGifsByCategory Methods
extension ReplyVC {
    
    func fetchGifImages() {
        for category in categories {
            fetchGifsByCategory(Category(rawValue: category)!)
        }
    }
    
    
    func fetchGifsByCategory(_ category: Category) {
        GifController.shared.fetchGifUrls(searchTerm: category.rawValue) { (success) in
            if success {
                print("\(category) url fetch successful")
            }
            guard let gifs = GifController.shared.gifs else { print("Could not unwrap gif urls") ; return }
            
            GifController.shared.fetchGifsFromUrls(tinygifs: gifs, category: category.rawValue, completion: { (success) in
                DispatchQueue.main.async {
                    if success {
                        print("[\(category)] complete!")
                        
                        // find indexpath based on the category's place in its array
                        let indexPath = IndexPath(row: self.categories.firstIndex(of: category.rawValue)!, section: 0)
                        
                        // use indexpath to get cell
                        let cell = self.gifTableView.cellForRow(at: indexPath) as? CategoryCell
                        
                        // drill into cell collectionview and reload data
                        cell?.categoryCollection.reloadData()
                        
                    }
                }
            })
        }
    }
}

// MARK: - Prepare for Segue
extension ReplyVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGifDetailVC" {
            let destinationVC = segue.destination as? GifDetailVC
            let post = self.post
            destinationVC?.post = post
        }
    }
}



enum Category: String {
    case funny
    case cool
    case happy
    case sad
    case hungry
    case angry
    case love
}
