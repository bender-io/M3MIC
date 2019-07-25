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
    
    var replies = [Reply]()
    var post: Post?
    
    var selectedImage: UIImage?
    
    let db = UserController.shared.db
    
    func fetchGifReplies(postUID: String, completion: @escaping(Error?) -> Void) {        
        db.collection(Collection.Reply).whereField(Document.postUID, isEqualTo: postUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("❌ Error fetching reply documents in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
            guard let snapshot = snapshot, snapshot.count > 0 else { completion(Errors.snapshotGuard) ; return }
            
            self.replies = snapshot.documents.compactMap { Reply(from: $0.data()) }
            
            completion(nil)
        }
    }
    
    func saveGifReplyWith(imageURL: String, postUID: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { completion(Errors.noCurrentUser) ; return }
            
        var ref: DocumentReference?
        ref = db.collection("Reply").addDocument(data: [
            Document.postUID : postUID,
            Document.userUID : currentUser,
            Document.replyImage : imageURL
            ], completion: { (error) in
                if let error = error {
                    print("❌ Error adding document in \(#function) ; \(error.localizedDescription) ; \(error)")
                    completion(error) ; return
                }
                
                guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID) ; return }
                guard let currentPost = PostController.shared.currentPost else { print("Could not unwrap currentPost in \(#function)") ; return}
                
                PostController.shared.updatePostDocumentWith(replyUID: docID, replyURL: imageURL, postUID: currentPost.postUID, completion: { (error) in
                    if let error = error {
                        print("Could not update Post document in \(#function) ; \(error.localizedDescription) ; \(error)")
                    }
                })
                
                UserController.shared.updateCurrentUserReplyUIDArrayWith(replyUID: docID, completion: { (error) in
                    if let error = error {
                        print("Error updating replyUID array in \(#function) ; \(error.localizedDescription) ; \(error)")
                    } else {
                        print("Successfully created reply document with id: \(docID) ; with postID: \(String(describing: currentPost.postUID))")
                        completion(nil)
                    }
                })
        })
    }
}
