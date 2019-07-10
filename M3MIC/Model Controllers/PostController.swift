//
//  PostController.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/9/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// TODO: - Listeners for Reply Likes and Rank

class PostController {
    
    // MARK: - Properties
    static let shared = PostController()
    private init(){}
    
    let db = UserController.shared.db
    
    var posts = [Post]()
    var postWasCreated = false
    
    
    // MARK: - CRUD Methods
    func createPostWith(message: String, timestamp: Date, replyUIDs: [String] = [], completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(Errors.noCurrentUser) ; return }
        
        var ref: DocumentReference?
        ref = db.collection("Post").addDocument(data: [
            Constants.userUID : currentUser.uid,
            Constants.message : message,
            Constants.timestamp : timestamp,
            Constants.replyUID : replyUIDs
            ], completion: { (error) in
                if let error = error {
                    print("❌ error adding document in \(#function) ; \(error.localizedDescription) ; \(error)")
                    completion(error) ; return
                }
                guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID) ; return }
                
                print("Successfully created document with id: \(docID)")
                completion(nil)
        })
    }
}
