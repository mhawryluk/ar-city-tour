//
//  StorageHelper.swift
//  city-tour-ar
//
//  Created by Marcin Hawryluk on 15/06/2024.
//

import Foundation
import Firebase
import FirebaseStorage
import ARKit
import SwiftUI

class StorageHelper {
    static private let storage = Storage.storage()
    
    class func asyncDownload(relativePath: String, callback: @escaping(_ fileUrl: URL) -> Void) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent(relativePath)
        
        let storageRef = storage.reference(withPath: relativePath)
        storageRef.write(toFile: fileUrl) { url, error in
            guard let localUrl = url else {
                print("Firebase storage error for path: ", relativePath, error ?? "")
                return
            }
            
            callback(localUrl)
        }.resume()
    }
    
    class func createResourceImage(relativePath: String, physicalWidth: Float) -> ARReferenceImage? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent(relativePath)
        
        do {
            
            let imageData = try Data(contentsOf: fileUrl)
            let image = UIImage(data: imageData)?.cgImage
            let reference  = ARReferenceImage(image!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(physicalWidth)
            )
            
            reference.name = relativePath
            return reference
        } catch {
            print("error loading image: \(error)")
        }
        
        return nil
    }
    
    class func createResourceObject(relativePath: String) -> ARReferenceObject? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent(relativePath)
        
        do {
            let reference  = try ARReferenceObject(archiveURL: fileUrl)
            reference.name = relativePath
            return reference
        } catch {
            print("error loading ref object: \(error)")
        }
        
        return nil
    }
    
    class func removeAllReferences() {
        for dir in ["referenceImages", "referenceObjects", "models"] {
            let url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first!.appendingPathComponent(dir)
            
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    class func getImage(relativePath: String) -> Image? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent(relativePath)
        
        do {
            let imageData = try Data(contentsOf: fileUrl)
            if let image = UIImage(data: imageData) {
                return Image(uiImage: image)
            }
            return nil
        } catch {
            print("error loading image: \(error)")
        }
        
        return nil
    }
}
