//
//  PhotoListObject.swift
//  FabBook
//
//  Created by anthony on 2021/12/16.
//

import UIKit

class PhotoListObject : IAssetInterface {
    
    var thumbnailURL: URL?
    
    var schemeThumbnailURLString: String?
    
    var schemeThumbnailURLStringForSwift: String?
    
    var originalURL: URL?
    
    var size: CGSize?
    
    var best: UInt?
    
    var replies: [Any]?
    
    var feeling: [Any]?
    
    var numberOfReplies: UInt?
    
    var numberOfFeeling: UInt?
    
    var assetID: String?
    
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
    
    
}
