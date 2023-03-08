//
//  TxResultViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/03/06.
//

import SafariServices
import UIKit

class TxResultViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var transactionResultLabel: UILabel!
    @IBOutlet weak var oepnEtherscanButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var txResult: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.cornerRadius = 8.0
        
        self.transactionResultLabel.text = txResult
    }
    
    @IBAction func didTapOpenButton(_ sender: Any) {
//        // Ethereum Mainnet
//        let urlString: String = "" + txResult!
        
        // Goerli Testnet
        let urlString: String = "https://goerli.etherscan.io/tx/" + txResult
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        // WalletViewController로 이동
        self.navigationController?.popToRootViewController(animated: false)
    }
}
