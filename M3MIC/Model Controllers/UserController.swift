//
//  UserController.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserController {
    
    // MARK: - Properties
    static let shared = UserController()
    lazy var db = Firestore.firestore()
    
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
                Constants.friendUIDs : [],
                Constants.blockedUIDs : [],
                Constants.postUIDs : [],
                Constants.replyUIDs : []
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
        
        db.collection("User").document(currentUser.uid).updateData([Constants.username : username]) { (error) in
            if let error = error {
                print("❌ Error updating username in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
        }
    }
    
    func updateProfilePicture() {
        
    }
    
    func updatePostUIDs(with postUID: String) {
        guard let currentUser = Auth.auth().currentUser else { print("Couldn't unwrap the current user in \(#function)") ; return }
        
        db.collection("User").document(currentUser.uid).updateData([
            Constants.postUIDs : FieldValue.arrayUnion([postUID])
        ]) { (error) in
            if let error = error {
                print("❌ Error updating postUIDs array in \(#function) ; \(error.localizedDescription) ; \(error)")
            }
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
