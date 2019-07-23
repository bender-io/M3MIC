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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gifImage.cornerRadios()
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
        usernameLabel.text = post.username
        timestampLabel.text = Date(timeIntervalSince1970: post.timestamp).stringWith(dateStyle: .short, timeStyle: .short)
        messageLabel.text = post.message
    }
}
