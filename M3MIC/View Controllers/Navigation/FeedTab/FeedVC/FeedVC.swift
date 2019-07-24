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
    
    var posts = [Post]() {
        didSet {
            self.feedTableView.reloadData()
        }
    }
    
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
        menuClosed()
        menuIsShowing = false
    }
    
    @IBAction func dismissMenuTapped(_ sender: Any) {
        menuTapped()
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        menuTapped()
    }
    
    func setupTabBarUI() {
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.isTranslucent = true
    }
    
    func menuTapped() {
        if menuIsShowing == false {
            menuOpen()
        } else {
            menuClosed()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        menuIsShowing = !menuIsShowing
    }
    
    func menuOpen() {
        menuLeadConstraint.constant = 0
        feedLeadConstraint.constant = 310.5
        menuOverlay.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    func menuClosed() {
        menuLeadConstraint.constant = -310.5
        feedLeadConstraint.constant = 0
        menuOverlay.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - TableView Methods
extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedCell
        let post = posts[indexPath.row]
        cell?.post = post
        cell?.gifImage.image = #imageLiteral(resourceName: "SecondaryLogo")

        if let replyUrl = post.topReply {
            GifController.shared.fetchTopReplyImageFrom(url: replyUrl, completion: { (image) in
                DispatchQueue.main.async {
                    if let image = image {
                        cell?.gifImage.image = image
                    } else {
                        print("Failed to get image ; \(String(describing: post.topReply))")
                    }
                }
            })
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFeedDetailVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
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
        UserController.shared.fetchCurrentUserInfo { (error) in
            if let error = error {
                print("❌ Could not fetch user info in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
            self.feedTableView.reloadData()
        }
    }
    
    func fetchPosts() {
        let blockedUIDs = UserController.shared.user?.blockedUIDs ?? []
        PostController.shared.fetchAllPosts(blockedUIDs: blockedUIDs) { (result) in
            switch result {
            case .failure(let error):
                print("❌ Error fetching posts in \(#function) ; \(error.localizedDescription) ; \(error)")

            case .success(let posts):
                self.posts = posts
            }
        }
    }
}
