//
//  FriendVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FriendVC: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var blockedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
}

extension FriendVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
            
        case friendsTableView:
            return 0
            
        case blockedTableView:
            return 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case friendsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell")
            return cell ?? UITableViewCell()

        case blockedTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "blockedCell")
            return cell ?? UITableViewCell()
            
        default:
            print("Incorrect tableView found in \(#function)")
        }
        
        return UITableViewCell()
    }
}
