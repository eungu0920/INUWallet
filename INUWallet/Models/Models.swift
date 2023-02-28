//
//  Models.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import Foundation

struct User {
    let username: String
    let email: String
    let uid: String
    let walletPassword: String
    let profilePhoto: URL
    
    let walletAddress: String
    let privateKey: String
    let publicKey: String
    
    var users: [User] = []
    
    public func createNewUser() {
        var user: User
    }
}

struct Users {
    var user: [User]
    
    
}


/*
 userdefault로 저장 - 임시
 지갑 비밀번호
 지갑 주소
 프라이빗 키
 퍼블릭키
 */
