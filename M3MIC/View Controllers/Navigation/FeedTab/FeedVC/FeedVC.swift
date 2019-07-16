//
//  FeedVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    var menuIsShowing = false
    
    @IBOutlet weak var menuOverlay: UIView!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var menuLeadConstraint: NSLayoutConstraint!
    @IBOutlet weak var feedLeadConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuOverlay.isHidden = true
        fetchUserProfile()
        viewSetup()
        setupTabBarUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchPosts()
        pushToDetailVC()
    }
    @IBAction func dismissMenuTapped(_ sender: Any) {
        menuTapped()
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        menuTapped()
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
    }
    
    func setupTabBarUI() {
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.isTranslucent = true
    }
    
    func menuTapped() {
        if menuIsShowing == false {
            menuLeadConstraint.constant = 0
            feedLeadConstraint.constant = 310.5
            menuOverlay.isHidden = false
            tabBarController?.tabBar.unselectedItemTintColor = .clear
            tabBarController?.tabBar.tintColor = .clear
        } else {
            menuLeadConstraint.constant = -310.5
            feedLeadConstraint.constant = 0
            menuOverlay.isHidden = true
            tabBarController?.tabBar.unselectedItemTintColor = .gray
            tabBarController?.tabBar.tintColor = .secondary
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        menuIsShowing = !menuIsShowing
    }
    
    func pushToDetailVC() {
        let feedDetailVC = UIStoryboard.init(name: "Feed", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedDetailVC") as? FeedDetailVC
        
        if PostController.shared.postWasCreated {
            
            PostController.shared.postWasCreated = false
            navigationController?.pushViewController(feedDetailVC ?? UIViewController(), animated: true)
        }
    }
}

// MARK: - TableView Methods
extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedCell
        let post = PostController.shared.posts[indexPath.row]
        cell?.post = post
        cell?.updateViews()
        loadViewIfNeeded()
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toFeedDetailVC" {
            let indexPath = feedTableView.indexPathForSelectedRow
            let destinationVC = segue.destination as? FeedDetailVC
            let post = PostController.shared.posts[indexPath?.row ?? 0]
            destinationVC?.post = post
        }
    }
}

// MARK: - Fetch Methods
extension FeedVC {
    
    func fetchUserProfile() {
        UserController.shared.fetchUserInfo { (error) in
            if let error = error {
                print("❌ Could not fetch user info in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
            self.feedTableView.reloadData()
        }
    }
    
    func fetchPosts() {
        PostController.shared.fetchAllPosts { (error) in
            if let error = error {
                print("❌ Error fetching posts in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
            self.feedTableView.reloadData()
        }
    }
}
