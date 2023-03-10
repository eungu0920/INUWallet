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
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = NFTInfoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - 스크롤 시에 탭바랑 네비게이션 뷰의 색깔이 의도적인 색이 아님... 블러를 약하게 주고싶음 나중에 방법 찾기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - collectionViewCell들을 스크롤 할 때 navigationBar, tabBar 부분이 투명화 되는 현상 + Backgroundcolor와 맞지 않아서 해당 코드로 변경함
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "effectView.png"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.backgroundImage = UIImage(named: "effectView.png")
        tabBarController?.tabBar.isTranslucent = true
    }
    
    // MARK: - NFT metadata를 가져올 때 쓰는 방법
    private func getNFTInfo() {
//        // Ethereum Network
//        let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
        
        // Goerli Testnet
        let web3 = Web3(rpcURL: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
        
//        // Polygon Network
//        let web3 = Web3(rpcURL: "https://polygon-rpc.com/")
        
//        // Mumbai Testnet
//        let web3 = Web3(rpcURL: "https://rpc-mumbai.maticvigil.com")
        
        // MARK: - INU NFT Contract : 0x6A83BEc46edc16BE070b458b9ad2384323C3C52e
        let contractAddress = try! EthereumAddress(hex: "0x1DB21eD8E466453D601603424bb561858B478c24", eip55: true)
        let contract = web3.eth.Contract(type: GenericERC721cnt.self, address: contractAddress)
        
        firstly {
            try contract.tokenURI(tokenId: 0).call()
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

extension NFTViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.numOfNFTInfoList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else {
            return UICollectionViewCell()
        }
        let NFTInfo = model.nftInfo(at: indexPath.item)
        cell.imageView.layer.cornerRadius = 8.0
        cell.update(info: NFTInfo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getNFTInfo()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemPerRow: CGFloat = 3
        let itemSpacing: CGFloat = 5
        let sectionInset: CGFloat = 5
        
        let textAreaHeight: CGFloat = 38
        
        let cellWidth: CGFloat = (width - itemSpacing * (itemPerRow - 1) - sectionInset * 2) / itemPerRow
        let cellHeight: CGFloat = cellWidth + textAreaHeight
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 3, left: 5, bottom: 5, right: 5)
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

class NFTInfoModel {
    let NFTInfoList: [NFTInfo] = [
        NFTInfo(name: "WonderPals", tokenID: "#3804", imageName: "WonderPal #3804"),
        NFTInfo(name: "Doodles", tokenID: "316", imageName: "Doodles #316"),
        NFTInfo(name: "MetaKongz", tokenID: "#3695", imageName: "Kongz #3695"),
        NFTInfo(name: "Bored Ape Yacht Club", tokenID: "#7971", imageName: "BAYC #7971"),
        NFTInfo(name: "Project Spoon DAO", tokenID: "#789", imageName: "Spoon #789"),
        NFTInfo(name: "Pop Art Cats by Matt Chessco", tokenID: "#6055", imageName: "Pop Art Cats #6055"),
        NFTInfo(name: "SuperCatman", tokenID: "#10", imageName: "SuperCatman #10"),
        NFTInfo(name: "Azuki", tokenID: "#5558", imageName: "Azuki #5558"),
        NFTInfo(name: "MetaKongz", tokenID: "#231", imageName: "Kongz #5675"),
        NFTInfo(name: "INU", tokenID: "#4963", imageName: "Studying"),
        NFTInfo(name: "Minimen official", tokenID: "#2691", imageName: "Minimen #3006"),
        NFTInfo(name: "metakongz", tokenID: "#4159", imageName: "Kongz #7291"),
        NFTInfo(name: "INU Torchlight", tokenID: "#231", imageName: ""),
        NFTInfo(name: "INU Computer Science", tokenID: "#1", imageName: ""),
        NFTInfo(name: "INU Sport", tokenID: "#9999", imageName: ""),
        NFTInfo(name: "INU Freshman", tokenID: "#181", imageName: ""),
        NFTInfo(name: "INU Torchlight", tokenID: "232#", imageName: ""),
        NFTInfo(name: "INU Computer Science", tokenID: "#4963", imageName: ""),
        NFTInfo(name: "INU Sport", tokenID: "#2691", imageName: "")
    ]
    
    var numOfNFTInfoList: Int {
        return NFTInfoList.count
    }
    
    func nftInfo(at index: Int) -> NFTInfo {
        return NFTInfoList[index]
    }
}

class GridCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tokenIDLabel: UILabel!
    
    func update(info: NFTInfo) {
//        imageView.image = UIImage(named: "Studying")
        imageView.image = info.image
        nameLabel.text = info.name
        tokenIDLabel.text = info.tokenID
        self.layer.cornerRadius = 8.0
    }
}

//class GenericERC721cnt: StaticContract, ERC721Contract, AnnotatedERC721 {
//    public func tokenURI() -> Web3ContractABI.SolidityInvocation {
//        let inputs = [SolidityFunctionParameter(name: "_tokenId", type: .uint256)]
//        let outputs = [SolidityFunctionParameter(name: "_tokenURI", type: .string)]
//        let method = SolidityConstantFunction(name: "tokenURI", inputs: inputs, outputs: outputs, handler: self)
//        return method.invoke()
//    }
//
//    public func tokenURI(tokenId: BigUInt) -> Web3ContractABI.SolidityInvocation {
//        let inputs = [SolidityFunctionParameter(name: "_tokenId", type: .uint256)]
//        let outputs = [SolidityFunctionParameter(name: "_tokenURI", type: .string)]
//        let method = SolidityConstantFunction(name: "tokenURI", inputs: inputs, outputs: outputs, handler: self)
//        return method.invoke(tokenId)
//    }
//
//    public var address: EthereumAddress?
//    public let eth: Web3.Eth
//
//    open var constructor: SolidityConstructor?
//
//    open var events: [SolidityEvent] {
//        return [GenericERC721Contract.Transfer, GenericERC721Contract.Approval]
//    }
//
//    public required init(address: EthereumAddress?, eth: Web3.Eth) {
//        self.address = address
//        self.eth = eth
//    }
//}

class GenericERC721cnt: StaticContract, ERC721Contract, AnnotatedERC721 {
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
