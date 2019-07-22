//
//  CreateReplyVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/17/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class CreateReplyVC: UIViewController {

    var image: UIImage?
    var imageUrl: String?
    
    @IBOutlet weak var gifImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        gifImage.image = image
    }
    
    @IBAction func saveButtonTApped(_ sender: Any) {
        guard let imageUrl = imageUrl else { print("No imageURL found in \(#function)") ; return }
        
        ReplyController.shared.saveGifReplyWith(imageURL: imageUrl, postUID: (PostController.shared.currentPost?.postUID)!) { (error) in
            if let error = error {
                print("❌ error saving gif in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
