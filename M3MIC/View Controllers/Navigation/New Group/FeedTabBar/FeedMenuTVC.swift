//
//  FeedMenuTVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FeedMenuTVC: UITableViewController {

    // MARK: - Properties
    let login: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            print("Username Tapped")
        case 1:
            print("Friends Tapped")
        case 2:
            print("Blocked Tapped")
        case 3:
            logoutAlertController()
        default:
            print("Default")
        }
    }
    
    // MARK: - Methods
    func logoutAlertController() {
        let alertController = UIAlertController(title: "Logout", message: "Are you ready to logout?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            print("Logout Alert Accepted")
            self.logoutUser()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(yes)
        
        // Stylize:
        let subview = alertController.view.subviews.first! as UIView
        let subviewTwo = subview.subviews.first! as UIView
        let subviewThree = subviewTwo.subviews.first! as UIView
        
        subview.tintColor = .secondary
        subviewThree.backgroundColor = .gradiantMedium
        
        self.present(alertController, animated: true)
    }
    
    func logoutUser() {
        UserController.shared.signOutUser()
        
        let loginViewController = login.instantiateViewController(withIdentifier: "LoginVC")
        UIApplication.shared.windows.first!.rootViewController = loginViewController
    }
}
