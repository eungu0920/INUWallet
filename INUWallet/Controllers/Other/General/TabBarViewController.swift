//
//  TabBarViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/04/11.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabBarViewDidLoad")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("TabBarViewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("TabBarViewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("TabBarViewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("TabBarViewDidDisappear")
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
