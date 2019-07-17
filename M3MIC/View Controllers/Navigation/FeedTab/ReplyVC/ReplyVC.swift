//
//  ReplyVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class ReplyVC: UIViewController {
    
    // MARK: - Properties
    let categories = ["funny", "cool", "happy", "sad", "hungry", "angry", "love"]
    
    // MARK: - IBOutlets
    @IBOutlet weak var gifSearchBar: UISearchBar!
    @IBOutlet weak var gifTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
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
        fetchGifsByCategory(category)
        
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
        
        GifController.shared.fetchGifUrls(searchTerm: searchText) { (success) in
            if success {
                print("Url fetch successful")
            }
            guard let gifs = GifController.shared.gifs else { print("Could not unwrap gif urls") ; return }
            
            DispatchQueue.main.async {
                GifController.shared.fetchGifsFromUrls(tinygifs: gifs, category: "other", completion: { (success) in
                    print("Success!")
                })
            }
        }
        gifSearchBar.text = ""
        dismissKeyboard()
        performSegue(withIdentifier: "toGifDetailVC", sender: self)
    }
}

// MARK: - FetchGifsByCategory Methods
extension ReplyVC {
    
    func fetchGifsByCategory(_ category: String) {
        GifController.shared.fetchGifUrls(searchTerm: category) { (success) in
            if success {
                print("Url fetch successful")
            }
            guard let gifs = GifController.shared.gifs else { print("Could not unwrap gif urls") ; return }
            
            GifController.shared.fetchGifsFromUrls(tinygifs: gifs, category: category, completion: { (success) in
                DispatchQueue.main.async {
                    if success {
                        print("Gif appended to array")
//                        let indexPath = IndexPath(row: self.categories.firstIndex(of: category)!, section: 0)
//                        self.gifTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            })
        }
    }
}
