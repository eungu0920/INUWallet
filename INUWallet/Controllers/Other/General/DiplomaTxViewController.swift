//
//  DiplomaTxViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/03/27.
//
import SafariServices
import UIKit

class DiplomaTxViewController: UIViewController {
    @IBOutlet weak var txLabel: UILabel!
    @IBOutlet weak var TokenIDLabel: UILabel!
    @IBOutlet weak var etherscanButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    
    var user = User()
    var diploma = Diploma()
//    var metadata: metadataModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txLabel.text = diploma.diplomaTxHash
        backgroundView.layer.cornerRadius = 8.0
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        let urlString: String = "https://mumbai.polygonscan.com/tx/" + diploma.diplomaTxHash
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    // MARK: - 졸업 증서 번호가 확인 되어야 밑에 졸업 증서 만들기 버튼이 뜸
    @IBAction func didTapCreatedCheckButton(_ sender: Any) {
        self.diploma.getDiplomaTokenID(userInfo: self.user) { tokenID in
            guard let tokenID = tokenID else { return }
            if tokenID == 0 {
                // 아직 transaction이 confirm 되지 않았습니다. 조금만 기다려주세요.
                self.TokenIDLabel.text = "아직 transaction이 confirm 되지 않았습니다."
                self.TokenIDLabel.textColor = .red
            } else {
                self.diploma.tokenID = tokenID
                self.TokenIDLabel.text! = "졸업 증서 번호 : \(tokenID)"
                self.TokenIDLabel.textColor = .black
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                encoder.outputFormatting = .withoutEscapingSlashes
                
                var metadata = metadataModel(description: "INCHEON National University Diploma #\(tokenID)",
                                             image: "https://storage.googleapis.com/inuwallet.appspot.com/Diploma/assets/\(tokenID)",
                                             name: "INU DIPLOMA #\(tokenID)",
                                             attributes: [
                                                [
                                                    "trait_type": "Year of Admission",
                                                    "value": "\(self.user.studentID.dropLast(5))"
                                                ],
                                                [
                                                  "trait_type": "Department",
                                                  "value": "\(self.user.department)"
                                                ],
                                                [
                                                  "trait_type": "Major",
                                                  "value": "\(self.user.major)"
                                                ]
                                             ])
                
                do {
                    let jsonData = try encoder.encode(metadata)
                    
                    // TODO: 업로드
                    StorageManager.shared.uploadDiplomaMetadata(metadata: jsonData, path: tokenID) { url in
                        if let url = url {
                            print("url: \(url)")
                        }
                    }
                } catch {
                    print(error)
                }
                
                // Diploma Create Button 보이기
            }
        }
    }
    
    
    @IBAction func didTapCreateButton(_ sender: Any) {
        self.downloadDiplomaImage()
//        self.navigationController?.popToRootViewController(animated: false)
    }
    
    
    func downloadDiplomaImage() {
        // MARK: - 졸업 증서 다운로드
        let path = "DefaultDiploma.png"
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        // MARK: - 졸업증서 제작 및 업로드
                        self!.diploma.createDiploma(image: image ?? UIImage(), userInfo: self!.user)
                    }
                }.resume()
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        }
        
    }
    
}
