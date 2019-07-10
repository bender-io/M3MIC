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
    let navigationStoryboard: UIStoryboard = UIStoryboard(name: "Navigation", bundle: nil)
    
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
    
}
