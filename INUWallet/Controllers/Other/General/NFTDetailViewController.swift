//
//  NFTDetailViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/04/29.
//

import UIKit

class NFTDetailViewController: UITabBarController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func updateUI() {
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
