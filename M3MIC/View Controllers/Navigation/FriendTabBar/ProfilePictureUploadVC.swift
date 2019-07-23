//
//  PhotoUploadVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/22/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

protocol ProfilePictureUploadVCDelegate: class {
    func profilePictureSelected(image: UIImage?)
}

class ProfilePictureUploadVC: UIViewController {
    
    // MARK: - Properties
    weak var delegate: ProfilePictureUploadVCDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
    }
    
    // MARK: - IBActions
    @IBAction func profilePictureButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    // MARK: - Methods
    func setupImage() {
        profilePicture.layer.borderWidth = 1.0
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderWidth = 3
        profilePicture.layer.borderColor = UIColor.secondary?.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
    }
}

extension ProfilePictureUploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePicture.image = image
            delegate?.profilePictureSelected(image: image)
        }
    }
    
    func presentImagePickerActionSheet() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Take or Select Photo", message: nil, preferredStyle: .actionSheet)
        
        // Image from library:
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        // Image from camera:
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        // Cancel:
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(actionSheet, animated: true)
        
        // Stylize:
        let subview = actionSheet.view.subviews.first! as UIView
        let subviewTwo = subview.subviews.first! as UIView
        let subviewThree = subviewTwo.subviews.first! as UIView
        
        subview.tintColor = .secondary
        subviewThree.backgroundColor = .primary
    }
}
