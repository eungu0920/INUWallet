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
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var diplomaImageView: UIImageView!
    
    let diploma = DrawDiploma()
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
        gradeLabel.text = user.grade
    }
    
    // MARK: - 졸업증서 NFT Minting 순서: 1. NFT Token 민팅 -> transaction 받아와서 저장 2. GetTokenID 받아오기 3. 이미지 생성 및 업로드 4. metadata 생성 및 업로드
    @IBAction func didTapButton(_ sender: Any) {
        diploma.mintDiploma(userInfo: user) { txHash in
            guard let txHash = txHash else { return }
            self.diploma.diplomaTxHash = txHash
            // TODO: - Transaction이 완료 되었을 때 GetTokenID 받아오기 -> 가능?
            self.diploma.getDiplomaTokenID(userInfo: self.user) { tokenID in
                guard let tokenID = tokenID else { return }
                print(tokenID)
            }
        }
        
        let path = "DefaultDiploma.png"
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                self?.downloadImage(imageView: self!.imageView, url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        }
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
                self.diplomaImageView.image = DrawDiploma().createDiploma(image: image ?? UIImage(), userInfo: self.user)
            }
        }.resume()
    }

}
