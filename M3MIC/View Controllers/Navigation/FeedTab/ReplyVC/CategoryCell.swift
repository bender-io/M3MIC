//
//  CategoryCell.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate: class {
    func passCollectionCellImage(imageURL: String, image: UIImage, sender: CategoryCell)
}

class CategoryCell: UITableViewCell {
    
    // MARK: - Properties
    var category: String?
    weak var delegate: CategoryCellDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
    }
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
        cell?.gifImage.image = #imageLiteral(resourceName: "Trending")
        switch category {
            
        case "funny":
            let gif = GifController.shared.gifFunnyArray[indexPath.item]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "cool":
            let gif = GifController.shared.gifCoolArray[indexPath.item]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "happy":
            let gif = GifController.shared.gifHappyArray[indexPath.item]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "sad":
            let gif = GifController.shared.gifSadArray[indexPath.item]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "hungry":
            let gif = GifController.shared.gifHungryArray[indexPath.item]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "angry":
            let gif = GifController.shared.gifAngryArray[indexPath.item]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        case "love":
            let gif = GifController.shared.gifLoveArray[indexPath.item]
            cell?.gifImage.image = gif
            
            return cell ?? UICollectionViewCell()
            
        default:
            cell?.gifImage.image = #imageLiteral(resourceName: "PrimaryLogo")
            
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch category {
            
        case "funny":
            guard let imageURL = GifController.shared.gifs?[indexPath.item] else { return }
            
            let image = GifController.shared.gifFunnyArray[indexPath.item]
            delegate?.passCollectionCellImage(imageURL: imageURL, image: image, sender: self)
            print(image, imageURL)
            
        case "cool":
            guard let imageURL = GifController.shared.gifs?[indexPath.item] else { return }

            let image = GifController.shared.gifCoolArray[indexPath.item]
            delegate?.passCollectionCellImage(imageURL: imageURL, image: image, sender: self)
            print(image, imageURL)
            
        case "happy":
            guard let imageURL = GifController.shared.gifs?[indexPath.item] else { return }

            let image = GifController.shared.gifHappyArray[indexPath.item]
            delegate?.passCollectionCellImage(imageURL: imageURL, image: image, sender: self)
            print(image, imageURL)
            
        case "sad":
            guard let imageURL = GifController.shared.gifs?[indexPath.item] else { return }

            let image = GifController.shared.gifSadArray[indexPath.item]
            delegate?.passCollectionCellImage(imageURL: imageURL, image: image, sender: self)
            print(image, imageURL)
            
        case "hungry":
            guard let imageURL = GifController.shared.gifs?[indexPath.item] else { return }

            let image = GifController.shared.gifHungryArray[indexPath.item]
            delegate?.passCollectionCellImage(imageURL: imageURL, image: image, sender: self)
            print(image, imageURL)
            
        case "angry":
            guard let imageURL = GifController.shared.gifs?[indexPath.item] else { return }

            let image = GifController.shared.gifAngryArray[indexPath.item]
            delegate?.passCollectionCellImage(imageURL: imageURL, image: image, sender: self)
            print(image, imageURL)
            
        case "love":
            guard let imageURL = GifController.shared.gifs?[indexPath.item] else { return }

            let image = GifController.shared.gifLoveArray[indexPath.item]
            delegate?.passCollectionCellImage(imageURL: imageURL, image: image, sender: self)
            print(image, imageURL)
            
        default:
            print("Oops")
        }
    }
}


