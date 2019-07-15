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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
}

extension ReplyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as? CategoryCell
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
        return 20
//            GifController.shared.gifImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCollection", for: indexPath) as? CategoryCollectionCell
//        cell?.gifImage = UIImageView(image: UIImage(named: "CatAvatar"))
        
        return cell ?? UICollectionViewCell()
    }
}
