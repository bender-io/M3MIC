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
    lazy var db = Firestore.firestore()
    
    var user: User?
    var blockedUsers = [String]()
    var userToFriend = [String]()
    
    /// Creates a new "User" document to the "Users" collection in FireStore. At inception, each user generates a userUID. Additionaly, each user sets an empty array for friendUID (other userUID's that the user can find on their friend's list), blockedUID (other userUID's that are blocked from the user) and a profileUID, which links the user to their profile data.
    ///
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    ///   - completion: completes with an error if there is one
    func signupUserWith(email: String, password: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("❌ Error creating the user in \(#function) ; \(error.localizedDescription) ; \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { completion(Errors.unwrapData) ; return }
            
            self.db.collection("User").document(data.user.uid).setData([
                Document.friendUIDs : [],
                Document.blockedUIDs : [],
                Document.postUIDs : [],
                Document.replyUIDs : []
                ], completion: { (error) in
                    if let error = error {
                        print("❌ Error creating user document in \(#function) ; \(error.localizedDescription) ; \(error)")
                        completion(error) ; return
                    } else {
                        print("Document created with ID \(data.user.uid)")
                    }
                })
            completion(nil)
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
                print("❌ Error authenticating user in \(#function) ; \(error.localizedDescription) ; \(error)")
                completion(error) ; return
            } else {
                print("User has been succesfully logged in")
                completion(nil)
            }
        }
    }
    
    func createUsername(_ username: String) {
        guard let currentUser = Auth.auth().currentUser else { print("Couldn't unwrap the current user in \(#function)") ; return }
        
        db.collection("User").document(currentUser.uid).updateData([Document.username : username]) { (error) in
            if let error = error {
                print("❌ Error updating username in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
        }
    }
    
    func updatePostUIDs(with postUID: String) {
        guard let currentUser = Auth.auth().currentUser else { print("Couldn't unwrap the current user in \(#function)") ; return }
        
        db.collection("User").document(currentUser.uid).updateData([
            Document.postUIDs : FieldValue.arrayUnion([postUID])
        ]) { (error) in
            if let error = error {
                print("❌ Error updating postUIDs array in \(#function) ; \(error.localizedDescription) ; \(error)")
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
}
