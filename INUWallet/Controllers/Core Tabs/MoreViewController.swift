//
//  MoreViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import UIKit

class MoreViewController: UIViewController {
        
    // Setting Button 누르면 다음 화면에서 BarButton 이름 바꿔주기
    let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: MoreViewController.self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
}
