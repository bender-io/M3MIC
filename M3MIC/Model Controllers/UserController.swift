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
    
    // MARK: - FireStore Auth Methods
    
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

    /// Signs out the current user
    ///
    /// - Parameter completion: completes with an error if there is one
    func signOutUser(completion: @escaping(Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
            completion(nil) ; return
        } catch {
            print("There was an error signing the user out in \(#function) ; \(error.localizedDescription)")
            completion(error)
        }
    }
    
    // MARK: - FireStore Update Methods
    
    /// Creates a new username or updates an existing username.
    ///
    /// - Parameters:
    ///   - username: user's username
    ///   - completion: completes with an error if there is one
    func updateUserDocumentWith(username: String, completion: @escaping(Error?) -> Void) {
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
    
    /// Updates the current user's postUID array field.
    ///
    /// - Parameters:
    ///   - postUID: the new postUID that is being updated to the postUID array
    ///   - completion: completes with an error if there is one
    func updateUserDocumentWith(postUID: String, completion: @escaping(Error?) -> Void) {
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
    
    /// Updates the current user's replyUID array field.
    ///
    /// - Parameters:
    ///   - replyUID: the new replyUID that is being updated to the replyUID array
    ///   - completion: completes with an error if there is one
    func updateUserDocumentWith(replyUID: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(Errors.unwrapCurrentUserUID) ; return }
        
        db.collection(Collection.User).document(currentUser.uid).updateData([
            Document.replyUIDs : FieldValue.arrayUnion([replyUID])
        ]) { (error) in
            if let error = error {
                print("Error updating replyUIDs array in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            } else {
                print("Updated replyUID array")
                completion(nil)
            }
        }
    }
    
    /// Updates the current user's blockedUID array with the userUID that is passed into the function. If the userUID is also in the friendUID array, it is removed from the friendUID array before completion is called. The userUID cannot be equal to the current user's uid.
    ///
    /// - Parameters:
    ///   - userUID: the new userUID that is being updated to the blockedUID array (cannot be equal to the current user's uid)
    ///   - completion: completes with an error if there is one
    func updateUserBlockedUIDsWith(userUID: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(Errors.noCurrentUser) ; return }

        guard currentUser.uid != userUID else { completion(Errors.userEqualsSelf) ; return }
        
        db.collection(Collection.User).document(currentUser.uid).updateData([
            Document.blockedUIDs : FieldValue.arrayUnion([userUID]),
            Document.friendUIDs : FieldValue.arrayRemove([userUID])
        ]) { (error) in
            if let error = error {
                print("Error updating blockedUID array in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            } else {
                print("Updated blockedUID array with \(userUID)")
                completion(nil)
            }
        }
    }
    
    /// Updates the current user's friendUID array with the userUID that is passed into the function. If the userUID is also in the blockedUID array, it is removed from the blockedUID array before completion is called. The userUID cannot be equal to the current user's uid.
    ///
    /// - Parameters:
    ///   - userUID: the new userUID that is being updated to the friendUID array (cannot be equal to the current user's uid)
    ///   - completion: completes with an error if there is one
    func updateUserFriendUIDsWith(userUID: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { print("Couldn't unwrap the current user in \(#function)") ; return }
        
        guard currentUser != userUID else { completion(Errors.userEqualsSelf) ; return }
        
        db.collection(Collection.User).document(currentUser).updateData([
            Document.friendUIDs : FieldValue.arrayUnion([userUID]),
            Document.blockedUIDs : FieldValue.arrayRemove([userUID])
        ]) { (error) in
            if let error = error {
                print("Error updating blockedUID array in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            } else {
                print("Updated friendUID array with \(userUID)")
                completion(nil)
            }
        }
    }

    // MARK: - FireStore Remove Method
    
    /// Removes the selected userUID from the blockedUID or friendUID array.
    ///
    /// - Parameters:
    ///   - userUID: the userUID that is being removed from the list(s)
    ///   - completion: completes with an error if there is one
    func removeFriendOrBlockedUIDWith(userUID: String, completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { completion(Errors.noCurrentUser) ; return }
        
        db.collection(Collection.User).document(currentUser).updateData([
            Document.friendUIDs : FieldValue.arrayRemove([userUID]),
            Document.blockedUIDs : FieldValue.arrayRemove([userUID])
        ]) { (error) in
            if let error = error {
                print("Error updating array in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            } else {
                print("Removed user with id \(userUID) from the array")
                completion(nil)
            }
        }
    }
    
    // MARK: - FireStore Fetch Method
    
    /// Fetches the current user's "User" document and initializes a User from the data.
    ///
    /// - Parameter completion: completes with an error if there is one
    func fetchCurrentUserInfo(completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { completion(Errors.noCurrentUser) ; return }
        
        db.collection(Collection.User).document(currentUser).getDocument { (document, error) in
            if let error = error {
                print("Error fetching current user in \(#function) ; \(error.localizedDescription)")
                completion(error) ; return
            }
            guard let data = document?.data() else { completion(Errors.unwrapData) ; return }
            
            self.user = User(from: data)
            print("Fetched user: \(String(describing: self.user?.username))")
            completion(nil)
        }
    }
}
