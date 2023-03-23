//
//  CreateWalletViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/27.
//
import HDWalletKit
import UIKit

class CreateWalletViewController: UIViewController {
    @IBOutlet weak var textView_1: UITextView!
    @IBOutlet weak var textView_2: UITextView!
    @IBOutlet weak var textView_3: UITextView!
    @IBOutlet weak var textView_4: UITextView!
    @IBOutlet weak var textView_5: UITextView!
    @IBOutlet weak var textView_6: UITextView!
    @IBOutlet weak var textView_7: UITextView!
    @IBOutlet weak var textView_8: UITextView!
    @IBOutlet weak var textView_9: UITextView!
    @IBOutlet weak var textView_10: UITextView!
    @IBOutlet weak var textView_11: UITextView!
    @IBOutlet weak var textView_12: UITextView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var cautionLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var walletPasswordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var textViewArr: [UITextView] = []
    var userAddress = String()
    var userPrivateKey = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView_1.layer.cornerRadius = 8.0
        textView_1.text = ""
        textView_1.isEditable = false
        textViewArr.append(textView_1)
        
        textView_2.layer.cornerRadius = 8.0
        textView_2.text = ""
        textView_2.isEditable = false
        textViewArr.append(textView_2)
        
        textView_3.layer.cornerRadius = 8.0
        textView_3.text = ""
        textView_3.isEditable = false
        textViewArr.append(textView_3)
        
        textView_4.layer.cornerRadius = 8.0
        textView_4.text = ""
        textView_3.isEditable = false
        textViewArr.append(textView_4)
        
        textView_5.layer.cornerRadius = 8.0
        textView_5.text = ""
        textView_5.isEditable = false
        textViewArr.append(textView_5)
        
        textView_6.layer.cornerRadius = 8.0
        textView_6.text = ""
        textView_6.isEditable = false
        textViewArr.append(textView_6)
        
        textView_7.layer.cornerRadius = 8.0
        textView_7.text = ""
        textView_7.isEditable = false
        textViewArr.append(textView_7)
        
        textView_8.layer.cornerRadius = 8.0
        textView_8.text = ""
        textView_8.isEditable = false
        textViewArr.append(textView_8)
        
        textView_9.layer.cornerRadius = 8.0
        textView_9.text = ""
        textView_9.isEditable = false
        textViewArr.append(textView_9)
        
        textView_10.layer.cornerRadius = 8.0
        textView_10.text = ""
        textView_10.isEditable = false
        textViewArr.append(textView_10)
        
        textView_11.layer.cornerRadius = 8.0
        textView_11.text = ""
        textView_11.isEditable = false
        textViewArr.append(textView_11)
        
        textView_12.layer.cornerRadius = 8.0
        textView_12.text = ""
        textView_12.isEditable = false
        textViewArr.append(textView_12)
        
        generateButton.setTitle("Generate", for: .normal)
        createButton.setTitle("Create", for: .normal)
        
        walletPasswordField.layer.borderWidth = 1.0
        walletPasswordField.layer.borderColor = UIColor.secondaryLabel.cgColor
        walletPasswordField.layer.cornerRadius = 8.0
        walletPasswordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        walletPasswordField.leftViewMode = .always
        walletPasswordField.borderStyle = .none
        walletPasswordField.isSecureTextEntry = true
        
        repeatPasswordField.layer.borderWidth = 1.0
        repeatPasswordField.layer.borderColor = UIColor.secondaryLabel.cgColor
        repeatPasswordField.layer.cornerRadius = 8.0
        repeatPasswordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        repeatPasswordField.leftViewMode = .always
        repeatPasswordField.borderStyle = .none
        repeatPasswordField.isSecureTextEntry = true
        
        bottomStackView.alpha = 0.0
    }
    
    @IBAction func didTapGenerateButton(_ sender: Any) {
        let mnemonic = Mnemonic.create()
        let mnemonicArr: [String] = mnemonic.components(separatedBy: " ")
        var index: Int = 0
        
        for textView in textViewArr {
            textView.text = mnemonicArr[index]
            index += 1
        }
        
        bottomStackView.alpha = 1.0
        
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        print(seed.toHexString())
        
        let wallet = Wallet(seed: seed, coin: .ethereum)
        print(wallet)
        
        let firstAccount = wallet.generateAccount(at: 0)
        let privateKey = firstAccount.rawPrivateKey
        let publicKey = firstAccount.rawPublicKey

        print("address: \(firstAccount.address)")
        print("rawPrivateKey: \(firstAccount.rawPrivateKey)")
        print("rawPublicKey: \(firstAccount.rawPublicKey)")

        userAddress = firstAccount.address
        userPrivateKey = firstAccount.rawPrivateKey
        
        // TODO: - UserDefaults에 비밀번호 및 키같은 암호는 저장하면 안됨
        UserDefaults.standard.set(userAddress, forKey: "Address")
        UserDefaults.standard.set(privateKey, forKey: "PrivateKey")
        UserDefaults.standard.set(publicKey, forKey: "PublicKey")
    }
    
    @IBAction func didTapCreateButton(_ sender: Any) {
//        DatabaseManager.shared.saveWalletAddress(address: userAddress.address)
        DatabaseManager.shared.insertAddressInfo(address: userAddress, key: userPrivateKey)
        
        // TODO: - HomewViewController로 되돌아 갈 때 뷰 계층 구조가 꼬이는 것으로 확인 됨. 다른 방식으로 수정해야할 듯
        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        })
    }
}
