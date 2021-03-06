//
//  SignupVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var usernameTF: MemicTF!
    @IBOutlet weak var emailTF: MemicTF!
    @IBOutlet weak var passwordTF: MemicTF!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    // MARK: - IBActions
    @IBAction func signupButtonTapped(_ sender: Any) {
        createNewUser()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createNewUser() {
        guard let username = usernameTF.text, !username.isEmpty,
            let email = emailTF.text, !email.isEmpty,
            let password = passwordTF.text, !password.isEmpty
            else { print("Could not unwrap TF in \(#function)") ; return }
        
        UserController.shared.createUserWith(email: email, password: password) { (error) in
            if let error = error {
                print("❌ Error creating a new user found in \(#function) ; \(error.localizedDescription) ; \(error)")
                self.presentSignupErrorAlert()
            } else {
                UserController.shared.updateUserDocumentWith(username: username, completion: { (error) in
                    if let error = error {
                        print("Error updating username in \(#function) ; \(error.localizedDescription) ; \(error)")
                    } else {
                        self.performSegue(withIdentifier: "toProfilePictureVC", sender: self)
                    }
                })
            }
        }
    }
}

extension SignupVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        
        case usernameTF:
            textField.resignFirstResponder()
            emailTF.becomeFirstResponder()
        case emailTF:
            textField.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        case passwordTF:
            textField.resignFirstResponder()
            createNewUser()
        default:
            print("Unexpected TextField is first responder in \(#function)")
        }
        return true
    }
}

extension SignupVC {
    
    func presentSignupErrorAlert() {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Signup Failed", message: "This Email address belongs to another account", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okay)
            self.present(alert, animated: true)
        }
    }
}
