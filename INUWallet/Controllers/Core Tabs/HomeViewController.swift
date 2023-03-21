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
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        getUserInfo()
    }
    
    private func handleNotAuthenticated() {
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
    
    private func getUserInfo() {
        DatabaseManager.shared.getUserInfo { userInfo in
            guard let userInfo = userInfo else {
                return
            }
            
            self.user.name = userInfo["name"] as! String
            self.user.studentID = userInfo["studentID"] as! String
            self.user.department = userInfo["department"] as! String
            self.user.grade = userInfo["grade"] as! String
            if userInfo["graduate"] as! String == "false" {
                self.user.graduate = false
            } else {
                self.user.graduate = true
            }
            print(self.user)
        }
        
        guard let graduate = self.user.graduate else {
            return
        }
        
        if graduate == true {
            let alert = UIAlertController(title: "졸업요건 불충족",
                                          message: "졸업 요건이 불충족 되어 졸업증서를 받을 수 없습니다.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            present(alert, animated: true)
        } else {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MintDiplomaViewController") as! MintDiplomaViewController
            nextVC.user = self.user
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
}
