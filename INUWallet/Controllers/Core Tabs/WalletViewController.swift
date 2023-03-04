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
    
    @IBOutlet weak var walletAddressButton: UIButton!
    @IBOutlet weak var walletAddressLabel: UILabel!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    
    var wei_18: Double = 1000000000000000000
    
    //    var testAddress: String = ""
    
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
        
        
        // 이거 여백 TextView 여백 없애기
//        walletAddressTextView.textContainerInset = UIEdgeInsets(top: 0,
//                                                                left: -walletAddressTextView.textContainer.lineFragmentPadding,
//                                                                bottom: 0,
//                                                                right: 0)
        walletAddressButton.setTitle("", for: .normal)
        walletAddressButton.setImage(.none, for: .normal)
        getWalletAddress()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 켜질 때 마다 잔액 새로고침
        
        // TODO: 1. 나중에 시간날 때 balance 소수점 자르기?
    }
    
    
    @IBAction func didTapSendButton(_ sender: Any) {
//        showWalletBalance()
//        //sendEthToAnother()
//        pleaseSendEth()
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendTokenViewController") as! SendTokenViewController
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
        
        print("send")
    }
    
    @IBAction func didTapReceiveButton(_ sender: Any) {
        sendEthToAnother()
    }
    
    
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
            
//            self.walletAddressButton.setTitle(reduceAddress, for: .normal)
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
        
        DatabaseManager.shared.showWalletAddress { address in
            guard let address = address else {
                return
            }
            // 이더리움 수량 가져오기
            firstly {
                try web3.eth.getBalance(address: EthereumAddress(hex: "0xf0dd0689C7c53c98ffC873C5487A27FCd1a7ab39", eip55: true), block: .latest)
            }.done { outputs in
                let balance = Double(outputs.quantity) / self.wei_18
                self.walletBalanceLabel.text = "잔액: \(balance) ETH"
            }.catch { error in
                print("ERROR!!! : \(error)")
            }
        }
        
        
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
         
    }
    
    // MARK: - 이더리움 보내는 코드
    // TODO: 1. estimate gas로 gasPrice, maxFeePerGas 등 요금 견적 내기
    private func sendEthToAnother() {
//        // Ethereum Network
//        let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
        
        // Goerli Testnet
        let web3 = Web3(rpcURL: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
        
        let privateKey = try! EthereumPrivateKey(hexPrivateKey: "0xf6252aed5d5197f488d129ce42bd30db0a75b6c09fa660a09bb64fcf96b942e8")
        
        firstly {
            web3.eth.getTransactionCount(address: privateKey.address, block: .latest)
        }.then { nonce in
            let tx = try EthereumTransaction(
                nonce: nonce,
                gasPrice: EthereumQuantity(quantity: 150.gwei),
                maxFeePerGas: EthereumQuantity(quantity: 150.gwei),
                maxPriorityFeePerGas: EthereumQuantity(quantity: 1500000000),
                gasLimit: EthereumQuantity(quantity: 21000),
//                from: EthereumAddress(hex: "", eip55: true),
                to: EthereumAddress(hex: "0x1d48aE7ab364767F32fEd28788Ec8B235CcF3d59", eip55: true),
                value: EthereumQuantity(quantity: 1000000000000000),
//                data: <#T##EthereumData#>,
                accessList: [:],
                transactionType: .eip1559
            )
            /*
            let tx = try EthereumTransaction(
                nonce: nonce,
                gasPrice: EthereumQuantity(quantity: 150.gwei),
                to: EthereumAddress(hex: "0x1d48aE7ab364767F32fEd28788Ec8B235CcF3d59", eip55: true),
                value: EthereumQuantity(quantity: 1000.gwei)
            )
             */
            return try tx.sign(with: privateKey, chainId: 5).promise
        }.then { tx in
            web3.eth.sendRawTransaction(transaction: tx)
        }.done { hash in
            print(hash.hex())
        }.catch { error in
            print(error)
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
