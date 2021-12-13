//
//  PHAssetCollection+Utility.swift
//  FabBook
//
//  Created by anthony on 2021/12/13.
//

import Photos

extension PHAssetCollection {
    
    func supportedCollection() -> Bool {
        switch self.assetCollectionSubtype {
        case .smartAlbumAllHidden,          // 가려짐
                .smartAlbumTimelapses,      // 타임랩스
                .smartAlbumSlomoVideos,     // 슬로 모션
                .smartAlbumVideos,          // 비디오
                .albumCloudShared,          // 클라우드 공유
                .albumMyPhotoStream,        // 포토 스트림
                .smartAlbumDepthEffect,     //심도효과
                .smartAlbumLivePhotos,       //라이브포토
                .smartAlbumBursts,          //고속연사
                .smartAlbumLongExposures :   //  장노출
            return false
        default:
            return true
        }
    }
    
    func supportePreFetchingSmartAlbumSubType() -> Bool {
        switch self.assetCollectionSubtype {
        case .smartAlbumUserLibrary, .smartAlbumRecentlyAdded :
            return false
        default:
            return true
        }
    }
    
    
    
}
