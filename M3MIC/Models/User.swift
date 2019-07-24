//
//  Profile.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class User {
    
    let username: String?
    var blockedUIDs: [String]?
    var friendUIDs: [String]?
    
    init(username: String, blockedUIDs: [String], friendUIDs: [String]) {
        self.username = username
        self.blockedUIDs = blockedUIDs
        self.friendUIDs = friendUIDs
    }
    
    init?(from dictionary: [String : Any]) {
        guard let username = dictionary[Document.username] as? String,
            let blockedUIDs = dictionary[Document.blockedUIDs] as? [String],
            let friendUIDs = dictionary[Document.friendUIDs] as? [String]
            else { print("Initializer failed in \(#function)") ; return nil }
        
        self.username = username
        self.blockedUIDs = blockedUIDs
        self.friendUIDs = friendUIDs
    }
}
