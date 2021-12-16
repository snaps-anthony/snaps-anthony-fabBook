//
//  PHAsset+IAsset.swift
//  FabBook
//
//  Created by anthony on 2021/12/16.
//

import Photos
import UIKit

extension PHAsset : IAssetInterface {
    var thumbnailURL: URL? {
        return nil
    }
    
    var schemeThumbnailURLString: String? {
        return nil
    }
    
    var schemeThumbnailURLStringForSwift: String? {
        return nil
    }
    
    var originalURL: URL? {
        return nil
    }
    
    var size: CGSize? {
        return nil
    }
    
    var best: UInt? {
        return nil
    }
    
    var replies: [Any]? {
        return nil
    }
    
    var feeling: [Any]? {
        return nil
    }
    
    var numberOfReplies: UInt? {
        return nil
    }
    
    var numberOfFeeling: UInt? {
        return nil
    }
    
    var assetID: String {
        return self.localIdentifier
    }
    
    func cancelImageLoad(imageView: UIImageView) {
        //
    }
    
    func insertThumbnail(imageView: UIImageView, wamtSize: CGSize) {
        //
    }
    
    func insertThumbnail(imageView: UIImageView, wamtSize: CGSize, finished: @escaping () -> Void) {
        //
    }
    
    func thumbnailImageWantSize(wantSize: CGSize, resultBlock: @escaping (UIImage, Error?) -> Void) {
        //
    }
    
    func exportPhotoListObject() -> PhotoListObject {
        return PhotoListObject()
    }

}
