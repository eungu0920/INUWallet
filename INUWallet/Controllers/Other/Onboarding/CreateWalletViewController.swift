//
//  CreateWalletViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/02/27.
//

import UIKit

class CreateWalletViewController: UIViewController {
    @IBOutlet weak var textView_1: UITextView!
    @IBOutlet weak var textView_2: UITextView!
    @IBOutlet weak var textView_3: UITextView!
    @IBOutlet weak var textView_4: UITextView!
    @IBOutlet weak var textView_5: UITextView!
    @IBOutlet weak var textView_6: UITextView!
    @IBOutlet weak var textView_7: UITextView!
    @IBOutlet weak var textView_8: UITextView!
    @IBOutlet weak var textView_9: UITextView!
    @IBOutlet weak var textView_10: UITextView!
    @IBOutlet weak var textView_11: UITextView!
    @IBOutlet weak var textView_12: UITextView!
    @IBOutlet weak var generateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView_1.layer.cornerRadius = 8.0
        textView_1.text = ""
        
        textView_2.layer.cornerRadius = 8.0
        textView_2.text = ""
        
        textView_3.layer.cornerRadius = 8.0
        textView_3.text = ""
        
        textView_4.layer.cornerRadius = 8.0
        textView_4.text = ""
        
        textView_5.layer.cornerRadius = 8.0
        textView_5.text = ""
        
        textView_6.layer.cornerRadius = 8.0
        textView_6.text = ""
        
        textView_7.layer.cornerRadius = 8.0
        textView_7.text = ""
        
        textView_8.layer.cornerRadius = 8.0
        textView_8.text = ""
        
        textView_9.layer.cornerRadius = 8.0
        textView_9.text = ""
        
        textView_10.layer.cornerRadius = 8.0
        textView_10.text = ""
        
        textView_11.layer.cornerRadius = 8.0
        textView_11.text = ""
        
        textView_12.layer.cornerRadius = 8.0
        textView_12.text = ""
        
        generateButton.setTitle("Generate", for: .normal)
    }
    
    @IBAction func didTapGenerateButton(_ sender: Any) {
    }
    

}
