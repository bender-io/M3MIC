//
//  Profile.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class User {
    
    let userUID: String
    let username: String
    let firstname: String?
    let lastname: String?
    let profilePicture: UIImage

    var fullname: String? {
        return "\(String(describing: firstname)) \(String(describing: lastname))"
    }
    
    init(userUID: String, username: String, firstname: String, lastname: String, fullname: String, profilePicture: UIImage = #imageLiteral(resourceName: "PrimaryLogo")) {
        self.userUID = userUID
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.profilePicture = profilePicture
    }
    
    init?(from dictionary: [String : Any]) {
        
        guard let userUID = dictionary[Constants.userUID] as? String,
            let username = dictionary[Constants.username] as? String,
            let firstname = dictionary[Constants.firstname] as? String,
            let lastname = dictionary[Constants.lastname] as? String,
            let profilePicture = dictionary[Constants.profilePicture] as? UIImage
            else { return nil }
        
        self.userUID = userUID
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.profilePicture = profilePicture
    }
}
