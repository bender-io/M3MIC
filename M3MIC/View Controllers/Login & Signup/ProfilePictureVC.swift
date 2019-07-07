//
//  ProfilePictureVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class ProfilePictureVC: UIViewController {

    var profilePicture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoUploadVC" {
            let destinationVC = segue.destination as? PhotoUploadVC
            destinationVC?.delegate = self
        }
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "signupNavigationTBC", sender: self)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "signupNavigationTBC", sender: self)
    }
    
}

extension ProfilePictureVC: PhotoUploadVCDelegate {
    
    func profilePictureSelected(image: UIImage?) {
        guard let image = image else { return }
        profilePicture = image
    }
}
