//
//  HomeViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var greatingView: UIView!
    @IBOutlet weak var announceView: UIView!
    @IBOutlet weak var tokenListView: UIView!
    @IBOutlet weak var myAddressButton: UIButton!
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        greatingView.layer.cornerRadius = 8.0
        announceView.layer.cornerRadius = 8.0
        tokenListView.layer.cornerRadius = 8.0
        myAddressButton.layer.cornerRadius = 8.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 로그인이 되어있는지 확인함
        handleNotAuthenticated()
        print("vieDidAppear")
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        getUserInfo { user in
            guard let graduate = user.graduate else {
                return
            }
            
            print(graduate)
            
            if graduate == true {
                let alert = UIAlertController(title: "졸업요건 불충족",
                                              message: "졸업 요건이 불충족 되어 졸업증서를 받을 수 없습니다.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인",
                                              style: .cancel,
                                              handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "정보 확인",
                                              message: "이름: \(self.user.name)\n학번: \(self.user.studentID)\n학과: \(self.user.department)\n학년: \(self.user.grade)",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소",
                                              style: .cancel,
                                              handler: nil))
                alert.addAction(UIAlertAction(title: "확인",
                                              style: .default,
                                              handler: { _ in
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MintDiplomaViewController") as! MintDiplomaViewController
                    nextVC.user = self.user
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    private func handleNotAuthenticated() {
        print("Check")
        // Check auth status
        if Auth.auth().currentUser == nil {
            // Show log in
            guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            else {
                return
            }
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: false)
        }
    }
    
    private func getUserInfo(completion: @escaping (User) -> Void) {
        DatabaseManager.shared.getUserInfo { userInfo in
            guard let userInfo = userInfo else {
                return
            }
            self.user.address = userInfo["address"] as! String
            self.user.privateKey = userInfo["privatekey"] as! String
            self.user.name = userInfo["name"] as! String
            self.user.studentID = userInfo["studentID"] as! String
            self.user.department = userInfo["department"] as! String
            self.user.grade = userInfo["grade"] as! String
            if userInfo["graduate"] as! String == "false" {
                self.user.graduate = false
            } else {
                self.user.graduate = true
            }
            completion(self.user)
        }
    }
    
    
}
