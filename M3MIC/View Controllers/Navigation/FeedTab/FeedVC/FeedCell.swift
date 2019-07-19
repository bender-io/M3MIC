//
//  FeedCell.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/10/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var gifImage: UIImageView!
    
    func updateViews() {
        guard let post = post else { return }
//        profileImage.image = user.profilePicture
        usernameLabel.text = UserController.shared.user?.username
        timestampLabel.text = "\(post.timestamp)"
        messageLabel.text = post.message
    }
}
