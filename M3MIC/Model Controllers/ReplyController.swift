//
//  ReplyController.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class ReplyController {
    
    // MARK: - Properties
    static let shared = ReplyController()
    private init(){}
    
    var replies: [Reply] = []
    
    let db = UserController.shared.db
    
    // MARK: - FireStore Methods
    
    /// Creates a new "Reply" document with a replyImageURL and appends the docID to the current "User" document's replyUID array.
    ///
    /// - Parameters:
    ///   - replyImageURL: the reply's image url
    ///   - postUID: the postUID that the reply belongs to
    ///   - completion: completes with an error if there is one
    func saveReplyWith(replyImageURL: String, postUID: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(Errors.noCurrentUser) ; return }
            
        var ref: DocumentReference?
        ref = db.collection(Collection.Reply).addDocument(data: [
            Document.postUID : postUID,
            Document.userUID : currentUser.uid,
            Document.replyImageURL : replyImageURL
            ], completion: { (error) in
                if let error = error {
                    print("Error creating reply document in \(#function) ; \(error.localizedDescription)")
                    completion(error) ; return
                }
                guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID) ; return }
                
                PostController.shared.updatePostDocumentWith(replyUID: docID, replyImageURL: replyImageURL, postUID: postUID, completion: { (error) in
                    if let error = error {
                        print("Could not update Post document in \(#function) ; \(error.localizedDescription)")
                        completion(error) ; return
                    }
                })
                UserController.shared.updateUserDocumentWith(replyUID: docID, completion: { (error) in
                    if let error = error {
                        print("Error updating replyUID array in \(#function) ; \(error.localizedDescription)")
                        completion(error) ; return
                    } else {
                        print("Successfully created reply document with id: \(docID) ; with postID: \(postUID)")
                        completion(nil)
                    }
                })
        })
    }
    
    /// Fetches all replies for a post if there are any.
    ///
    /// - Parameters:
    ///   - postUID: the post uid that this function will fetch from
    ///   - completion: completes with an error if there is one
    func fetchAllRepliesFor(postUID: String, completion: @escaping(Error?) -> Void) {
        db.collection(Collection.Reply).whereField(Document.postUID, isEqualTo: postUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching reply documents in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            }
            guard let snapshot = snapshot, snapshot.count > 0 else { print("No replies found") ; completion(Errors.snapshotGuard) ; return }
            
            self.replies = snapshot.documents.compactMap { Reply(from: $0.data()) }
            completion(nil)
        }
    }
}
