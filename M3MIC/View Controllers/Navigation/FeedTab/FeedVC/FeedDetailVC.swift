//
//  FeedDetailVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/8/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FeedDetailVC: UIViewController {
    
    @IBOutlet weak var gifTableView: UITableView!
    
    // MARK: - Properties
    var post: Post? {
        didSet {
            updateViews()
            PostController.shared.currentPost = post
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        fetchImages()
    }
    
    func updateViews() {
        loadViewIfNeeded()

        guard let username = UserController.shared.user?.username else { return }
        
        usernameLabel.text = username
        timestampLabel.text = "Timestamp: \(String(describing: post?.timestamp))"
        profilePicture.image = #imageLiteral(resourceName: "PrimaryLogo")
        postLabel.text = post?.message
    }
    
    func fetchImages() {
        
        ReplyController.shared.replies.removeAll()
        GifController.shared.gifReplyArray.removeAll()
        
        guard let postUID = post?.postUID else { print("No postUID found in \(#function)") ; return }
        
        ReplyController.shared.fetchGifReplies(postUID: postUID, completion: { (error) in
            if let error = error {
                print("❌ Error found in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
            GifController.shared.fetchGifsFromFSURLs(completion: { (success) in
                DispatchQueue.main.async {
                    if success {
                        print("Replies for \(postUID) complete")
                        self.gifTableView.reloadData()
                    }
                }
            })
        })
    }
}

extension FeedDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GifController.shared.gifReplyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell") as? FeedDetailCell
        let image = GifController.shared.gifReplyArray[indexPath.row]
        cell?.gifImage.image = image
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
}
