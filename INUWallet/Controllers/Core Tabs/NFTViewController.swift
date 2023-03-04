//
//  NFTViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import UIKit
import Web3
import Web3PromiseKit
import Web3ContractABI

class NFTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    private func getNFTInfo() {
//        // Ethereum Network
//        let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
        
        // Goerli Testnet
        let web3 = Web3(rpcURL: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
        
//        // Polygon Network
//        let web3 = Web3(rpcURL: "https://polygon-rpc.com/")
        
        let contractAddress = try! EthereumAddress(hex: "0xeE5f71552a27F294D2fb34b4fBa7Df33339Bb25b", eip55: true)
        let contract = web3.eth.Contract(type: GenericERC721cnt.self, address: contractAddress)
        
        firstly {
            try contract.tokenURI(tokenId: 1).call()
        }.done { outputs in
            var jsonDataURL: String = String(describing: outputs["_tokenURI"] ?? "")
            
            let task = URLSession.shared.dataTask(with: URL(string: jsonDataURL)!) { (data, response, error) in
                if let JsonData = data
                {
                    do
                    {
                        if let json = try JSONSerialization.jsonObject(with: JsonData, options: []) as? Dictionary<String, Any>
                        {
                            print(json)
                            if let description = json["description"] as? String
                            {
                                print(description)
                            }
                        }
                    }
                    catch {}
                }
            }
            
            task.resume()
            
            print(jsonDataURL)
            print(outputs.values)
//            print("outputs ----> \(outputs["_tokenURL"])")
        }.catch { error in
            print(error)
        }
    }
}


public class GenericERC721cnt: StaticContract, ERC721Contract, AnnotatedERC721 {
    public func tokenURI() -> Web3ContractABI.SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "_tokenId", type: .uint256)]
        let outputs = [SolidityFunctionParameter(name: "_tokenURI", type: .string)]
        let method = SolidityConstantFunction(name: "tokenURI", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke()
    }
    
    public func tokenURI(tokenId: BigUInt) -> Web3ContractABI.SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "_tokenId", type: .uint256)]
        let outputs = [SolidityFunctionParameter(name: "_tokenURI", type: .string)]
        let method = SolidityConstantFunction(name: "tokenURI", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(tokenId)
    }
    
    public var address: EthereumAddress?
    public let eth: Web3.Eth
    
    open var constructor: SolidityConstructor?
    
    open var events: [SolidityEvent] {
        return [GenericERC721Contract.Transfer, GenericERC721Contract.Approval]
    }
    
    public required init(address: EthereumAddress?, eth: Web3.Eth) {
        self.address = address
        self.eth = eth
    }
}
