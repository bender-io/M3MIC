//
//  ProfilePictureVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/22/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FriendsProfilePictureVC: UIViewController {
    
    var profilePicture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfilePictureUploadVC" {
            let destinationVC = segue.destination as? ProfilePictureUploadVC
            destinationVC?.delegate = self
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FriendsProfilePictureVC: ProfilePictureUploadVCDelegate {
    
    func profilePictureSelected(image: UIImage?) {
        guard let image = image else { return }
        profilePicture = image
    }
}
