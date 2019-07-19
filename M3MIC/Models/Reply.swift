//
//  Reply.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

struct Reply {
    
    // MARK: - Properties
    let postUID: String
    let userUID: String
    let gifURL: String
//    let likeCount: Int
//    let rank: Rank
    
    init?(from dictionary: [String : Any]) {
        guard let userUID = dictionary[Document.userUID] as? String,
            let gifURL = dictionary[Document.replyImage] as? String,
            let postUID = dictionary[Document.postUID] as? String
            else { print("Initializer failed in \(#function)") ; return nil }
        
        self.userUID = userUID
        self.postUID = postUID
        self.gifURL = gifURL
    }
    
    enum Rank: String {
        case gold
        case silver
        case bronze
        case none
    }
}


































