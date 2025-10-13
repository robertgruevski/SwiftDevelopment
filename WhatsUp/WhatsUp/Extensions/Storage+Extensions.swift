//
//  Storage+Extensions.swift
//  WhatsUp
//
//  Created by Robert Gruevski on 10/12/25.
//

import Foundation
import FirebaseStorage

enum FirebaseStorageBuckets: String {
    case photos
    case attachments
}

extension Storage {
    
    func uploadData(for key: String, data: Data, bucket: FirebaseStorageBuckets) async throws -> URL {
        
        let storageRef = Storage.storage().reference()
        let photosRef = storageRef.child("\(bucket.rawValue)/\(key)")
        
        let _ = try await photosRef.putDataAsync(data)
        let downloadUrl = try await photosRef.downloadURL()
        return downloadUrl
    }
}
