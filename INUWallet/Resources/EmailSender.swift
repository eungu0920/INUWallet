//
//  EmailSender.swift
//  INUWallet
//
//  Created by Gray on 2023/05/04.
//

import Foundation
import SwiftSMTP

let email: String = "inuwallet@gmail.com"
let pwd: String = "awjbnzfrcbsupthq"
let title: String = "INU Blockchain Service 인증"
let codeChar = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
var user_email: String!

let smtp = SMTP(hostname: "smtp.gmail.com", email: email, password: pwd)
let mail_from = Mail.User(name: "INU Blockchain Service 인증", email: email)
let mail_to = Mail.User(name: "mail_to", email: user_email)

func createEmailCode() -> String {
    var certiCode: String = ""
    
    for _ in 0...5 {
        let randNum = Int.random(in: 1 ..< codeChar.count)
        certiCode += codeChar[randNum]
    }

    return certiCode
}

let certiNumber = createEmailCode()

let content = "[INU Blockchain Service] E-MAIL VERIFICATION \n" + "Certification Number: [ " + certiNumber + " ] \n APP에서 인증번호를 입력해주세요."

let mail = Mail(from: mail_from, to: [mail_to], subject: title, text: content)

