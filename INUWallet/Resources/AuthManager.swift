//
//  AuthManager.swift
//  INUWallet
//
//  Created by Gray on 2023/02/24.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    var user = UserModel.shared
    // MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {        
        user.username = username
        user.email = email
        
        DatabaseManager.shared.canCreateUser(with: email, username: username) { canCreate in
            if canCreate {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    /*
                    guard let user = result?.user else { return }
                    
                    let data = ["email": email,
                                "username": username]
                    */
                    // Insert into Database
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    
                    DatabaseManager.shared.insertNewUser(with: email, username: username, uid: uid) { inserted in
                        if inserted {
                            completion(true)
                            return
                        } else {
                            completion(false)
                            return
                        }
                    }
                }
            } else {
                // either username or email does not exist
                completion(false)
            }
        }
        
    }
    
    public func loginUser(email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            //email sign in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            print(error)
            completion(false)
            return
        }
    }
    
    public func shareUid() -> String {
        let uid = Auth.auth().currentUser?.uid as? String ?? ""
        return uid
    }
}
