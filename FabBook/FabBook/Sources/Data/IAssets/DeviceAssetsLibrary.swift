//
//  DeviceAssetsLibrary.swift
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

import Foundation

class DeviceAssetsLibrary : IAssetsLibraryInterface {
    
    func assetsGroup(_ block: @escaping ([Any], Error?) -> Void) {
        DeviceAssetLoader.shared.assetsGroupWithResult(completion: block)
    }
    
    func assetsGroup(withParam param: [String], block: @escaping ([Any], Error?) -> Void) {
        DeviceAssetLoader.shared.setFetchFilter(identifiers: param)
        DeviceAssetLoader.shared.assetsGroupWithResult(completion: block)
    }
    
}
