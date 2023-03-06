//
//  TokenSendViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import UIKit
import Web3
import Web3PromiseKit
import Web3ContractABI

class SendTokenViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var ethBalanceLabel: UILabel!
    
    @IBOutlet weak var ethTextField: UITextField!
    @IBOutlet weak var toAddressTextField: UITextField!
    @IBOutlet weak var gasPriceTextField: UITextField!
    
    let wei_18: Double = 1000000000000000000
    let wei_9: Double = 1000000000
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setTitle("", for: .normal)
        backgroundView.layer.cornerRadius = 8.0
        sendButton.layer.cornerRadius = 8.0
        
        ethTextField.delegate = self
        toAddressTextField.delegate = self
        gasPriceTextField.delegate = self
    
        
        getWalletBalance()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSendButton(_ sender: Any) {
        ethTextField.resignFirstResponder()
        toAddressTextField.resignFirstResponder()
        gasPriceTextField.resignFirstResponder()
        
        var str: String = "0.001"
        var double: Double = Double(str)!
        
        // TODO: 각 textField 입력 양식 맞추기 (ETH: 숫자, Address: 주소, Gas Price: 기본 1.5, 1.5이상)
        let ethAmount = BigUInt(Double(ethTextField.text!)! * wei_18)
        print(ethAmount)
        let gasPrice = BigUInt(Double(gasPriceTextField.text!)! * wei_9)
        print(gasPrice)
        
        guard let toAddress = toAddressTextField.text else {
            print("ERROR")
            return
        }
        
        let alert = UIAlertController(title: "이더리움 보내기",
                                      message: "정말로 보내시겠습니까?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "확인",
                                      style: .destructive,
                                      handler: { action in
            self.send(eth: ethAmount, toAddress: toAddress, gasPrice: gasPrice)
        }))
        
        self.present(alert, animated: true)
        
    }
    
    private func getWalletBalance() {
        //        //Ethereum Network
        //        let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
        
        // Goerli Testnet
        let web3 = Web3(rpcURL: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
        
        //        // Polygon Network
        //        let web3 = Web3(rpcURL: "https://polygon-rpc.com/")
        
        // MARK: INU Token Contract Address : 0xc5E38262b06B1dba1aE63D06F538Da0E51B59e10
//        let contractAddress = try! EthereumAddress(hex: "0xc5E38262b06B1dba1aE63D06F538Da0E51B59e10", eip55: true)
//        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)
        
        DatabaseManager.shared.showWalletAddress { address in
            guard let address = address else {
                return
            }
            
            // 이더리움 수량 가져오기
            firstly {
                try web3.eth.getBalance(address: EthereumAddress(hex: address, eip55: true), block: .latest)
            }.done { outputs in
                let balance = Double(outputs.quantity) / self.wei_18
                self.ethBalanceLabel.text = "\(balance) ETH"
            }.catch { error in
                print("ERROR: \(error)")
            }
        }
    }
    
    private func send(eth: BigUInt, toAddress: String, gasPrice: BigUInt) {
//        //Ethereum Network
//        let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
        
        // Goerli Testnet
        let web3 = Web3(rpcURL: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
        
//        // Polygon Network
//        let web3 = Web3(rpcURL: "https://polygon-rpc.com/")
        
        let privateKey = try! EthereumPrivateKey(hexPrivateKey: "b68c77757faf5580cf9037044fc5e3a6f1f5e18093cfb154e4938bedcf634ecf")
        
        firstly {
            web3.eth.getTransactionCount(address: privateKey.address, block: .latest)
        }.then { nonce in
            let tx = try EthereumTransaction(
                nonce: nonce,
                gasPrice: EthereumQuantity(quantity: 150.gwei),
                maxFeePerGas: EthereumQuantity(quantity: 150.gwei),
                maxPriorityFeePerGas: EthereumQuantity(quantity: gasPrice),
                gasLimit: EthereumQuantity(quantity: 21000),
                to: EthereumAddress(hex: toAddress, eip55: true),
                value: EthereumQuantity(quantity: eth),
                accessList: [:],
                transactionType: .eip1559
            )
            
            return try tx.sign(with: privateKey, chainId: 5).promise
        }.then { tx in
            web3.eth.sendRawTransaction(transaction: tx)
        }.done { hash in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TxResultViewController") as! TxResultViewController
            nextVC.txResult = hash.hex()
            nextVC.modalTransitionStyle = .crossDissolve
            nextVC.modalPresentationStyle = .overCurrentContext
            self.present(nextVC, animated: true, completion: nil)
        }.catch { error in
            let alert = UIAlertController(title: "ERROR",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            
            print(error.localizedDescription)
            print(error)
            
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SendTokenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.ethTextField {
            self.toAddressTextField.becomeFirstResponder()
        } else if textField == self.toAddressTextField {
            self.gasPriceTextField.becomeFirstResponder()
        } else if textField == self.gasPriceTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
