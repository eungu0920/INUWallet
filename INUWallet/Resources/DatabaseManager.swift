//
//  DatabaseManager.swift
//  INUWallet
//
//  Created by Gray on 2023/02/24.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    // MARK: - Public
    public func canCreateUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
//    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
//        let key = email.safeDatabaseKey()
//
//        database.child(key).setValue(["username": username, "email": email]) { error, _ in
//            if error == nil {
//                completion(true)
//                return
//            } else {
//                completion(false)
//                return
//            }
//        }
//
//    }
    
    public func insertNewUser(with email: String, username: String, uid: String, completion: @escaping (Bool) -> Void) {
        
        database.child("users").child(uid).setValue(["username": username, "email": email]) { error, _ in
            if error == nil {
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        }
        
    }
    
    public func saveWalletAddress(address: String, completion: @escaping (Bool) -> Void) {
        
        let uid = AuthManager.shared.shareUid()
        
        database.child("users/\(uid)/address").setValue(address) { error, _ in
            if error == nil {
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        }
    }
    
}
