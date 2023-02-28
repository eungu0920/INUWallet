//
//  WalletViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import Web3
import Web3ContractABI
import Web3PromiseKit
import BigInt
import UIKit


class WalletViewController: UIViewController {
    @IBOutlet weak var myWalletView: UIView!
    @IBOutlet weak var walletAddressLabel: UILabel!
    @IBOutlet weak var walletAddressTextView: UITextView!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    
    var wei_18: Double = 1000000000000000000
    
    //    var testAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWalletView.layer.cornerRadius = 15.0
        myWalletView.layer.shadowColor = UIColor.black.cgColor
        myWalletView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myWalletView.layer.shadowOpacity = 0.2
        myWalletView.layer.shadowRadius = 15.0
        
        // 이거 여백 TextView 여백 없애기
        walletAddressTextView.textContainerInset = UIEdgeInsets(top: 0,
                                                                left: -walletAddressTextView.textContainer.lineFragmentPadding,
                                                                bottom: 0,
                                                                right: 0)
        
        getWalletAddress()
//        showWalletBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 켜질 때 마다 잔액 새로고침
//        getWalletAddress()
        showWalletBalance()
        // TODO: 1. 나중에 시간날 때 balance 소수점 자르기?
    }
    
    private func getWalletAddress() {
        DatabaseManager.shared.showWalletAddress { address in
            guard let address = address else {
                return
            }
            self.walletAddressTextView.text = address
        }
    }
    
    private func showWalletBalance() {
        //Ethereum Network
        let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
        
        //        // Goerli Testnet
        //        let web3 = Web3(rpcURL: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
        
        //        // Polygon Network
        //        let web3 = Web3(rpcURL: "https://polygon-rpc.com/")
        
        DatabaseManager.shared.showWalletAddress { address in
            guard let address = address else {
                return
            }
            // 이더리움 수량 가져오기
            firstly {
                try web3.eth.getBalance(address: EthereumAddress(hex: address, eip55: true), block: .latest)
            }.done { outputs in
                let balance = Double(outputs.quantity) / self.wei_18
                self.walletBalanceLabel.text = "잔액: \(balance) ETH"
            }.catch { error in
                print("ERROR!!! : \(error)")
            }
        }
        
        
        /*
         firstly {
         web3.clientVersion()
         }.done { version in
         print("version: \(version)")
         }.catch { error in
         print("ERROR")
         }
         
         firstly {
         web3.net.version()
         }.done { version in
         print("net version: \(version)")
         }.catch { error in
         print("ERROR")
         }
         
         firstly {
         web3.net.peerCount()
         }.done { ethereumQuantity in
         print("ether Quantity : \(ethereumQuantity.quantity)")
         }.catch { error in
         print("ERROR")
         }
         */
    }
}
