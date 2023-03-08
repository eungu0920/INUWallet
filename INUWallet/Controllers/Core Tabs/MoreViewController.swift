//
//  MoreViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import SafariServices
import UIKit

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

class MoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var profileView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureModels()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = .zero
        
        userImageView.layer.cornerRadius = 10.0 // userImageView.frame.height / 2 -> 원형 프로필
        
        profileView.layer.cornerRadius = 8.0
    }
    
    private var data = [[SettingCellModel]]()
    
    private func configureModels() {
        data.append([
            SettingCellModel(title: "Edit Profile") { [weak self] in
                self?.didTapEditProfile()
            }
        ])
        
        data.append([
            SettingCellModel(title: "Terms of Service") { [weak self] in
                self?.openURL(type: .terms)
            },
            SettingCellModel(title: "Privacy Policy") { [weak self] in
                self?.openURL(type: .privacy)
            },
            SettingCellModel(title: "Help / Feedback") { [weak self] in
                self?.openURL(type: .help)
            }
        ])
        
        data.append([
            SettingCellModel(title: "Sign Out") { [weak self] in
                self?.didTapSignOut()
            }
        ])
    }
    
    enum SettingsURLType {
        case terms, privacy, help
    }
    
    private func openURL(type: SettingsURLType) {
        let urlString: String
        switch type {
        case .terms: urlString = "https://google.co.kr"
        case .privacy: urlString = "https://naver.co.kr"
        case .help: urlString = "https://inu.ac.kr"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    private func didTapEditProfile() {
        
    }
    
    private func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign Out",
                                            message: "Are you sure you want to sign out?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancle",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out",
                                            style: .destructive,
                                            handler: { _ in
            AuthManager.shared.signOut(completion: { success in
                DispatchQueue.main.async {
                    if success {
                        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                        else {
                            return
                        }
                        
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: false) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    } else {
                        // error occurred
                        fatalError("Could not sign out user")
                    }
                }
            })
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        self.present(actionSheet, animated: true)
    }

}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.textLabel?.textColor = UIColor(cgColor: CGColor(genericCMYKCyan: 1.0, magenta: 0.8, yellow: 0, black: 0.05, alpha: 1))
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
}
