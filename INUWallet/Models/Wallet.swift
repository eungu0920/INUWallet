////
////  Wallet.swift
////  INUWallet
////
////  Created by Gray on 2023/03/02.
////
////
//import Foundation
//import CoreData
//import BigInt
//import Web3Core
//import web3swift
//import UIKit
//import secp256k1
//
//struct Wallet {
//    let address: String
//    let data: Data
//    let name: String
//    let isHD: Bool
//    let date: Date
//}
//
//class ETHWallet {
//    public static func createAccount(password: String, name: String) -> Wallet {
//        let keystore = try! EthereumKeystoreV3(password: password)!
//        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
//        let address = keystore.addresses?.first!.address
//        let wallet = Wallet(address: address!, data: keyData, name: name, isHD: false, date: Date())
//        return wallet
//    }
//
//    public static func insertWallet(wallet: Wallet) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "Wallets", in: context)
//        let newWallet = NSManagedObject(entity: entity!, insertInto: context)
//        newWallet.setValuesForKeys(["id": 0, "address": wallet.address, "data": wallet.data, "date": wallet.date, "name": wallet.name])
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print("WARNING \(error)")
//        }
//    }
//
//    func sendEth() {
//        let transaction: CodableTransaction = .emptyTransaction
//        transaction.from = from ?? transaction.sender
//        transaction.value = 0
//        transaction.gasLimitPolicy = .manual(78423)
//        transaction.gasPricePolicy = .manual(20000000)
//        web3.eth.send(transaction)
//    }
//
////    // MARK: - Get Keystore Manager from wallet data
////    public static func generatekeystoreManager(wallet: Wallet) -> KeystoreManager {
////        let data = wallet.data
////        let keystoreManager: KeystoreManager
////
////        if wallet.isHD {
////            let keystore = BIP32Keystore(data)!
////            keystoreManager = keystoreManager([keystore])
////        } else {
////            let keystore = EthereumKeystoreV3(data)!
////            keystoreManager = KeystoreManager([keystore])
////        }
////
////        return keystoreManager
////    }
////
////    // MARK: - Create transaction and send that.
////    public static func sendTranscation(value: String,
////                                       fromAddress: String,
////                                       toAddress: String,
////                                       gasPricePolicy: TransactionOptions.GasPricePolicy,
////                                       gasLimitPolicy: TransactionOptions.GasLimitPolicy,
////                                       password: String,
////                                       wallet: Wallet,
////                                       completion: @escaping(_: Result<TransactionSendingResult, Error>) -> Void) {
////        let walletAddress = EthereumAddress(fromAddress)!
////
////        guard let toAddress = EthereumAddress(toAddress) else {
////            completion(.failure(Web3Error.inputError(desc: "보내는 사람이 없습니다.")))
////            return
////        }
////
////        let provider = Web3.infu
////    }
//
//}
