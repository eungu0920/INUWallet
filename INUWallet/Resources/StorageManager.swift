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
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let gsReference = storage.reference(forURL: "gs://inuwallet.appspot.com/Diploma/").child(path)
        gsReference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
        }
    }
    
    public func uploadDiploma(image: UIImage, path: String, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = path
        
        print("uploaing...")
        let firebaseRefernce = storage.reference(forURL: "gs://inuwallet.appspot.com/Diploma/assets/").child("\(imageName)")
        
        firebaseRefernce.putData(imageData, metadata: metaData) { metadata, error in
            firebaseRefernce.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    public func uploadDiplomaMetadata(metadata: Data, path: Int, completion: @escaping (URL?) -> Void) {
        let firebaseRefernce = storage.reference(forURL: "gs://inuwallet.appspot.com/Diploma/metadata/").child("\(path).json")
        
        firebaseRefernce.putData(metadata) { error in
            firebaseRefernce.downloadURL { url, _ in
                completion(url)
            }
        }
    }
}
