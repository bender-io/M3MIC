//
//  FeedVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfile()
        viewSetup()
        setupTabBarUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchPosts()
        pushToDetailVC()
    }
    
    func setupTabBarUI() {
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.isTranslucent = true
    }
    
    func pushToDetailVC() {
        let feedDetailVC = UIStoryboard.init(name: "Feed", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedDetailVC") as? FeedDetailVC
        
        if PostController.shared.postWasCreated {
            
            PostController.shared.postWasCreated = false
            navigationController?.pushViewController(feedDetailVC ?? UIViewController(), animated: true)
        }
    }
}

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
    
    func fetchUrls(searchTerm: String) {
        
        GifController.shared.fetchGifUrls(searchTerm: searchTerm) { (success) in
            if success {
                DispatchQueue.main.async {
                    print("\(String(describing: GifController.shared.gifs))")
                    self.fetchGifs()
                }
            }
        }
    }
    
    func fetchGifs() {
        guard let gifs = GifController.shared.gifs else { return }
        
        GifController.shared.fetchGifsFromUrls(tinygifs: gifs) { (success) in
            DispatchQueue.main.async {
                if success {
                    print("UIImage \(GifController.shared.gifImageArray.count)")
                }
            }
        }
    }
}
