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
    let postUID: String?
    let userUID: String
    let timestamp: Timestamp
    let message: String
    let replyUIDs: [String]
    
    init(postUID: String, userUID: String, timestamp: Timestamp, message: String, replyUIDs: [String] = []) {
        self.postUID = postUID
        self.userUID = userUID
        self.timestamp = timestamp
        self.message = message
        self.replyUIDs = replyUIDs
    }
    
    init?(from dictionary: [String : Any], postUID: String?) {
        guard let userUID = dictionary[Document.userUID] as? String,
            let timestamp = dictionary[Document.timestamp] as? Timestamp,
            let message = dictionary[Document.message] as? String,
            let replyUIDs = dictionary[Document.replyUIDs] as? [String]
            else { print("Initializer failed in \(#function)") ; return nil }
        
        self.postUID = postUID
        self.userUID = userUID
        self.timestamp = timestamp
        self.message = message
        self.replyUIDs = replyUIDs
    }
}
