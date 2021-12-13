//
//  PHAlbumData.swift
//  FabBook
//
//  Created by anthony on 2021/12/13.
//

import UIKit
import Photos

enum AlbumType:Int {
    case AlbumCollection
    case AllResources
}

class PHAlbumData : IAssetsGroupInterface {
    
    //MARK: properties
    var fetchResult : PHFetchResult<PHAsset>? = nil
    var albumTitle : String? = nil
    var assetCollection : PHAssetCollection? = nil
    var bPreFetched = false
    
    //MARK: methods
    func numberOfAssets() -> NSNumber? {
        let ret = NSNumber(value: self.fetchResult?.count ?? 0)
        return ret
    }
    
    func groupTitle() -> String? {
        return self.albumTitle
    }
    
    func groupThumnail() -> Any? {
        if self.bPreFetched == false {
            self.bPreFetched = true
            self.fetchResult = PHAsset.fetchAssets(in: self.assetCollection!, options: PHFetchOptions.imagesOptions())
        }
        return fetchResult?.firstObject
    }
    
    class func transformToAlbumModeFromCollection(collectionList:Any, albumType: AlbumType) -> PHAlbumData {
        let album = PHAlbumData()
        
        if albumType == .AlbumCollection {
            
            let assetCollection = collectionList as! PHAssetCollection
            
            album.assetCollection = assetCollection
            album.fetchResult = nil
            album.albumTitle = assetCollection.localizedTitle
            album.bPreFetched = false
            
        }
        else { // albumType = AllResources
            
            let fetRes = collectionList as! PHFetchResult<PHAsset>
            album.fetchResult = fetRes
            album.albumTitle = "전체 사진"
            album.bPreFetched = false
            
        }
        
        return album
    }
    
    class func transformToAlbumModeFromCollection(collectionList:Any, albumType: AlbumType, bPreFetching: Bool) -> PHAlbumData {
        let album = PHAlbumData()
        
        if albumType == .AlbumCollection {
            let assetCollection = collectionList as! PHAssetCollection
            album.assetCollection = assetCollection
            album.fetchResult = nil
            if bPreFetching {
                album.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: PHFetchOptions.imagesOptions())
            }
            album.albumTitle = assetCollection.localizedTitle
            album.bPreFetched = bPreFetching
            
        }
        else { // albumType = AllResources
            
            let fetRes = collectionList as! PHFetchResult<PHAsset>
            album.fetchResult = fetRes
            album.albumTitle = "전체 사진"
            album.bPreFetched = false
 
            
        }
        
        return album
    }
    
}
