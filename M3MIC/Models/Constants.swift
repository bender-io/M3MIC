//
//  Constants.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/10/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

enum Document {
    
    static let userUID = "userUID"
    static let username = "username"
    static let firstname = "firstname"
    static let lastname = "lastname"
    static let profilePicture = "profilePicture"
    
    static let postUIDs = "postUIDs"
    static let postUID = "postUID"
    static let message = "message"
    static let timestamp = "timestamp"
    
    static let replyUIDs = "replyUIDs"
    static let replyUID = "replyUID"
    static let replyImage = "replyImage"
    static let topReply = "topReply"
    
    static let blockedUIDs = "blockedUIDs"
    static let friendUIDs = "friendUIDs"
}

enum Collection {
    
    static let User = "User"
    static let Post = "Post"
    static let Reply = "Reply"
}
