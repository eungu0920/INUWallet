//
//  Diploma.swift
//  INUWallet
//
//  Created by Gray on 2023/03/18.
//

import UIKit
import Web3
import Web3PromiseKit
import Web3ContractABI

public class Diploma {
    
    var diplomaImage = UIImage()
    var diplomaTxHash: String = "testTxHash"
    var tokenID = Int()
    let abiModel = ABIModel()
    
    public func mintDiploma(userInfo: User, completion: @escaping (String?) -> Void) {
        
        // Mumbai testnet
        let web3 = Web3(rpcURL: "https://rpc-mumbai.maticvigil.com")
        
        let contractAddress = try! EthereumAddress(hex: "0xF1B010D76FdF0C6aA20B2319D62c95Fa19382fd4", eip55: true)
        let abi = abiModel.diplomaNFTABI
        
        let contractJsonABI = abi.data(using: .utf8)!
        let contract = try! web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
        
        firstly {
            try web3.eth.getTransactionCount(address: EthereumAddress(hex: userInfo.address, eip55: true), block: .latest)
        }.done { nonce in
            guard let transaction = contract["safeMint"]?().createTransaction(
                nonce: nonce,
                gasPrice: EthereumQuantity(quantity: 150.gwei),
                maxFeePerGas: EthereumQuantity(quantity: 150.gwei),
                maxPriorityFeePerGas: EthereumQuantity(quantity: 150.gwei),
                gasLimit: EthereumQuantity(quantity: 200000),
                from: nil,
                value: EthereumQuantity(quantity: 0),
                accessList: [:],
                transactionType: .legacy
            ) else {
                return
            }
            
            let signedTx = try transaction.sign(with: EthereumPrivateKey(hexPrivateKey: userInfo.privateKey), chainId: 80001)
            
            firstly {
                web3.eth.sendRawTransaction(transaction: signedTx)
            }.done { txHash in
                completion(txHash.hex())
            }.catch { error in
                print(error)
                completion(nil)
            }
            
        }.catch { error in
            print(error)
            completion(nil)
        }
        
    }
    
    public func getDiplomaTokenID(userInfo: User, completion: @escaping (Int?) -> Void) {
        let web3 = Web3(rpcURL: "https://rpc-mumbai.maticvigil.com")
        
        let contractAddress = try! EthereumAddress(hex: "0xF1B010D76FdF0C6aA20B2319D62c95Fa19382fd4", eip55: true)
        let abi = abiModel.diplomaNFTABI
        
        let contractJsonABI = abi.data(using: .utf8)!
        let contract = try! web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
        
        firstly {
            try (contract["tokenOfOwnerByIndex"]?(EthereumAddress(hex: userInfo.address, eip55: true), 0).call())!
        }.done { outputs in
            guard let tokenID = outputs[""] as? BigUInt else {
                return
            }
            completion(Int(tokenID))
        }.catch { error in
            print(error)
            // '0'은 아직 transaction이 완료 되지 않았을 때를 뜻함,
            completion(0)
        }
    }
    
    public func createDiploma(image: UIImage, userInfo: User) {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // MARK: - 날짜
        let date: Date = Date()
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateTextField = dataFormatter.string(from: date)
        
        // MARK: - TxHash
        let txHashTextField: String = diplomaTxHash
        
        // MARK: - 졸업증서 번호 (ex. 학사 제 xxx 호)
        let diplomaNumber: Int = tokenID // get tokenID
        let diplomaNumberTextField: String = "학사 제 \(diplomaNumber) 호"
        
        // MARK: - Name
//        let nameTextField: String = "횃    불    이"
        let name: String = userInfo.name
        var nameTextField: String = ""
        
        let count: Int = name.count
        var startCount: Int = 1
        
        for i in name {
            nameTextField += String(i)
            if startCount != count {
                nameTextField += "    "
                startCount += 1
            }
        }
        
        // MARK: - Birthdate
        let birthdateTextField: String = "1996. 09. 20."
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 60, weight: .semibold),
            NSAttributedString.Key.font: UIFont(name: "NanumMyeongjoOTFBold", size: 60),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let diplomaNumberAttributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 55),
            NSAttributedString.Key.font: UIFont(name: "NanumMyeongjoOTFBold", size: 55),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let txAttributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50),
            NSAttributedString.Key.font: UIFont(name: "NanumMyeongjoOTFBold", size: 50),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let dateTextFieldSize = dateTextField.size(withAttributes: attributes)
        let txHashTextFieldSize = txHashTextField.size(withAttributes: txAttributes)
        let diplomaTextFieldSize = diplomaNumberTextField.size(withAttributes: diplomaNumberAttributes)
        let nameTextFieldSize = nameTextField.size(withAttributes: diplomaNumberAttributes)
        let birthdateTextFieldSize = birthdateTextField.size(withAttributes: diplomaNumberAttributes)
        
        dateTextField.draw(in: CGRect(x: image.size.width / 2 - dateTextFieldSize.width / 2, y: image.size.height / 2 - 65, width: dateTextFieldSize.width, height: dateTextFieldSize.height), withAttributes: attributes)
        dateTextField.draw(in: CGRect(x: image.size.width / 2 - dateTextFieldSize.width / 2, y: image.size.height / 2 + 690, width: dateTextFieldSize.width, height: dateTextFieldSize.height), withAttributes: attributes)
        txHashTextField.draw(in: CGRect(x: 130, y: 2810, width: txHashTextFieldSize.width, height: txHashTextFieldSize.height), withAttributes: txAttributes)
        diplomaNumberTextField.draw(in: CGRect(x: 150, y: 320, width: diplomaTextFieldSize.width, height: diplomaTextFieldSize.height), withAttributes: diplomaNumberAttributes)
        nameTextField.draw(in: CGRect(x: 1510, y: 720, width: nameTextFieldSize.width, height: nameTextFieldSize.height), withAttributes: diplomaNumberAttributes)
        birthdateTextField.draw(in: CGRect(x: 1500, y: 800, width: birthdateTextFieldSize.width, height: birthdateTextFieldSize.height), withAttributes: diplomaNumberAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        diplomaImage = newImage ?? UIImage()
        
        // TODO: - metadata 만들어서 같이 업로드하기.
        
        let intToString = String(tokenID)
        
        // MARK: - 졸업증서 이미지 업로드
        StorageManager.shared.uploadDiploma(image: newImage ?? UIImage(), path: intToString) { url in
            if let url = url {
                 print("url: \(url)")
            }
        }
        
    }
    
    
}
