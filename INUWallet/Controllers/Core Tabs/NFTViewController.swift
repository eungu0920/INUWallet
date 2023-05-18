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

    let abiModel = ABIModel()
    var user = UserModel.shared
    var NFTList = NFTModelList(NFTs: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configure()
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
        
        print(NFTList.NFTs.count)
        
        collectionView.reloadData()
    }
    
    // 바로 졸업증서 받자마자 collection view에 띄우기
    private func configure() {
        if user.diplomaImage != nil {
            let NFT = NFTModel(user: self.user)
            NFTList.NFTs.append(NFT)
        }
    }
    
    private func downloadDiplomaImage(tokenID: BigUInt) {
        DispatchQueue.main.async {
            StorageManager.shared.downloadDiploma(path: Int(tokenID)) { [weak self] result in
                switch result {
                case .success(let url):
                    self?.downloadImage(url: url)
                case .failure(let error):
                    print("Failed to get download url: \(error)")
                }
            }            
        }
    }
    
    private func downloadImage(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.user.diplomaImage = image
                print("Download Done!")
//                self.collectionView.reloadData()
//                print("reload!")
            }
        }.resume()
    }
    
    // MARK: - NFT metadata를 가져올 때 쓰는 방법
//    private func getNFTInfo(tokenID: BigUInt, completion: @escaping () -> Void) {
//        print("begin getting NFT information")
//        var name: String = ""
//        var imageURL: String = ""
//        var image: UIImage = UIImage()
//        var description: String = ""
//        var attributes: Array<Dictionary<String, String>> = []
//
////        var NFT = NFTModel()
////        // Ethereum Network
////        let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
//
////        // Goerli Testnet
////        let web3 = Web3(rpcURL: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
//
////        // Polygon Network
////        let web3 = Web3(rpcURL: "https://polygon-rpc.com/")
//
//        // Mumbai Testnet
//        let web3 = Web3(rpcURL: "https://rpc-mumbai.maticvigil.com")
//
//        let contractAddress = try! EthereumAddress(hex: "0x7122AA809D51B3387771FCA4cFa1D14D57BcaE75", eip55: true)
//        let contract = web3.eth.Contract(type: GenericERC721cnt.self, address: contractAddress)
//
//        firstly {
//            contract.tokenURI(tokenId: tokenID).call()
//        }.done { outputs in
//            var jsonDataURL: String = String(describing: outputs["_tokenURI"] ?? "")
//
//            let task = URLSession.shared.dataTask(with: URL(string: jsonDataURL)!) { (data, response, error) in
//                if let JsonData = data
//                {
//                    do
//                    {
//                        if let json = try JSONSerialization.jsonObject(with: JsonData, options: []) as? Dictionary<String, Any>
//                        {
//                            print(json)
//                            if let NFTDescription = json["description"] as? String
//                            {
//                                description = NFTDescription
//                                print("description ----> \(description)")
//                            }
//
//                            if let NFTName = json["name"] as? String
//                            {
//                                name = NFTName
//                            }
//
//                            if let NFTImageURL = json["image"] as? String
//                            {
//                                imageURL = NFTImageURL
//                            }
//
//                            if let NFTAttributes = json["attributes"] as? Array<Dictionary<String, String>>
//                            {
//                                attributes = NFTAttributes
//                            }
//
//                            let NFT = NFTModel(name: name, description: description, image: UIImage(), attributes: attributes, imageURL: imageURL)
//
//                            self.NFTList.NFTs.append(NFT)
//                            print("------->>>> \(NFT.name)")
//                            self.collectionView.reloadData()
//                            completion()
//                        }
//                    }
//                    catch {}
//                }
//            }
//
//            task.resume()
//
////            NFT.imageLoad()
//
//
//
//            print("jsonData URL : \(jsonDataURL)")
//            print("outputs.values : \(outputs.values)")
////            print("outputs ----> \(outputs["_tokenURL"])")
//
//        }.catch { error in
//            print(error)
//        }
//    }
    
    // MARK: - 가지고 있는 토큰넘버를 차례로 보여주는 메소드
    private func tokenOfOwnerByIndex(address: String, completion: @escaping (BigUInt) -> Void) {
        // Mumbai Testnet
        let web3 = Web3(rpcURL: "https://rpc-mumbai.maticvigil.com")
        
        let contractAddress = try! EthereumAddress(hex: "0x7122AA809D51B3387771FCA4cFa1D14D57BcaE75", eip55: true)
        let abi = abiModel.diplomaNFTABI

        let contractJsonABI = abi.data(using: .utf8)!
        let contract = try! web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
    
        firstly {
            try (contract["tokenOfOwnerByIndex"]?(EthereumAddress(hex: address, eip55: true), 0).call())!
        }.done { outputs in
            // MARK: - outputs 반환값은 [String: Any] 딕셔너리 타입으로 반환됨, Any값을 Int로 캐스팅이 안되길래 BigUInt로 캐스팅하니까 잘됨. Any -> BigUInt -> Int 이렇게 해야할 듯.
            guard let tokenID = outputs[""] as? BigUInt else {
                print("failed")
                return
            }
            
            print("tokenID: \(tokenID)")
            print("tokenOfOwnerByIndex: \(outputs[""])")
            print("tokenOfOwnerByIndex debugDescription: \(outputs.values.debugDescription)")
            print("tokenOfOwnerByIndex description: \(outputs.values.description)")
            
            completion(tokenID)
        }.catch { error in
            print(error)
            completion(0)
        }
        
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        collectionView.reloadData()
        print("\(NFTList)")
    }
}

