//
//  NFTModel.swift
//  INUWallet
//
//  Created by Gray on 2023/04/11.
//

import Foundation
import UIKit

class NFTModel {
//    var name: String
//    var description: String
//    var image: UIImage
//    var attributes: Array<Dictionary<String, String>>
//    var imageURL: String
    
    var user: UserModel
    
//    init(name: String, description: String, image: UIImage, attributes: Array<Dictionary<String, String>>, imageURL: String) {
//        self.name = name
//        self.description = description
//        self.image = image
//        self.attributes = attributes
//        self.imageURL = imageURL
//    }
    
    init(user: UserModel) {
        self.user = user
    }
   
//    func imageLoad() {
//        DispatchQueue.global().async {
//            do {
//                let data = try Data(contentsOf: URL(string: self.imageURL)!)
//                if let NFTImage = UIImage(data: data) {
//                    DispatchQueue.main.sync {
//                        self.image = NFTImage
//                    }
//                }
//            } catch {
//                print("Error loading image: \(error)")
//            }
//        }
//    }
}

struct NFTModelList {
    var NFTs: [NFTModel]
    
    var numOfNFT: Int {
        return NFTs.count
    }
    
    func NFTInfo(at index: Int) -> NFTModel {
        return NFTs[index]
    }
}
