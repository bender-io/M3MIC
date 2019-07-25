//
//  Reply.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

struct Reply {
    
    let postUID: String
    let userUID: String
    let imageURL: String
    let image: UIImage?
    
    init?(from dictionary: [String : Any], image: UIImage?) {
        guard let userUID = dictionary[Document.userUID] as? String,
            let imageURL = dictionary[Document.replyImageURL] as? String,
            let postUID = dictionary[Document.postUID] as? String
            else { print("Initializer failed in \(#function)") ; return nil }
        
        self.userUID = userUID
        self.postUID = postUID
        self.imageURL = imageURL
        self.image = image
    }
}


































