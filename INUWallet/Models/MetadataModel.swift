//
//  MetadataModel.swift
//  INUWallet
//
//  Created by Gray on 2023/03/27.
//

import Foundation

struct metadataModel: Codable {
    var description: String
    var image: String
    var name: String
    var attributes: Array<Dictionary<String, String>>
}
