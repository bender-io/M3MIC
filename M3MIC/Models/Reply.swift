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
    let replyUID: String
    let postUID: String
    let gif: TinyGif?
    let likeCount: Int
    let rank: Rank
    
    enum Rank: String {
        case gold
        case silver
        case bronze
        case none
    }
}
