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
    
    @IBAction func didTapButton(_ sender: Any) {
//        let path = "https://storage.googleapis.com/inuwallet/diploma/DefaultDiploma.png"
//        StorageManager.shared.downloadURL(for: path) { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.downloadImage(imageView: self!.imageView, data: data)
//            case .failure(let error):
//                print("Failed to get download url: \(error)")
//            }
//        }
        downloadImageFromURLSession(from: URL(string: "https://storage.googleapis.com/inuwallet/diploma/DefaultDiploma.png")!)
        
    }
    
    func downloadImage(imageView: UIImageView, data: Data) {
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//            DispatchQueue.main.async {
//                let image = UIImage(data: data)
//                imageView.image = image
//            }
//        }.resume()
        let image = UIImage(data: data)
        imageView.image = image
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImageFromURLSession(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
                
                self.diplomaImageView.image = DrawDiploma().createDiploma(image: image ?? UIImage())
            }
        }
    }

}
