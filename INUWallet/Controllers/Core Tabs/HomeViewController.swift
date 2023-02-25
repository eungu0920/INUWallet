//
//  HomeViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 로그인이 되어있는지 확인함
        handleNotAuthenticated()
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
//            let loginVC = LoginViewController()
//            loginVC.modalPresentationStyle = .fullScreen
//            present(loginVC, animated: false)
        }
    }
    
}
