//
//  Extension.swift
//  INUWallet
//
//  Created by Gray on 2023/02/25.
//

import UIKit

// TextField 밖을 터치했을 때 키보드 숨기기
extension UIViewController {
    public func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//Firebase Database가 "@"와 "."등의 특수기호를 허용하지 않아서 특수기호를 "-"로 치환하여 사용
extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    }
}
