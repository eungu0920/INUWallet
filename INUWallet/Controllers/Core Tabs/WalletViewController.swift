//
//  WalletViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

/*
 INUWallet Test Account : 0xf0dd0689C7c53c98ffC873C5487A27FCd1a7ab39
 Private Key : f6252aed5d5197f488d129ce42bd30db0a75b6c09fa660a09bb64fcf96b942e8
 */


import UIKit
import Web3
import Web3PromiseKit
import Web3ContractABI

class WalletViewController: UIViewController {
    @IBOutlet weak var myWalletView: UIView!
    @IBOutlet weak var myTokenView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var walletAddressButton: UIButton!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    
    @IBOutlet weak var INUTokenBalanceLabel: UILabel!
    
    
    let wei_18: Double = 1000000000000000000
    
//    private let spinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView(style: .medium)
//        spinner.hidesWhenStopped = true
//        spinner.tintColor = .label
//        return spinner
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWalletView.layer.cornerRadius = 15.0
        myWalletView.layer.shadowColor = UIColor.black.cgColor
        myWalletView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myWalletView.layer.shadowOpacity = 0.4
        myWalletView.layer.shadowRadius = 15.0

        myTokenView.layer.cornerRadius = 15.0
        myTokenView.layer.shadowColor = UIColor.black.cgColor
        myTokenView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myTokenView.layer.shadowOpacity = 0.4
        myTokenView.layer.shadowRadius = 15.0
        
        usernameLabel.text = UserDefaults.standard.value(forKey: "Username") as? String
        print("WalletViewDidLoad")
        
        // 이거 여백 TextView 여백 없애기
//        walletAddressTextView.textContainerInset = UIEdgeInsets(top: 0,
//                                                                left: -walletAddressTextView.textContainer.lineFragmentPadding,
//                                                                bottom: 0,
//                                                                right: 0)
//        walletAddressButton.setTitle("", for: .normal)
//        walletAddressButton.setImage(.none, for: .normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 켜질 때 마다 잔액 새로고침
        // TODO: 1. 나중에 시간날 때 balance 소수점 자르기?
        print("WalletViewWillAppear")
        
        // SendTokenViewController, TxResultViewController에서 navigationBar를 감춰놨으므로 뷰가 나타나기전에 true 시켜줌
        // TODO: push, pop 할 때 애니메이션 변경하기
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getWalletAddress()
        showWalletBalance()
    }
    
    
    @IBAction func didTapSendButton(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendTokenViewController") as! SendTokenViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func didTapReceiveButton(_ sender: Any) {
    }
    
    // 지갑주소를 받아와서 앞과 뒤 각각 8자리씩 가져옴
    private func getWalletAddress() {
        DatabaseManager.shared.showWalletAddress { address in
            guard let address = address else {
                return
            }
            
            let start = address.startIndex
            let end = address.endIndex
            
            var reduceAddress = ""
        
            for i in 0...7 {
                reduceAddress.append(address[address.index(start, offsetBy: i)])
            }
            
            reduceAddress.append("...")
            
            for i in stride(from: -8, through: -1, by: 1) {
                reduceAddress.append(address[address.index(end, offsetBy: i)])
            }
            
            self.walletAddressButton.setTitle(reduceAddress, for: .normal)
            let imageConfig = UIImage.SymbolConfiguration(scale: .small)
            self.walletAddressButton.setImage(UIImage(systemName: "rectangle.on.rectangle", withConfiguration: imageConfig), for: .normal)
            
            self.walletAddressButton.setTitle(reduceAddress, for: .normal)
        }
    }
    
    
    // MARK: - Web3 frameworks
    private func showWalletBalance() {
//        //Ethereum Network
//        let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
        
        // Goerli Testnet
        let web3 = Web3(rpcURL: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
        
//                // Polygon Network
//                let web3 = Web3(rpcURL: "https://polygon-rpc.com/")
        
        // INU Token Contract Address : 0xc5E38262b06B1dba1aE63D06F538Da0E51B59e10
        let contractAddress = try! EthereumAddress(hex: "0xc5E38262b06B1dba1aE63D06F538Da0E51B59e10", eip55: true)
        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)
        
        DatabaseManager.shared.showWalletAddress { address in
            guard let address = address else {
                return
            }
            
            // 이더리움 수량 가져오기
            firstly {
                try web3.eth.getBalance(address: EthereumAddress(hex: address, eip55: true), block: .latest)
            }.done { outputs in
                let balance = Double(outputs.quantity) / self.wei_18
                self.walletBalanceLabel.text = "\(balance) ETH"
            }.catch { error in
                print("ERROR: \(error)")
            }
            
            // INU Token 수량 가져오기
            firstly {
                try contract.balanceOf(address: EthereumAddress(hex: address, eip55: true)).call()
            }.done { outputs in
                print(outputs.values)
                self.INUTokenBalanceLabel.text = "\(outputs["_balance"] as! BigUInt / BigUInt(self.wei_18)) INU"
            }.catch { error in
                print("ERROR: \(error)")
            }
        }
    }
    
    // MARK: - 토큰 보내는 코드
    // TODO: 1. 여기도 마찬가지로 estimate gas로 요금 자동으로 추정하기
    
    private func pleaseSendEth() {
        let web3 = Web3(rpcURL: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
        
        // 보내는 토큰의 contract address
        let contractAddress = try! EthereumAddress(hex: "0x4c3736ce7D98ef99b4B39bA4021B31Ad5e1E753F", eip55: true)
        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)
        
        firstly {
            try contract.balanceOf(address: EthereumAddress(hex: "0xf0dd0689C7c53c98ffC873C5487A27FCd1a7ab39", eip55: true)).call()
        }.done { outputs in
            print("----->")
            print(outputs["_balance"] as? BigUInt)
        }.catch { error in
            print(error)
        }
        
        let privateKey = try! EthereumPrivateKey(hexPrivateKey: "0xf6252aed5d5197f488d129ce42bd30db0a75b6c09fa660a09bb64fcf96b942e8")
        
        firstly {
            web3.eth.getTransactionCount(address: privateKey.address, block: .latest)
        }.then { nonce in
            try contract.transfer(to: EthereumAddress(hex: "0x1d48aE7ab364767F32fEd28788Ec8B235CcF3d59", eip55: true), value: 10000000000000000000).createTransaction(
                //value: 보낼 토큰 양
                nonce: nonce,
                gasPrice: EthereumQuantity(quantity: 300.gwei),
                maxFeePerGas: EthereumQuantity(quantity: 300.gwei),
                maxPriorityFeePerGas: EthereumQuantity(quantity: 5.gwei),
                gasLimit: EthereumQuantity(quantity: 50000),
                from: privateKey.address,
                value: EthereumQuantity(quantity: 0),
                // 여기 value는 이더리움 보낼 때? 값인듯
                accessList: [:],
                transactionType: .eip1559
            )!.sign(with: privateKey, chainId: EthereumQuantity(quantity: 5)).promise
        }.then { tx in
            web3.eth.sendRawTransaction(transaction: tx)
        }.done { txHash in
            print(txHash.hex())
        }.catch { error in
            print(error)
        }
    }
}
