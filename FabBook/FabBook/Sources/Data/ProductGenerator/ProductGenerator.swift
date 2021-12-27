//
//  ProductGenerator.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation

class ProductGenerator {
    
    
    //MARK: properties
    static let shared = ProductGenerator()
    private init() {}
    
    var policy : PolicyInterface!
    var templateCode : String?
    var productCode : String?
    var glossytype : String?
    var paperCode : String?
    var category : IAssetsGroupCategoryInterface! // 앨범을 어디서 불러올것인가 : 디바이스, 구글, ...
    
    var projectNme : String = ""
    
    var selectedPhotoListObject = [PhotoListObject]()    // 디자인선택후 사진담기에서 선택된 사진(스냅스:selectedAssets) -> assetListType = .select
    var addedPhotoListObject = [PhotoListObject]()  // (스냅스:selectedAssetsData)  편집기에서 사진가져오기로 추가된 사진 -> assetListType = .Add
}
