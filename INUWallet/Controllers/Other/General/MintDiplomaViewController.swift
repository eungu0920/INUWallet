//
//  MintDiplomaViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/03/20.
//

import UIKit

class MintDiplomaViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var studentIDLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var getButton: UIButton!
    
    let diploma = Diploma()
    var user = User()
    /*
     name
     studentID
     department
     grade
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user.name
        studentIDLabel.text = user.studentID
        departmentLabel.text = user.department
        majorLabel.text = user.major
        gradeLabel.text = user.grade
        
        getButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - 졸업증서 NFT Minting 순서: 1. NFT Token 민팅 -> transaction 받아와서 저장 2. GetTokenID 받아오기 3. 이미지 생성 및 업로드 4. metadata 생성 및 업로드
    // MARK: 추 후 한꺼번에 NFT 생성으로 가야할 듯?
    // TODO: 1. 사용자 정보 확인, 2. Mint 버튼 클릭 -> 다음 화면으로 넘어감
    
    // MARK: - NFT Token 민팅 및 다음 화면으로.
    @IBAction func didTapButton(_ sender: Any) {
        diploma.mintDiploma(userInfo: user) { txHash in
            guard let txHash = txHash else { return }
            self.diploma.diplomaTxHash = txHash
            
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DiplomaTxViewController") as! DiplomaTxViewController
            nextVC.user = self.user
            nextVC.diploma = self.diploma
            self.navigationController?.pushViewController(nextVC, animated: true)

        }
    }
}
