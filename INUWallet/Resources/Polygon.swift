//
//  Polygon.swift
//  INUWallet
//
//  Created by Gray on 2023/03/29.
//

import Foundation
import Web3
import Web3PromiseKit
import Web3ContractABI

enum Contracts {
    case diploma
    case token
}

struct Polygon {
    let abiModel = ABIModel()
    
    let web3 = Web3(rpcURL: "https://rpc-mumbai.maticvigil.com")
    
//    let contractAddress = try! EthereumAddress(hex: <#T##String#>, eip55: <#T##Bool#>)
    
    
}
