//
//  DatabaseManager.swift
//  INUWallet
//
//  Created by Gray on 2023/02/24.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    var user = UserModel.shared
    
    private let database = Database.database().reference()
    
//    private let uid = AuthManager.shared.shareUid()
    
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
        
        user.email = email
        user.username = username
        user.uid = uid
        
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
    
    public func insertUserInfo(name: String, studentID: String, department: String, major: String, grade: String) {
        let uid = AuthManager.shared.shareUid()
        
        database.child("users/\(uid)/name").setValue(name)
        database.child("users/\(uid)/studentID").setValue(studentID)
        database.child("users/\(uid)/department").setValue(department)
        database.child("users/\(uid)/major").setValue(major)
        database.child("users/\(uid)/grade").setValue(grade)
        database.child("users/\(uid)/graduate").setValue("false")
        database.child("users/\(uid)/diplomaTokenID").setValue(0)
        
        user.name = name
        user.studentID = studentID
        user.department = department
        user.major = major
        user.grade = grade
        user.graduate = false
        user.diplomaTokenID = "0"
    }
    
    // TODO: - Key 암호화 작업
    public func insertAddressInfo(address: String, key: String) {
        let uid = AuthManager.shared.shareUid()
        database.child("users/\(uid)/address").setValue(address)
        database.child("users/\(uid)/privatekey").setValue(key)
        
        user.address = address
        user.privateKey = key
    }
    
    public func insertDiplomaData() {
        
    }
    
    public func saveWalletAddress(address: String) {
        let uid = AuthManager.shared.shareUid()
        database.child("users/\(uid)/address").setValue(address)
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
    
    public func getUserInfo(completion: @escaping (NSDictionary?) -> Void) {
        let uid = AuthManager.shared.shareUid()
        
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            let userDataSnapshot = snapshot.childSnapshot(forPath: uid)
            let userItem = userDataSnapshot.value as? NSDictionary
            
            guard let userInfo = userItem else {
                completion(nil)
                return
            }
            print(userInfo)
            completion(userInfo)
        })
    }
    
}
