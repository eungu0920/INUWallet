//
//  RegistrationViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/24.
//

// TODO: 이메일 인증 시스템 -> 인증 되면 가입 버튼 활성화
// TODO: 개인정보 취급 동의 스위치 만들기 및 받기 -> 스위치 눌러야 가입 버튼 활성화

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var verificationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRecognizer()
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        repeatPasswordField.delegate = self
        
        usernameField.becomeFirstResponder()
        
        usernameField.layer.borderWidth = 1.0
        usernameField.layer.borderColor = UIColor.secondaryLabel.cgColor
        usernameField.layer.cornerRadius = 8.0
        usernameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        usernameField.leftViewMode = .always
        usernameField.borderStyle = .none
        usernameField.autocorrectionType = .no
        
        emailField.layer.borderWidth = 1.0
        emailField.layer.borderColor = UIColor.secondaryLabel.cgColor
        emailField.layer.cornerRadius = 8.0
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        emailField.leftViewMode = .always
        emailField.borderStyle = .none
        emailField.autocorrectionType = .no
        
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.borderColor = UIColor.secondaryLabel.cgColor
        passwordField.layer.cornerRadius = 8.0
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordField.leftViewMode = .always
        passwordField.borderStyle = .none
        passwordField.isSecureTextEntry = true
        
        repeatPasswordField.layer.borderWidth = 1.0
        repeatPasswordField.layer.borderColor = UIColor.secondaryLabel.cgColor
        repeatPasswordField.layer.cornerRadius = 8.0
        repeatPasswordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        repeatPasswordField.leftViewMode = .always
        repeatPasswordField.borderStyle = .none
        repeatPasswordField.isSecureTextEntry = true
        
        signupButton.layer.cornerRadius = 8.0
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.alpha = 0
        
        backButton.setTitle("", for: .normal)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 이메일 인증
    @IBAction func didTapEmailAuthentication(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty
        else {
            return
        }
        
        user_email = email
        smtp.send(mail) { [weak self] error in
            guard let self = self else { return }
            if let err = error {
                print("Error: \(err)")
            } else {
                print("전송완료")
                signupButton.alpha = 1.0
                verificationButton.alpha = 0
            }
        }
        
        print(mail)
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailAuthenticaionViewController") as! EmailAuthenticaionViewController
        nextVC.modalPresentationStyle = .formSheet
        self.present(nextVC, animated: true)
        
    }
    
    // MARK: - 회원가입
    @IBAction func didTapCreateAccountButton(_ sender: Any) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        repeatPasswordField.resignFirstResponder()
        usernameField.resignFirstResponder()
        
        guard let username = usernameField.text, !username.isEmpty
        else {
            let alert = UIAlertController(title: "Username Error",
                                          message: "이름을 입력 해 주세요.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert, animated: true)
            
            self.usernameField.becomeFirstResponder()
            
            return
        }
        
        guard let email = emailField.text, !email.isEmpty, email.contains("@"), email.contains(".")
        else {
            let massage: String
            
            if emailField.text!.isEmpty {
                massage = "이메일을 입력 해 주세요."
            } else {
                massage = "이메일에 '@'와 '.'을 포함하여 입력 해 주세요."
            }
            
            self.emailField.becomeFirstResponder()
            
            let alert = UIAlertController(title: "Email Error",
                                          message: massage,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty,
              let passwordCheck = repeatPasswordField.text, !passwordCheck.isEmpty, password == passwordCheck
        else {
            let massage: String
            
            if passwordField.text!.isEmpty {
                massage = "비밀번호를 입력 해 주세요."
                self.passwordField.becomeFirstResponder()
            } else if repeatPasswordField.text!.isEmpty {
                massage = "비밀번호 확인을 입력 해 주세요."
                self.repeatPasswordField.becomeFirstResponder()
            } else {
                massage = "비멀번호와 비밀번호 확인이 맞지 않습니다."
                self.passwordField.becomeFirstResponder()
            }
            
            let alert = UIAlertController(title: "Password Error",
                                          message: massage,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { registered in
            DispatchQueue.main.async {
                if registered {
                    guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisteUserInfoViewController") else { return }
                    nextVC.modalPresentationStyle = .fullScreen
                    
                    self.present(nextVC, animated: true, completion: nil)
                } else {
                    
                }
            }
        }
        
    }
    
    // MARK: - 오른쪽으로 스와이프 했을 때 뒤로가기
    // TODO: 애니매이션이 아래로 내려가는데 오른쪽에서 왼쪽으로 넘어가게 바꾸기
    func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameField {
            self.emailField.becomeFirstResponder()
        } else if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.repeatPasswordField.becomeFirstResponder()
        } else {
            didTapCreateAccountButton(self)
        }
        return true
    }
}
