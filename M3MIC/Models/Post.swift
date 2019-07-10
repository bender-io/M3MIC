//
//  Post.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Post {
    
    // MARK: - Properties
    let postUID: String
    let userUID: String
    let username: String?
    let timestamp: Date?
    let post: String?
    let profilePicture: UIImage?
    let replyUIDs: [String]?
    
    init(postUID: String, userUID: String, username: String, timestamp: Date = Date(), post: String, profilePicture: UIImage = #imageLiteral(resourceName: "PrimaryLogo"), replyUIDs: [String] = []) {
        self.postUID = postUID
        self.userUID = userUID
        self.username = username
        self.timestamp = timestamp
        self.post = post
        self.profilePicture = profilePicture
        self.replyUIDs = replyUIDs
    }
    
    init?(from dictionary: [String : Any], postUID: String, replyUIDs: [String] = []) {
        guard let userUID = dictionary[Constants.userUID] as? String,
            let username = dictionary[Constants.username] as? String,
            let timestamp = dictionary[Constants.timestamp] as? Date,
            let post = dictionary[Constants.post] as? String,
            let profilePicture = dictionary[Constants.profilePicture] as? UIImage else { return nil }
        
        self.postUID = postUID
        self.userUID = userUID
        self.username = username
        self.timestamp = timestamp
        self.post = post
        self.profilePicture = profilePicture
        self.replyUIDs = replyUIDs
    }
    
}
