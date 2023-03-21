//
//  Diploma.swift
//  INUWallet
//
//  Created by Gray on 2023/03/18.
//

import Foundation
import UIKit

public class DrawDiploma {
    
    var diplomaImage = UIImage()
    
    public func createDiploma(image: UIImage, userInfo: User) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // MARK: - 날짜
        let date: Date = Date()
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateTextField = dataFormatter.string(from: date)
        
        // MARK: - TxHash
        let txHashTextField: String = "0x481b58d011920d7f34e800f0c28c7d82cc94deeafebc181301b9023dff459049"
        
        // MARK: - 졸업증서 번호 (ex. 학사 제 xxx 호)
        let diplomaNumber: Int = 112356 // get tokenID
        let diplomaNumberTextField: String = "학사 제 \(diplomaNumber) 호"
        
        // MARK: - Name
//        let nameTextField: String = "횃    불    이"
        let name: String = userInfo.name
        var nameTextField: String = ""
        
        let count: Int = name.count
        var startCount: Int = 1
        
        for i in name {
            nameTextField += String(i)
            if startCount != count {
                nameTextField += "    "
                startCount += 1
            }
        }
        
        // MARK: - Birthdate
        let birthdateTextField: String = "1996. 09. 20."
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 60, weight: .semibold),
            NSAttributedString.Key.font: UIFont(name: "NanumMyeongjoOTFBold", size: 60),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let diplomaNumberAttributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 55),
            NSAttributedString.Key.font: UIFont(name: "NanumMyeongjoOTFBold", size: 55),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let txAttributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50),
            NSAttributedString.Key.font: UIFont(name: "NanumMyeongjoOTFBold", size: 50),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let dateTextFieldSize = dateTextField.size(withAttributes: attributes)
        let txHashTextFieldSize = txHashTextField.size(withAttributes: txAttributes)
        let diplomaTextFieldSize = diplomaNumberTextField.size(withAttributes: diplomaNumberAttributes)
        let nameTextFieldSize = nameTextField.size(withAttributes: diplomaNumberAttributes)
        let birthdateTextFieldSize = birthdateTextField.size(withAttributes: diplomaNumberAttributes)
        
        dateTextField.draw(in: CGRect(x: image.size.width / 2 - dateTextFieldSize.width / 2, y: image.size.height / 2 - 65, width: dateTextFieldSize.width, height: dateTextFieldSize.height), withAttributes: attributes)
        dateTextField.draw(in: CGRect(x: image.size.width / 2 - dateTextFieldSize.width / 2, y: image.size.height / 2 + 690, width: dateTextFieldSize.width, height: dateTextFieldSize.height), withAttributes: attributes)
        txHashTextField.draw(in: CGRect(x: 130, y: 2810, width: txHashTextFieldSize.width, height: txHashTextFieldSize.height), withAttributes: txAttributes)
        diplomaNumberTextField.draw(in: CGRect(x: 150, y: 320, width: diplomaTextFieldSize.width, height: diplomaTextFieldSize.height), withAttributes: diplomaNumberAttributes)
        nameTextField.draw(in: CGRect(x: 1510, y: 720, width: nameTextFieldSize.width, height: nameTextFieldSize.height), withAttributes: diplomaNumberAttributes)
        birthdateTextField.draw(in: CGRect(x: 1500, y: 800, width: birthdateTextFieldSize.width, height: birthdateTextFieldSize.height), withAttributes: diplomaNumberAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        diplomaImage = newImage ?? UIImage()
        
        StorageManager.shared.uploadDiploma(image: newImage ?? UIImage(), path: " ") { url in
            if let url = url {
                 print("url: \(url)")
            }
        }
        
        return newImage ?? UIImage()
    }
    
    public func uploadDiploma() {
        StorageManager.shared.uploadDiploma(image: diplomaImage, path: " ") { url in
            if let url = url {
                print("url: \(url)")
            }
        }
    }
    
}
