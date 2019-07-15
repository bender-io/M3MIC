//
//  FeedDetailVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/8/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

// TODO: - Hide / Remove TBC for FeedDetailVC

class FeedDetailVC: UIViewController {
    
    // MARK: - Properties
    var post: Post? {
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    func toFeedVC() {
       tabBarController?.selectedIndex = 0
    }
    
    func updateViews() {
        loadViewIfNeeded()

        guard let post = post else { return }
        guard let username = UserController.shared.user?.username else { return }
        
        usernameLabel.text = username
        timestampLabel.text = "Timestamp: \(String(describing: post.timestamp))"
        profilePicture.image = #imageLiteral(resourceName: "PrimaryLogo")
        postLabel.text = post.message
    }
}
