//
//  User.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class User {
    
    // MARK: - Properties
    let userUID: String
    let firstName: String?
    let lastName: String?
    var fullname: String? {
        return ("\(String(describing: firstName)) \(String(describing: lastName))")
    }
    
    let email: String?
    let username: String
    let password: String?
    let profilePicture: UIImage?
    
    init(userUID: String, firstName: String, lastName: String, email: String, username: String, password: String, profilePicture: UIImage?) {
        self.userUID = userUID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.password = password
        self.profilePicture = profilePicture
    }
}
