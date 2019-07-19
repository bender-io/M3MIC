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
    
    static let shared = ReplyController()
    private init(){}
    
    var replies = [Reply]()
    private var post: Post?
    
    let db = UserController.shared.db
    
    func updateReplyUIDsWith(replyUID: String, postUID: String) {
        db.collection(Collection.Post).document(postUID).updateData([
            Document.replyUIDs : FieldValue.arrayUnion([replyUID])
        ]) { (error) in
            if let error = error {
                print("❌ Error updating postUIDs array in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
        }
    }
    
    func fetchGifReplies(postUID: String, completion: @escaping(Error?) -> Void) {
        db.collection(Collection.Reply).whereField(Document.postUID, isEqualTo: postUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("❌ Error fetching reply documents in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
            guard let snapshot = snapshot, snapshot.count > 0 else { completion(Errors.snapshotGuard) ; return }
            
            self.replies = snapshot.documents.compactMap { Reply(from: $0.data()) }
            
            print(self.replies.first?.gifURL as Any)
            completion(nil)
        }
    }
    
    func saveGifReplyWith(image: String, postUID: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { completion(Errors.noCurrentUser) ; return }
            
        var ref: DocumentReference?
        ref = db.collection("Reply").addDocument(data: [
            Document.postUID : postUID,
            Document.userUID : currentUser,
            Document.replyImage : image
            ], completion: { (error) in
                if let error = error {
                    print("❌ Error adding document in \(#function) ; \(error.localizedDescription) ; \(error)")
                    completion(error) ; return
                }
                
                guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID) ; return }
                guard let currentPost = PostController.shared.currentPost else { print("Could not unwrap currentPost in \(#function)") ; return}
                
                self.updateReplyUIDsWith(replyUID: docID, postUID: currentPost.postUID!)
                
                UserController.shared.updateReplyUIDs(with: docID)
                print("Successfully created document with id: \(docID) in postID \(String(describing: currentPost.postUID))")
                completion(nil)
        })
    }
}
