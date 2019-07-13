//
//  Profile.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class User {
    
//    let userUID: String
    let username: String?
//    let firstname: String?
//    let lastname: String?
//    let profilePicture: UIImage?
//
//    var fullname: String? {
//        return "\(String(describing: firstname)) \(String(describing: lastname))"
//    }
    
    init(username: String) {
//        self.userUID = userUID
        self.username = username
//        self.firstname = firstname
//        self.lastname = lastname
//        self.profilePicture = profilePicture
    }
    
    init?(from dictionary: [String : Any]) {
        
        guard let username = dictionary[Document.username] as? String
//            let firstname = dictionary[Document.firstname] as? String,
//            let lastname = dictionary[Document.lastname] as? String,
//            let profilePicture = dictionary[Document.profilePicture] as? UIImage
            else { print("Failed to initialize in \(#function)") ; return nil }
        
//        self.userUID = userUID
        self.username = username
//        self.firstname = firstname
//        self.lastname = lastname
//        self.profilePicture = profilePicture
    }
}
