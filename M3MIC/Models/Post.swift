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
    
    let postUID: String
    let userUID: String
    let timestamp: Double
    let message: String
    let replyUIDs: [String]
    let topReply: String?
    let username: String
    
    init(postUID: String, userUID: String, timestamp: Double, message: String, replyUIDs: [String] = [], topReply: String?, username: String) {
        self.postUID = postUID
        self.userUID = userUID
        self.timestamp = timestamp
        self.message = message
        self.replyUIDs = replyUIDs
        self.topReply = topReply
        self.username = username
    }
    
    init?(from dictionary: [String : Any], postUID: String) {
        guard let userUID = dictionary[Document.userUID] as? String,
            let timestamp = dictionary[Document.timestamp] as? Double,
            let message = dictionary[Document.message] as? String,
            let replyUIDs = dictionary[Document.replyUIDs] as? [String],
            let topReply = dictionary[Document.topReply] as? String?,
            let username = dictionary[Document.username] as? String
            else { print("Initializer failed in \(#function)") ; return nil }
        
        self.postUID = postUID
        self.userUID = userUID
        self.timestamp = timestamp
        self.message = message
        self.replyUIDs = replyUIDs
        self.topReply = topReply
        self.username = username
    }
}
