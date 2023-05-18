//
//  EmailAuthenticaionViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/05/04.
//

import UIKit
import SwiftSMTP

class EmailAuthenticaionViewController: UIViewController {
    @IBOutlet weak var authenticationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EmailAuthenticationViewController")
        
        authenticationTextField.layer.borderWidth = 1.0
        authenticationTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        authenticationTextField.layer.cornerRadius = 8.0
        authenticationTextField.borderStyle = .none
        authenticationTextField.autocorrectionType = .no
        
        doneButton.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(user_email)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        let inputNumber = authenticationTextField.text
        
        if inputNumber == certiNumber {
            let alert = UIAlertController(title: "인증완료",
                                          message: "이메일 인증이 완료되었습니다.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .default,
                                          handler: { _ in
                UserModel.shared.emailVerification = true
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)            
        } else {
            let alert = UIAlertController(title: "인증실패",
                                          message: "인증번호가 다릅니다.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert, animated: true)
        }
        
    }
}
