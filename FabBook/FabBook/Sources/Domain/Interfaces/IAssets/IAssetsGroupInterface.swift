//
//  IAssetsGroupInterface.swift
//  FabBook
//
//  Created by anthony on 2021/12/13.
//

import Foundation
import UIKit

@objc protocol IAssetsGroupInterface {
    
    func numberOfAssets() -> NSNumber?
    func groupTitle() -> String?
    func groupThumnail() -> Any?
     
    @objc optional func hasLoadmoreItems() -> Bool
    @objc optional func cancelPosterLoad(imageView : UIImageView)
    @objc optional func insertPoster(imageView : UIImageView)
    @objc optional func loadAssetLists(finished: @escaping(Error?)->Void)
    @objc optional func numberOfLoadedAssets() -> UInt
//    @objc optional func assetAtIndex(index: Int) -> IAssetInterface?
//    @objc optional func indexOfAsset(asset : IAssetInterface) -> Int
//    @objc optional func enumerateAssetsUsingBlock(completion : @escaping(_ asset : IAssetInterface, _ idx : Int, _ stop : Bool)-> Void)
    @objc optional func startCachingAssetsForIndexes(indexes: [NSNumber], wantSize:CGSize)
    @objc optional func stopCachingAssetsForIndexess(indexes: [NSNumber], wantSize:CGSize)
    @objc optional func stopCachingAllAssets()
    
    
}
