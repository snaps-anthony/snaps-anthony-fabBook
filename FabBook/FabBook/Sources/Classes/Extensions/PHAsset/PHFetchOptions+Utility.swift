//
//  PHFetchOptions+Utility.swift
//  FabBook
//
//  Created by anthony on 2021/12/13.
//

import Foundation
import Photos

extension PHFetchOptions {
    
    class func imagesOptions() -> PHFetchOptions {
        let this = PHFetchOptions()
        this.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        this.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)] // descendingSort
        return this
    }
    
    class func groupsOptions() -> PHFetchOptions {
        let this = PHFetchOptions()
        this.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        return this
    }
}
