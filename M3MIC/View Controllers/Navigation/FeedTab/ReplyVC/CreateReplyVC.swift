//
//  CreateReplyVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/17/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class CreateReplyVC: UIViewController {

    var post: Post? {
        didSet {
            updateViews()
        }
    }
    var image: UIImage?
    var imageUrl: String?
    
    var gif: UIImage? {
        didSet {
            print("dang")
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        gifImage.image = image
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        loadViewIfNeeded()
        usernameLabel.text = post.username
        timestampLabel.text = Date(timeIntervalSince1970: post.timestamp).stringWith(dateStyle: .short, timeStyle: .short)
        messageLabel.text = post.message
    }
    
    @IBAction func saveButtonTApped(_ sender: Any) {
        guard let imageUrl = imageUrl else { print("No imageURL found in \(#function)") ; return }
        
        ReplyController.shared.saveGifReplyWith(imageURL: imageUrl, postUID: (PostController.shared.currentPost?.postUID)!) { (error) in
            if let error = error {
                print("❌ error saving gif in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
