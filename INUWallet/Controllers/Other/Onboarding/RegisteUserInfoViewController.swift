//
//  RegisteUserInfoViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/03/17.
//

import UIKit

class RegisteUserInfoViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var studentIDTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var gradeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapButton(_ sender: Any) {
        DatabaseManager.shared.insertUserInfo(name: nameTextField.text!, studentID: studentIDTextField.text!, department: departmentTextField.text!, major: majorTextField.text!, grade: gradeTextField.text!)
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateWalletViewController") else { return }
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
