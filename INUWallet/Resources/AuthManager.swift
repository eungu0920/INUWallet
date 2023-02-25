//
//  AuthManager.swift
//  INUWallet
//
//  Created by Gray on 2023/02/24.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    // MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String) {
        
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
}
