//
//  errors.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

enum Errors: Error {
    case personAlreadyExists
    case noCurrentUser
    case unwrapDocumentID
    case unwrapCurrentUserUID
    case snapshotGuard
    case unwrapData
    case userEqualsSelf
    case noCurrentPost
    case unwrapURL
}

extension Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .personAlreadyExists:
            return NSLocalizedString("Person already exists", comment: "")
        case .noCurrentUser:
            return NSLocalizedString("No current user", comment: "")
        case .unwrapDocumentID:
            return NSLocalizedString("Couldn't unwrap ref.documentID", comment: "")
        case .unwrapCurrentUserUID:
            return NSLocalizedString("Couldn't unwrap Auth.auth().currentUser.uid", comment: "")
        case .snapshotGuard:
            return NSLocalizedString("Failed snapshot guard", comment: "")
        case .unwrapData:
            return NSLocalizedString("Couldn't unwrap data", comment: "")
        case .userEqualsSelf:
            return NSLocalizedString("User ID cannot equal Auth.auth().currentUser.uid", comment: "")
        case .noCurrentPost:
            return NSLocalizedString("No current post", comment: "")
        case .unwrapURL:
            return NSLocalizedString("Could not unwrap url", comment: "")
        }
    }
}
