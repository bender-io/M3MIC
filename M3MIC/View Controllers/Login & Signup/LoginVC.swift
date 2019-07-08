//
//  LoginVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var passwordTF: MemicTF!
    @IBOutlet weak var emailTF: MemicTF!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginUser()
    }
    
    func loginUser() {
        
        guard let password = passwordTF.text, !password.isEmpty,
            let email = emailTF.text, !email.isEmpty
            else { print("Could not unwrap TF in \(#function)") ; return }
        
        UserController.shared.loginUserWith(email: email, password: password) { (error) in
            if let error = error {
                print("❌ error found in \(#function) ; \(error.localizedDescription) ; \(error)")
                self.presentLoginErrorAlert()
            }
            self.performSegue(withIdentifier: "loginNavigationTBC", sender: self)
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case emailTF:
            textField.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        case passwordTF:
            textField.resignFirstResponder()
            loginUser()
        default:
            print("Unexpected TextField is first responder in \(#function)")
        }
        return true
    }
}

extension LoginVC {
    
    func presentLoginErrorAlert() {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Login Failed", message: "The Email or Password is Incorrect", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
}
