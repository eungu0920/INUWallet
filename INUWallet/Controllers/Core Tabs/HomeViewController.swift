//
//  HomeViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var greatingView: UIView!
    @IBOutlet weak var announceView: UIView!
    @IBOutlet weak var tokenListView: UIView!
    @IBOutlet weak var myAddressButton: UIButton!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var newPFPNFTView: UIView!
    @IBOutlet weak var getDiplomaNFTView: UIView!
    
//    var user = User()
    var user = UserModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        greatingView.layer.cornerRadius = 8.0
        announceView.layer.cornerRadius = 8.0
        tokenListView.layer.cornerRadius = 8.0
        myAddressButton.layer.cornerRadius = 8.0
        
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func configure() {
        usernameLable.text = "\(user.name)님,"
        
        guard let diplomaNFT = user.diplomaNFT else {
            return
        }
        
        if diplomaNFT {
            getDiplomaNFTView.alpha = 0
        }
        
        guard let PFPNFT = user.PFPNFT else {
            return
        }
        
        if PFPNFT {
            newPFPNFTView.alpha = 0
        }
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        
        if user.graduate == true {
            let alert = UIAlertController(title: "졸업요건 불충족",
                                          message: "졸업 요건이 불충족 되어 졸업증서를 받을 수 없습니다.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "정보 확인",
                                          message: "이름: \(self.user.name)\n학번: \(self.user.studentID)\n학과: \(self.user.major)\n학년: \(self.user.grade)",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소",
                                          style: .cancel,
                                          handler: nil))
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .default,
                                          handler: { _ in
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MintDiplomaViewController") as! MintDiplomaViewController
//                nextVC.user = self.user
                self.navigationController?.pushViewController(nextVC, animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
    
}
