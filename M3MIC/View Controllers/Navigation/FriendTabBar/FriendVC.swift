//
//  FriendVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FriendVC: UIViewController {

    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            friendsTableView.reloadData()
            blockedTableView.reloadData()
        }
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var blockedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        blockedTableView.cornerRadios()
        friendsTableView.cornerRadios()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UserController.shared.fetchCurrentUserInfo { (error) in
            if let error = error {
                print(error)
            } else {
                self.user = UserController.shared.user
                print("Blocked: \(String(describing: self.user?.blockedUIDs)) \nFriends: \(String(describing: self.user?.friendUIDs))")
            }
        }
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toProfilePictureVC", sender: self)
    }
}

extension FriendVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
            
        case friendsTableView:
            guard let friendUIDs = user?.friendUIDs else { return 0 }
            
            return friendUIDs.count
            
        case blockedTableView:
            guard let blockedUIDs = user?.blockedUIDs else { return 0 }
            
            return blockedUIDs.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case friendsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as? FriendCell
            guard let friend = user?.friendUIDs?[indexPath.row] else { return UITableViewCell() }
            
            cell?.usernameLabel.text = friend
            cell?.profilePicture.image = #imageLiteral(resourceName: "PrimaryLogo")
            cell?.backgroundColor = UIColor.black35
            cell?.cornerRadios()
            
            return cell ?? UITableViewCell()

        case blockedTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "blockedCell") as? BlockedCell
            guard let blocked = user?.blockedUIDs?[indexPath.row] else { return UITableViewCell() }
            
            cell?.usernameLabel.text = blocked
            cell?.profilePicture.image = #imageLiteral(resourceName: "PrimaryLogo")
            cell?.backgroundColor = UIColor.black35
            cell?.cornerRadios()
            
            return cell ?? UITableViewCell()
            
        default:
            print("Incorrect tableView found in \(#function)")
        }
        
        return UITableViewCell()
    }
}
