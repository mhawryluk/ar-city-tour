//
//  StorageHelper.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 15/06/2024.
//

import Foundation
import Firebase
import FirebaseStorage

class StorageHelper {
    static private let storage = Storage.storage()
    
    class func asyncDownload(relativePath: String, callback: @escaping(_ fileUrl: URL) -> Void) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent(relativePath)
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            callback(fileUrl)
            return
        }
        
        let storageRef = storage.reference(withPath: relativePath)
        storageRef.write(toFile: fileUrl) { url, error in
            guard let localUrl = url else {
                print("Firebase storage error for path: ", relativePath, error ?? "")
                return
            }
            
            callback(localUrl)
        }.resume()
    }
}
