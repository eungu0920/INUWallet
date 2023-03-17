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
    
    public func saveWalletAddress(address: String) {
        let uid = AuthManager.shared.shareUid()
        
//        database.child("users/\(uid)/address").setValue(address) { error, _ in
//            if error == nil {
//                return
//            } else {
//                return
//            }
//        }
        
        database.child("users/\(uid)/address").setValue(address)
        
    }
    
    public func insertUserInfo(name: String, studentID: String, department: String, grade: String) {
        let uid = AuthManager.shared.shareUid()
    
        database.child("users/\(uid)/name").setValue(name)
        database.child("users/\(uid)/studentID").setValue(studentID)
        database.child("users/\(uid)/department").setValue(department)
        database.child("users/\(uid)/grade").setValue(grade)
        database.child("users/\(uid)/graduate").setValue("false")
        
    }
    
    public func showWalletAddress(completion: @escaping (String?) -> Void) {
        let uid = AuthManager.shared.shareUid()
        
        database.child("users/\(uid)/address").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let address = snapshot?.value as? String else {
                completion(nil)
                return
            }
            completion(address)
        }
    }
    
    public func getGraduate(completion: @escaping (String?) -> Void) {
        let uid = AuthManager.shared.shareUid()
        
        database.child("users/\(uid)/graduate").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let graduate = snapshot?.value as? String else {
                completion(nil)
                return
            }
            completion(graduate)
        }
    }
    
}
