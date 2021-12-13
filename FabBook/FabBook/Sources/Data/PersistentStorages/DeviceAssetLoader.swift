//
//  DeviceAssetLoader.swift
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

import Foundation
import Photos
import UIKit

class DeviceAssetLoader {
    
    // MARK: properties
    static let shared = DeviceAssetLoader()
    private init() {}
    var fetchFilters : [String]? = nil
    
    //MARK: methods
    func assetsGroupWithResult( completion : @escaping ([IAssetsGroupInterface]?, Error?) -> Void){
        
        // SnapsDeviceAssetLoader -> assetsGroupWithResultBlock
        
        //TODO: photo 접근 권한체크
        //TODO: 코드 실행 시간 측정
        
        var groups = [IAssetsGroupInterface]()
        
        var totalImages : PHFetchResult<PHAsset>! = nil
        if self.fetchFilters != nil {
            totalImages = PHAsset.fetchAssets(withLocalIdentifiers: self.fetchFilters!, options: PHFetchOptions.imagesOptions())
        }
        else {
            totalImages = PHAsset.fetchAssets(with: PHFetchOptions.imagesOptions())
        }
        
        // 사진이 한장도 없다면, 사진을 담고 있는 그룹또한 없음
        if totalImages.count < 1 {
            let err = NSError() //TODO: SNAPS Error 정의
//            completion(nil,err)
            completion(groups,err)
            return
        }
        else{
            let albumData = PHAlbumData.transformToAlbumModeFromCollection(collectionList: totalImages, albumType: .AllResources)
            groups.append(albumData)
        }
        
        // 스마트앨범
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        smartAlbum.enumerateObjects { assetCollection, idx, stop in
            if assetCollection.supportedCollection() {
                var preFetch = false
                if assetCollection.supportePreFetchingSmartAlbumSubType() {
                    preFetch = true
                }
                let albumData = PHAlbumData.transformToAlbumModeFromCollection(collectionList: assetCollection, albumType: .AlbumCollection, bPreFetching: preFetch)
                if (albumData.fetchResult?.count ?? 0 > 0) || (albumData.fetchResult == nil && albumData.bPreFetched == false) {
                    groups.append(albumData)
                }
            }
        }
        
        // 사용자 앨범
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: PHFetchOptions.groupsOptions())
        userAlbums.enumerateObjects { assetCollection, idx, stop in
            if assetCollection.supportedCollection() {
                let albumData = PHAlbumData.transformToAlbumModeFromCollection(collectionList: assetCollection, albumType: .AlbumCollection)
                if (albumData.fetchResult?.count ?? 0 > 0) || (albumData.fetchResult == nil && albumData.bPreFetched == false) {
                    groups.append(albumData)
                }
            }
        }
        
        completion(groups, nil)
    }
    
    func setFetchFilter(identifiers : [String]){
        
    }
    
    
    
    
}
