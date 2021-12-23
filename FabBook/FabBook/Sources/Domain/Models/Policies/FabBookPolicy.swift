//
//  FabBookPolicy.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation

final class FabBookPolicy : PolicyInterface {
    
    var numberOfLimitAssets = 30
    
    var assetListType : kAssetsListType = kAssetsListType.kAssetsListTypeUnknown
    
    func checkAddAssetPolicy(selectPhotoCount : Int) -> Bool {
        if selectPhotoCount <= numberOfLimitAssets {
            return true
        }
        else{
            return false
        }
    }
    
    func checkConfirmPolicy() -> Bool {
        return true
    }
}
