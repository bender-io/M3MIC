//
//  ReplyCell.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    var reply: Reply?
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    func updateViews() {
        categoryLabel.text = 
    }
}
