//
//  FabBookPolicy.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation

final class FabBookPolicy : PolicyInterface {
    
    
    let limitPhotos = 30
    
    func checkAddAssetPolicy(selectPhotoCount : Int) -> Bool {
        if selectPhotoCount <= limitPhotos {
            return true
        }
        else{
            return false
        }
    }
    
}
