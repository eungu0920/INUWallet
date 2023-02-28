//
//  MoreViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import UIKit

class MoreViewController: UIViewController {
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func didTapSignOutButton(_ sender: Any) {
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
