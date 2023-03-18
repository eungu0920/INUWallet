//
//  Models.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import Foundation
import UIKit

struct User {
    var uid: String = ""
    var walletAddress: String = ""
    var email: String = ""
    var username: String = ""
    
    var name: String = ""
    var studentID: String = ""
    var department: String = ""
    var grade: String = ""
    var graduate: Bool?
    
    var walletPassword: String = ""
    
    var privateKey: String = ""
    var publicKey: String = ""
}

struct NFTInfo {
    let name: String
    let tokenID: String
    let imageName: String
    
//    let tokenURL: URL
    var image: UIImage? {
        return UIImage(named: "\(imageName).png")
    }
    
    init(name: String, tokenID: String, imageName: String) {
        self.name = name
        self.tokenID = tokenID
        self.imageName = imageName
    }
}

/*
 userdefault로 저장 - 임시
 지갑 비밀번호
 지갑 주소
 프라이빗 키
 퍼블릭키
 */
