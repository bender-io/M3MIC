//
//  FeedDetailCell.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FeedDetailCell: UITableViewCell {

    @IBOutlet weak var gifImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gifImage.cornerRadios()
    }
}
