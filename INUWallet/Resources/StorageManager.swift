//
//  StorageManager.swift
//  INUWallet
//
//  Created by Gray on 2023/02/24.
//

import FirebaseStorage
import Firebase

public class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage()
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let gsReference = storage.reference(forURL: "gs://inuwallet.appspot.com/Diploma/test.png")
        let httpsReference = storage.reference(forURL: "https://firebasestorage.googleapis.com/v0/b/inuwallet.appspot.com/o/Diploma%2FDefaultDiploma.png?alt=media&token=2ae0f878-2c2c-4127-9af6-24591d0c3ecc")
        let megaByte = Int64(1 * 1024 * 1024)
        httpsReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(imageData))
        }
//        gsReference.downloadURL { url, error in
//            guard let url = url, error == nil else {
//                completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                return
//            }
//            completion(.success(url))
//        }
    }
    
    public func uploadDiploma(image: UIImage, path: String, completion: (URL?) -> Void) {
        guard let imageData = image.pngData() else {
            return
        }
        let imageName = "test"
        let firebaseRefernce = storage.reference().child("\(imageName)")
        firebaseRefernce.putData(imageData, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                return
            }
        }
        
        
        
    }
    
}
