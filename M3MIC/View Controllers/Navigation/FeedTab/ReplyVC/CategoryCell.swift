//
//  CategoryCell.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
    }
    
    // MARK: - Properties
    var category: String?
    
    // MARK: - IBOutlets
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    
}



// MARK: - CollectionView Methods
extension CategoryCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch category {
            
        case "funny":
            return GifController.shared.gifFunnyArray.count
            
        case "cool":
            return GifController.shared.gifCoolArray.count
            
        case "happy":
            return GifController.shared.gifHappyArray.count
            
        case "sad":
            return GifController.shared.gifSadArray.count
            
        case "hungry":
            return GifController.shared.gifHungryArray.count
            
        case "angry":
            return GifController.shared.gifAngryArray.count
            
        case "love":
            return GifController.shared.gifLoveArray.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCollectionCell", for: indexPath) as? CategoryCollectionCell
        
        switch category {
            
        case "funny":
            let gif = GifController.shared.gifFunnyArray[indexPath.row]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "cool":
            let gif = GifController.shared.gifCoolArray[indexPath.row]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "happy":
            let gif = GifController.shared.gifHappyArray[indexPath.row]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "sad":
            let gif = GifController.shared.gifSadArray[indexPath.row]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "hungry":
            let gif = GifController.shared.gifHungryArray[indexPath.row]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "angry":
            let gif = GifController.shared.gifAngryArray[indexPath.row]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "love":
            let gif = GifController.shared.gifLoveArray[indexPath.row]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        default:
            cell?.gifImage.image = #imageLiteral(resourceName: "PrimaryLogo")
            
            return cell ?? UICollectionViewCell()
        }
    }
}
