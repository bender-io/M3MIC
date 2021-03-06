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

class PostController {
    
    // MARK: - Properties
    static let shared = PostController()
    private init(){}
    
    let db = UserController.shared.db
    
    var posts: [Post] = []
    
    // MARK: - FireStore Methods
    
    /// Generates a new "Post" document and adds the postUID to the "User" document postUID array field.
    ///
    /// - Parameters:
    ///   - message: post's message
    ///   - timestamp: post's timestamp at time of creation
    ///   - replyUIDs: post's replyUID array designated for holding replies (initially empty)
    ///   - username: user.username who created post
    ///   - completion: completes with an error if there is one
    func createPostWith(message: String, timestamp: Double = Date().timeIntervalSince1970, replyUIDs: [String] = [], username: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(Errors.noCurrentUser) ; return }
        
        var ref: DocumentReference?
        ref = db.collection(Collection.Post).addDocument(data: [
            Document.userUID : currentUser.uid,
            Document.message : message,
            Document.timestamp : timestamp,
            Document.replyUIDs : replyUIDs,
            Document.username : username
            ], completion: { (error) in
                if let error = error {
                    print("Error creating document in \(#function) ; \(error.localizedDescription)")
                    completion(error) ; return
                }
                guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID) ; return }
                
                UserController.shared.updateUserDocumentWith(postUID: docID, completion: { (error) in
                    if let error = error {
                        print("Error updating postUID in \(#function) ; \(error.localizedDescription)")
                        completion(error) ; return
                    } else {
                        print("Successfully created document with id: \(docID)")
                        completion(nil)
                    }
                })
        })
    }
    
    /// Updates the selected "Post" document's replyURL field and adds the replyUID to it's replyUID array.
    ///
    /// - Parameters:
    ///   - replyUID: the reply's unique identifier
    ///   - replyURL: the reply's url that containts a gif or image
    ///   - postUID: the selected post's unique identifier
    ///   - completion: completes with an error if there is one
    func updatePostDocumentWith(replyUID: String, imageURL: String, postUID: String, completion: @escaping(Error?) -> Void) {
        db.collection(Collection.Post).document(postUID).updateData([
            Document.replyUIDs : FieldValue.arrayUnion([replyUID]),
            Document.thumbnailImageURL : imageURL
        ]) { (error) in
            if let error = error {
                print("Error updating replyUID array in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            } else {
                print("Updated post document \(postUID) with replyURL & replyUID \(replyUID)")
                completion(nil)
            }
        }
    }
    
    /// Fetches all posts where the post.userUID has not been added to the current user's blockedUID array. Filters by timestamp.
    ///
    /// - Parameters:
    ///   - blockedUIDs: the current user's blockedUID array
    ///   - completion: completes with an array of posts if successful and an error if unsuccessful
    func fetchAllPosts(blockedUIDs: [String], completion: @escaping(Result <[Post], Error>) -> Void) {
        var posts: [Post] = []
        
        db.collection(Collection.Post).order(by: Document.timestamp, descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents in \(#function) ; \(error.localizedDescription)")
                completion(.failure(error)) ; return
            }
            guard let snapshot = snapshot, snapshot.count > 0 else { completion(.failure(Errors.snapshotGuard)) ; return }

            for document in snapshot.documents {
                let data = document.data()
                guard let post = Post(from: data, postUID: document.documentID) else { completion(.failure(Errors.unwrapData)) ; return }
                
                if !blockedUIDs.contains(post.userUID) {
                    posts.append(post)
                }
            }
            self.posts = posts
            completion(.success(self.posts))
        }
    }
}
