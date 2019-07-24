//
//  UserController.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UserController {
    
    // MARK: - Properties
    static let shared = UserController()
    private init(){}
    
    lazy var db = Firestore.firestore()
    var user: User?
    
    /// Generates a new userUID in FireStore Auth and creates a new "User" document to the "Users" collection in FireStore Database, where the document name is equal to the new userUID. Additionally, populates the new user document with empty arrays for friendUIDs, blockedUIDs, postUIDs & replyUIDs.
    ///
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    ///   - completion: completes with an error if there is one
    func createUserWith(email: String, password: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("Error creating the user in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            }
            guard let data = data else { completion(Errors.unwrapData) ; return }
            
            self.db.collection(Collection.User).document(data.user.uid).setData([
                Document.friendUIDs : [],
                Document.blockedUIDs : [],
                Document.postUIDs : [],
                Document.replyUIDs : []
                ], completion: { (error) in
                    if let error = error {
                        print("Error creating the document in \(#function) ; \(error.localizedDescription)")
                        completion(error) ; return
                    } else {
                        print("Document created with ID \(data.user.uid)")
                        completion(nil)
                    }
            })
        }
    }
    
    /// Signs the user into the account associated with the inputed email and password.
    ///
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    ///   - completion: completes with an error if there is one
    func loginUserWith(email: String, password: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("Error authenticating user in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            } else {
                print("User with UID \(String(describing: data?.user.uid)) been succesfully logged in")
                completion(nil)
            }
        }
    }
    
    
    /// Creates a new username or updates an existing username.
    ///
    /// - Parameters:
    ///   - username: user's username
    ///   - completion: completes with an error if there is one
    func updateUsername(_ username: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(Errors.noCurrentUser) ; return }
        
        db.collection(Collection.User).document(currentUser.uid).updateData([Document.username : username]) { (error) in
            if let error = error {
                print("Error updating username in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            } else {
                print("Username: \(username) has been updated")
                completion(nil)
            }
        }
    }
    
    /// Updates the current user's postUIDs field.
    ///
    /// - Parameters:
    ///   - postUID: the new postUID that is being updated
    ///   - completion: completes with an error if there is one
    func updatePostUIDsWith(postUID: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(Errors.unwrapCurrentUserUID) ; return }
        
        db.collection(Collection.User).document(currentUser.uid).updateData([
            Document.postUIDs : FieldValue.arrayUnion([postUID])
        ]) { (error) in
            if let error = error {
                print("Error updating postUID array in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            } else {
                print("Updated postUID array")
                completion(nil)
            }
        }
    }
    
    func updateReplyUIDs(with replyUID: String) {
        guard let currentUser = Auth.auth().currentUser else { print("Couldn't unwrap the current user in \(#function)") ; return }
        
        db.collection("User").document(currentUser.uid).updateData([
            Document.replyUIDs : FieldValue.arrayUnion([replyUID])
        ]) { (error) in
            if let error = error {
                print("❌ Error updating postUIDs array in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
        }
    }
    
    // MARK: - Fetch Methods
    func fetchCurrentUserInfo(completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { print("Couldn't unwrap the current user in \(#function)") ; return }
        
        db.collection(Collection.User).document(currentUser).getDocument { (document, error) in
            if let error = error {
                print("❌ Error fetching documents in \(#function) ; \(error.localizedDescription) ; \(error)")
                completion(error) ; return
            }
            guard let data = document?.data() else { print("No data found in \(#function)") ; return }
            
            self.user = User(from: data)
            completion(nil)
            print("User: \(String(describing: self.user?.username)) was fetched")
        } 
    }
    
    /// Signs out the current user
    func signOutUser() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("There was an error signing the user out in \(#function) ; \(error.localizedDescription) ; \(error)")
        }
    }
}

// MARK: - Add & Block User Methods
extension UserController {
    
    func updateBlockedUIDArrayWith(userUID: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { print("Couldn't unwrap the current user in \(#function)") ; return }
       
        guard currentUser != userUID else { print("Cannot block currentUser") ; completion(Errors.unwrapCurrentUserUID) ; return }
        
        db.collection(Collection.User).document(currentUser).updateData([
            Document.blockedUIDs : FieldValue.arrayUnion([userUID]),
            Document.friendUIDs : FieldValue.arrayRemove([userUID])
        ]) { (error) in
            if let error = error {
                print("❌ Error updating blockedUID array in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            }
            completion(nil)
        }
    }
    
    func updateFriendUIDArrayWith(userUID: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { print("Couldn't unwrap the current user in \(#function)") ; return }
        
        guard currentUser != userUID else { print("Cannot friend currentUser") ; completion(Errors.unwrapCurrentUserUID) ; return }
        
        db.collection(Collection.User).document(currentUser).updateData([
            Document.friendUIDs : FieldValue.arrayUnion([userUID]),
            Document.blockedUIDs : FieldValue.arrayRemove([userUID])
        ]) { (error) in
            if let error = error {
                print("❌ Error updating blockedUID array in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            }
            completion(nil)
        }
    }
    
    func removeFriendAndBlockedUIDArrayWith(userUID: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { print("Couldn't unwrap the current user in \(#function)") ; return }
        
        db.collection(Collection.User).document(currentUser).updateData([
            Document.friendUIDs : FieldValue.arrayRemove([userUID]),
            Document.blockedUIDs : FieldValue.arrayRemove([userUID])
        ]) { (error) in
            if let error = error {
                print("❌ Error updating blockedUID array in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            }
            completion(nil)
        }
    }
}
