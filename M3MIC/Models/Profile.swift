//
//  Profile.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class Profile {
    
    let userUID: String
    let username: String?
    let profilePicture: UIImage?
    
    init(userUID: String, username: String, profilePicture: UIImage?) {
        self.userUID = userUID
        self.username = username
        self.profilePicture = profilePicture
    }
    
    init?(from dictionary: [String : Any]) {
        guard let userUID = dictionary[Constants.userUID] as? String,
            let username = dictionary[Constants.username] as? String,
            let profilePicture = dictionary[Constants.profilePicture] as? UIImage
            else { return nil }
        
        self.userUID = userUID
        self.username = username
        self.profilePicture = profilePicture
    }
}

enum Constants {
    
    static let userUID = "userUID"
    static let username = "username"
    static let profilePicture = "profilePicture"
}
