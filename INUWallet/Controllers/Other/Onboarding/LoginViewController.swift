//
//  LoginViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //return 눌렀을 때 키보드 내려감
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.layer.borderWidth = 1.0
        emailField.layer.borderColor = UIColor.secondaryLabel.cgColor
        emailField.layer.cornerRadius = 8.0
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        emailField.leftViewMode = .always
        
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.borderColor = UIColor.secondaryLabel.cgColor
        passwordField.layer.cornerRadius = 8.0
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordField.leftViewMode = .always
        
        signInButton.layer.cornerRadius = 8.0
        
        //키보드 숨기기
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func didTapSigninButton(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty, email.contains("@"), email.contains(".") else {
            let message: String
            
            if emailField.text!.isEmpty {
                message = "이메일을 입력 해 주세요."
            } else {
                message = "이메일에 '@'와 '.'을 포함 해 주세요."
            }
            
            self.emailField.becomeFirstResponder()
            
            let alert = UIAlertController(title: "Email Error",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            
            self.passwordField.becomeFirstResponder()
            
            let alert = UIAlertController(title: "Password Error",
                                          message: "비밀번호를 입력 해 주세요.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        AuthManager.shared.loginUser(email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Sign in Error",
                                                  message: "We were unable to sign you in",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인",
                                                  style: .cancel,
                                                  handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func didTapCreateButton(_ sender: Any) {
        
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else {
            self.passwordField.resignFirstResponder()
            didTapSigninButton(self)
        }
        return true
    }
}
