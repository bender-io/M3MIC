//
//  Post.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class Post {
    
    // MARK: - Properties
    let postUID: String
    let userUID: String
    let username: String
    let profilePicture: UIImage
    let timestamp: Date
    let question: String
    
    // TODO: - Add new UIImage placeholder
    init(postUID: String, userUID: String, username: String, timestamp: Date = Date(), question: String, profilePicture: UIImage = #imageLiteral(resourceName: "profile_pic")) {
        self.postUID = postUID
        self.userUID = userUID
        self.username = username
        self.timestamp = timestamp
        self.question = question
        self.profilePicture = profilePicture
    }
}
