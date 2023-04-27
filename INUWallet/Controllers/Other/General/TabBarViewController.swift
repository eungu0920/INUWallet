//
//  TabBarViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/04/11.
//

import FirebaseAuth
import UIKit

class TabBarViewController: UITabBarController {
    
    var user = UserModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabBarViewDidLoad")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("TabBarViewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        print("TabBarViewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("TabBarViewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("TabBarViewDidDisappear")
    }
    
    private func handleNotAuthenticated() {
        if Auth.auth().currentUser == nil {
            print("Open LoginVC")
            guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else { return }
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: false)
        } else {
            user.getUserModelInfo()
            print("got User Information")
        }
    }
 
}
