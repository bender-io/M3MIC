//
//  NewPostVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PostVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var headerView: UIView!
    
    var switchIsPublic = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        headerView.backgroundColor = .black
        headerView.alpha = 0.35
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        messageTextView.becomeFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        createPost()
        toDetailVC()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        messageTextView.text = "What's on your mind?"
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        messageTextView.text = ""
        messageTextView.becomeFirstResponder()
    }
    
    func toDetailVC() {
        tabBarController?.selectedIndex = 0
    }
}

extension PostVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            createPost()
            toDetailVC()
        }
        return true
    }
}

extension PostVC {
    
    func createPost() {
        guard let message = messageTextView.text, !message.isEmpty else { print("Could not unwrap a message in \(#function)") ; return }
        guard let username = UserController.shared.user?.username else { print("Could not find username in \(#function)") ; return }
        
        PostController.shared.createPostWith(message: message, username: username) { (error) in
            if let error = error {
                print("❌ Error creating post in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
        }
        messageTextView.text = "What's on your mind?"
    }
}
