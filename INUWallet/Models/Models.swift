//
//  Models.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import Foundation
import UIKit

public struct User {
    var uid: String = ""
    var address: String = ""
    var email: String = ""
    var username: String = ""
    
    var name: String = ""
    var birthdate: String = ""
    var studentID: String = ""
    var department: String = ""
    var major: String = ""
    var grade: String = ""
    var graduate: Bool?
    
    var walletPassword: String = ""
    
    var privateKey: String = ""
    var publicKey: String = ""
}

struct NFTInfo {
    let name: String
    let tokenID: String
    let imageName: String
    
//    let tokenURL: URL
    var image: UIImage? {
        return UIImage(named: "\(imageName).png")
    }
    
    init(name: String, tokenID: String, imageName: String) {
        self.name = name
        self.tokenID = tokenID
        self.imageName = imageName
    }
}

class ABIModel {
    let diplomaNFTABI: String = """
        [
          { "inputs": [], "stateMutability": "nonpayable", "type": "constructor" },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "internalType": "address",
                "name": "owner",
                "type": "address"
              },
              {
                "indexed": true,
                "internalType": "address",
                "name": "approved",
                "type": "address"
              },
              {
                "indexed": true,
                "internalType": "uint256",
                "name": "tokenId",
                "type": "uint256"
              }
            ],
            "name": "Approval",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "internalType": "address",
                "name": "owner",
                "type": "address"
              },
              {
                "indexed": true,
                "internalType": "address",
                "name": "operator",
                "type": "address"
              },
              {
                "indexed": false,
                "internalType": "bool",
                "name": "approved",
                "type": "bool"
              }
            ],
            "name": "ApprovalForAll",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "internalType": "bytes32",
                "name": "role",
                "type": "bytes32"
              },
              {
                "indexed": true,
                "internalType": "bytes32",
                "name": "previousAdminRole",
                "type": "bytes32"
              },
              {
                "indexed": true,
                "internalType": "bytes32",
                "name": "newAdminRole",
                "type": "bytes32"
              }
            ],
            "name": "RoleAdminChanged",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "internalType": "bytes32",
                "name": "role",
                "type": "bytes32"
              },
              {
                "indexed": true,
                "internalType": "address",
                "name": "account",
                "type": "address"
              },
              {
                "indexed": true,
                "internalType": "address",
                "name": "sender",
                "type": "address"
              }
            ],
            "name": "RoleGranted",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "internalType": "bytes32",
                "name": "role",
                "type": "bytes32"
              },
              {
                "indexed": true,
                "internalType": "address",
                "name": "account",
                "type": "address"
              },
              {
                "indexed": true,
                "internalType": "address",
                "name": "sender",
                "type": "address"
              }
            ],
            "name": "RoleRevoked",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "internalType": "address",
                "name": "from",
                "type": "address"
              },
              {
                "indexed": true,
                "internalType": "address",
                "name": "to",
                "type": "address"
              },
              {
                "indexed": true,
                "internalType": "uint256",
                "name": "tokenId",
                "type": "uint256"
              }
            ],
            "name": "Transfer",
            "type": "event"
          },
          {
            "inputs": [],
            "name": "DEFAULT_ADMIN_ROLE",
            "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [],
            "name": "GRADUATE_ROLE",
            "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [{ "internalType": "address", "name": "to", "type": "address" }],
            "name": "addGraduatelist",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "address", "name": "to", "type": "address" },
              { "internalType": "uint256", "name": "tokenId", "type": "uint256" }
            ],
            "name": "approve",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "address", "name": "owner", "type": "address" }
            ],
            "name": "balanceOf",
            "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "uint256", "name": "tokenId", "type": "uint256" }
            ],
            "name": "getApproved",
            "outputs": [{ "internalType": "address", "name": "", "type": "address" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "bytes32", "name": "role", "type": "bytes32" }
            ],
            "name": "getRoleAdmin",
            "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "bytes32", "name": "role", "type": "bytes32" },
              { "internalType": "address", "name": "account", "type": "address" }
            ],
            "name": "grantRole",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "bytes32", "name": "role", "type": "bytes32" },
              { "internalType": "address", "name": "account", "type": "address" }
            ],
            "name": "hasRole",
            "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "address", "name": "owner", "type": "address" },
              { "internalType": "address", "name": "operator", "type": "address" }
            ],
            "name": "isApprovedForAll",
            "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "address", "name": "from", "type": "address" }
            ],
            "name": "isGraduate",
            "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [],
            "name": "name",
            "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "uint256", "name": "tokenId", "type": "uint256" }
            ],
            "name": "ownerOf",
            "outputs": [{ "internalType": "address", "name": "", "type": "address" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "bytes32", "name": "role", "type": "bytes32" },
              { "internalType": "address", "name": "account", "type": "address" }
            ],
            "name": "renounceRole",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "bytes32", "name": "role", "type": "bytes32" },
              { "internalType": "address", "name": "account", "type": "address" }
            ],
            "name": "revokeRole",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [],
            "name": "safeMint",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "address", "name": "from", "type": "address" },
              { "internalType": "address", "name": "to", "type": "address" },
              { "internalType": "uint256", "name": "tokenId", "type": "uint256" }
            ],
            "name": "safeTransferFrom",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "address", "name": "from", "type": "address" },
              { "internalType": "address", "name": "to", "type": "address" },
              { "internalType": "uint256", "name": "tokenId", "type": "uint256" },
              { "internalType": "bytes", "name": "data", "type": "bytes" }
            ],
            "name": "safeTransferFrom",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "address", "name": "operator", "type": "address" },
              { "internalType": "bool", "name": "approved", "type": "bool" }
            ],
            "name": "setApprovalForAll",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "bytes4", "name": "interfaceId", "type": "bytes4" }
            ],
            "name": "supportsInterface",
            "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [],
            "name": "symbol",
            "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "uint256", "name": "index", "type": "uint256" }
            ],
            "name": "tokenByIndex",
            "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "address", "name": "owner", "type": "address" },
              { "internalType": "uint256", "name": "index", "type": "uint256" }
            ],
            "name": "tokenOfOwnerByIndex",
            "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "uint256", "name": "tokenId", "type": "uint256" }
            ],
            "name": "tokenURI",
            "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [],
            "name": "totalSupply",
            "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              { "internalType": "address", "name": "from", "type": "address" },
              { "internalType": "address", "name": "to", "type": "address" },
              { "internalType": "uint256", "name": "tokenId", "type": "uint256" }
            ],
            "name": "transferFrom",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ]
"""
}

/*
 userdefault로 저장 - 임시
 지갑 비밀번호
 지갑 주소
 프라이빗 키
 퍼블릭키
 */
