//
//  TokenSendViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/02.
//

import UIKit

class SendTokenViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
