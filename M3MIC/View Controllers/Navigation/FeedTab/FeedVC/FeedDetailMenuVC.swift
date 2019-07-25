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
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addFriendButtonTapped(_ sender: Any) {
        guard let userUID = post?.userUID else { print("Could not find userUID") ; return }
        
        UserController.shared.updateUserFriendUIDsWith(userUID: userUID) { (error) in
            if error != nil {
                print(error as Any)
            } else {
                print("User with UID \(userUID) is now a friend")
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 2
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func blockButtonTapped(_ sender: Any) {
        guard let userUID = post?.userUID else { print("Could not find userUID") ; return }
        
        UserController.shared.updateUserBlockedUIDsWith(userUID: userUID) { (error) in
            if error != nil {
                print(error as Any)
            } else {
                print("User with UID \(userUID) has been blocked")
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 2
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        delegate?.dismissFeedDetailMenu(sender: self)
        print("delegating to delegate")
    }
}
