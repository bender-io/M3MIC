//
//  FeedDetailMenuVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/23/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

protocol FeedDetailMenuVCDelegate: class {
    func dismissFeedDetailMenu(sender: FeedDetailMenuVC)
}

class FeedDetailMenuVC: UIViewController {

    weak var delegate: FeedDetailMenuVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addFriendButtonTapped(_ sender: Any) {
        // TODO: - add friend method
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 2
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func blockButtonTapped(_ sender: Any) {
        // TODO: - block friend method
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 2
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        delegate?.dismissFeedDetailMenu(sender: self)
        print("delegating to delegate")
    }
}
