//
//  UserModel.swift
//  INUWallet
//
//  Created by Gray on 2023/04/17.
//

import Foundation
import UIKit

class UserModel {
    static let shared = UserModel()
    
    var uid: String = ""
    var email: String = ""
    var username: String = ""
    
    var name: String = ""
    var birthdate: String = ""
    var studentID: String = ""
    var department: String = ""
    var major: String = ""
    var grade: String = ""
    var graduate: Bool?
    
    var address: String = ""
    var walletPassword: String = ""
    var privateKey: String = ""
    var publicKey: String = ""
    
    var diplomaImage: UIImage?// = UIImage()
    
    private func void() {
        
    }
    
    public func getUserModelInfo() {
        DatabaseManager.shared.getUserInfo { userInfo in
            guard let userInfo = userInfo else { return }
            UserModel.shared.address = userInfo["address"] as! String
            UserModel.shared.privateKey = userInfo["privatekey"] as! String
            
            UserModel.shared.username = userInfo["username"] as! String
            UserModel.shared.name = userInfo["name"] as! String
            UserModel.shared.studentID = userInfo["studentID"] as! String
            UserModel.shared.department = userInfo["department"] as! String
            UserModel.shared.major = userInfo["major"] as! String
            UserModel.shared.grade = userInfo["grade"] as! String
            if userInfo["graduate"] as! String == "false" {
                UserModel.shared.graduate = false
            } else {
                UserModel.shared.graduate = true
            }
        }
    }
    
}
