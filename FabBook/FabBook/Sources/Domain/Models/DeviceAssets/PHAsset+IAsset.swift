//
//  PHAsset+IAsset.swift
//  FabBook
//
//  Created by anthony on 2021/12/16.
//

import Photos
import UIKit

extension PHAsset : IAssetInterface {
    
    var assetID: String {
        return self.localIdentifier
    }
    
    var thumbnailURL: URL? {
        return nil
    }
    
    var originalURL: URL? {
        return URL(string: self.localIdentifier)
    }
    
    var size: CGSize {
        return CGSize(width: self.pixelWidth, height: self.pixelHeight)
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
    
    var numberOfReplies: UInt {
        return 0
    }
    
    var numberOfFeeling: UInt {
        return 0
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
        let photoListObj =  PhotoListObject()
        photoListObj.photoId = self.assetID
        photoListObj.media_url = self.assetID
        photoListObj.media_thumbnail_url = self.assetID
        photoListObj.gubun = MY_DEVICE_ALBUM_SELECTED
        photoListObj.modifyDate = self.modificationDate?.toString(format: "yyyy-MM-dd HH:mm:SS")
        photoListObj.logz_media_subtypes = self.mediaSubtypes.rawValue
        photoListObj.logz_imgWidth = Float(self.pixelWidth)
        photoListObj.logz_imgHeight = Float(self.pixelHeight)
        photoListObj.orgFileName = "noname"
        photoListObj.created_at = self.creationDate
        return photoListObj
    }

}
