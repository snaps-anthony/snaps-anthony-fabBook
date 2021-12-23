//
//  PolicyInterface.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation

enum kAssetsListType :Int {
    case kAssetsListTypeUnknown // default
    case kAssetsListTypeSelect  // 사진선택, 정책적용 O, 트레이 체크 O
    case kAssetsListTypeChange  // 사진변경, 정책적용 X, 트레이 체크 X
    case kAssetsListTypePosts    // SNS book - 제외 포스트
    case kAssetsListTypeAdd      // 스마트스냅스 사진 추가
}

protocol PolicyInterface {
 
    var numberOfLimitAssets : Int {get set}
    var assetListType : kAssetsListType { get set}
    
    func checkAddAssetPolicy(selectPhotoCount : Int) -> Bool
    
    func checkConfirmPolicy() -> Bool
}
