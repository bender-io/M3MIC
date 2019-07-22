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
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var switchLabel: UILabel!
    
    var switchIsPublic = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        headerView.backgroundColor = .black
        headerView.alpha = 0.35
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        messageTV.becomeFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        createPost()
        toDetailVC()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        messageTV.text = "What's on your mind?"
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func publicSwitchTapped(_ sender: Any) {
        switchIsPublic = !switchIsPublic
        
        if switchIsPublic {
            switchLabel.text = "Post to Public Feed"
        } else {
            switchLabel.text = "Post to Private Feed"
        }
    }
    
    func toDetailVC() {
        PostController.shared.postWasCreated = true
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
        guard let message = messageTV.text, !message.isEmpty else { print("Could not unwrap a message in \(#function)") ; return }
        guard let username = UserController.shared.user?.username else { print("Could not find username in \(#function)") ; return }
        
        PostController.shared.createPostWith(message: message, username: username) { (error) in
            if let error = error {
                print("❌ Error creating post in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
        }
        messageTV.text = "What's on your mind?"
    }
}
