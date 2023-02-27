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
    
    @IBAction func didTapSignOut(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Sign Out",
                                            message: "Are you sure you want to sign out?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancle",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out",
                                            style: .destructive,
                                            handler: { _ in
            AuthManager.shared.signOut(completion: { success in
                DispatchQueue.main.async {
                    if success {
                        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                        else {
                            return
                        }
                        
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: false) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    } else {
                        // error occurred
                        fatalError("Could not sign out user")
                    }
                }
            })
        }))
        
        self.present(actionSheet, animated: true)
    }
    
    
}
