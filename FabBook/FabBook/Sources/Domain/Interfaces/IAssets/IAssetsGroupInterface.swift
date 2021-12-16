//
//  IAssetsGroupInterface.swift
//  FabBook
//
//  Created by anthony on 2021/12/13.
//

import Foundation
import UIKit

protocol IAssetsGroupInterface {
    
    func numberOfAssets() -> NSNumber?
    func groupTitle() -> String?
    func groupThumnail() -> Any?
     
    func hasLoadmoreItems() -> Bool
    func cancelPosterLoad(imageView : UIImageView)
    func insertPoster(imageView : UIImageView)
    func loadAssetLists(finished: @escaping(Error?)->Void)
    func numberOfLoadedAssets() -> UInt
    func assetAtIndex(index: Int) -> IAssetInterface?
    func indexOfAsset(asset : IAssetInterface) -> Int?
    func enumerateAssetsUsingBlock(block : @escaping(_ asset : IAssetInterface, _ idx : Int, _ stop : Bool)-> Void)
    func startCachingAssetsForIndexes(indexes: [NSNumber], wantSize:CGSize)
    func stopCachingAssetsForIndexess(indexes: [NSNumber], wantSize:CGSize)
    func stopCachingAllAssets()
    
    
}
