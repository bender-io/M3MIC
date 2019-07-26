//
//  CreateReplyVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/17/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class CreateReplyVC: UIViewController {

    var reply: Reply?
    var post: Post? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        gifImage.image = reply?.image
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        loadViewIfNeeded()
        usernameLabel.text = post.username
        timestampLabel.text = Date(timeIntervalSince1970: post.timestamp).stringWith(dateStyle: .short, timeStyle: .short)
        messageLabel.text = post.message
    }
    
    @IBAction func saveButtonTApped(_ sender: Any) {
        guard let imageUrl = reply?.imageURL else { print("No imageURL found in \(#function)") ; return }
        guard let post = post else { print("No imageURL found in \(#function)") ; return }
        
        ReplyController.shared.saveReplyWith(imageURL: imageUrl, postUID: (post.postUID)) { (error) in
            if let error = error {
                print("Error saving gif in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
