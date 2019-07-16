//
//  ReplyVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit


class ReplyVC: UIViewController {
    
    let categories = ["funny", "cool", "happy", "sad", "hungry", "angry", "love"]
    
    @IBOutlet weak var gifSearchBar: UISearchBar!
    @IBOutlet weak var gifTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGifsByCategory()
        viewSetup()
    }
}

extension ReplyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell") as? CategoryCell
        let category = categories[indexPath.row]
        cell?.categoryLabel.text = category
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ReplyVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GifController.shared.gifImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCollectionCell", for: indexPath) as? CategoryCollectionCell
        let gif = GifController.shared.gifImageArray[indexPath.row]
        cell?.gifImage.image = gif
        
        return cell ?? UICollectionViewCell()
    }
}

//extension ReplyVC: GifDetailVCDelegate {
//
//    func reloadTableView() {
//        let gifDetailVC = GifDetailVC()
//        gifDetailVC.delegate = self
//
//        gifTableView.reloadData()
//    }
//}

extension ReplyVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = gifSearchBar.text, !searchText.isEmpty else { print("Search text empty") ; return }
        
        GifController.shared.fetchGifUrls(searchTerm: searchText) { (success) in
            if success {
                print("Url fetch successful")
            }
            guard let gifs = GifController.shared.gifs else { print("Could not unwrap gif urls") ; return }
            
            DispatchQueue.main.async {
                GifController.shared.fetchGifsFromUrls(tinygifs: gifs, completion: { (success) in
                    print("Success!")
                })
            }
        }
        performSegue(withIdentifier: "toGifDetailVC", sender: self)
    }
}

// MARK: - Category Methods
extension ReplyVC {
    
    func fetchGifsByCategory() {
        GifController.shared.fetchGifUrls(searchTerm: "funny") { (success) in
            if success {
                print("Url fetch successful")
            }
            guard let gifs = GifController.shared.gifs else { print("Could not unwrap gif urls") ; return }
            
            DispatchQueue.main.async {
                GifController.shared.fetchGifsFromUrls(tinygifs: gifs, completion: { (success) in
                    print("Success!")
                })
            }
        }
        self.gifTableView.reloadData()
    }
}
