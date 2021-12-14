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
//    @objc optional func assetAtIndex(index: UInt) -> IAssetInterface?
//    @objc optional func indexOfAsset(asset : IAssetInterface) -> UInt
//    @objc optional func enumerateAssetsUsingBlock(completion : @escaping(_ asset : IAssetInterface, _ idx : UInt, _ stop : Bool)-> Void)
    @objc optional func startCachingAssetsForIndexes(indexes: [NSNumber], wantSize:CGSize)
    @objc optional func stopCachingAssetsForIndexess(indexes: [NSNumber], wantSize:CGSize)
    @objc optional func stopCachingAllAssets()
    @objc optional func getGroupTheMonth() -> [Any]
    @objc optional func getGroupTheDay() -> [Any]
    @objc optional func getGroupTheMonthEight() -> [Any]
    
    
}