extension NFTViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let cell = cell as? GridCell {
////            if user.diplomaImage == nil {
////                DispatchQueue.global().async {
////                    do {
////                        let data = try Data(contentsOf: URL(string: self.NFTList.NFTInfo(at: indexPath.item).imageURL)!)
////                        if let NFTImage = UIImage(data: data) {
////                            DispatchQueue.main.sync {
////                                cell.imageView.image = NFTImage
////                            }
////                        }
////                    } catch {
////                        print("Error loading image: \(error)")
////                    }
////                }
////            } else {
////                cell.imageView.image = user.diplomaImage
////            }
//
////            StorageManager.shared.downloadDiplomaaa(path: "gs://inuwallet.appspot.com/Diploma/assets/3") { [weak self] result in
////                switch result {
////                case .success(let url):
////                    URLSession.shared.dataTask(with: url) { data, _, error in
////                        guard let data = data, error == nil else {
////                            return
////                        }
////                        DispatchQueue.main.sync {
////                            let image = UIImage(data: data)
////                            cell.imageView.image = image
////                        }
////                    }.resume()
////                case .failure(let error):
////                    print("Failed to get download url: \(error)")
////                }
////            }
//
//            cell.imageView.image = user.diplomaImage
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count : \(NFTList.numOfNFT)")
        return NFTList.numOfNFT
//        return model.numOfNFTInfoList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else {
            return UICollectionViewCell()
        }
        
        let NFTInfo = NFTList.NFTInfo(at: indexPath.item)
        
//        let NFTInfo = model.nftInfo(at: indexPath.item)
        cell.imageView.layer.cornerRadius = 8.0
        cell.update(info: NFTInfo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("--> \(indexPath.item)")
//        performSegue(withIdentifier: "NFTDetailViewController", sender: indexPath.item)
        print("NFT!!!")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemPerRow: CGFloat = 2
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

class GridCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tokenIDLabel: UILabel!
    
    func update(info: NFTModel) {
//        DispatchQueue.global().async {
//            do {
//                let data = try Data(contentsOf: URL(string: info.imageURL)!)
//                if let NFTImage = UIImage(data: data) {
//                    DispatchQueue.main.sync {
//                        self.imageView.image = NFTImage
//                    }
//                }
//            } catch {
//                print("Error loading image: \(error)")
//            }
//        }
        
        nameLabel.text = "Diploma #\(info.user.diplomaTokenID)"
        print("--------> \(info.user.diplomaTokenID)")
        tokenIDLabel.text = "INU Diploma"
        imageView.image = info.user.diplomaImage
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
