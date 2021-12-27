//
//  ProductGenerator.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation


// project upload type
let ProjectUploadTypeInsert = "i"
let ProjectUploadTypeModify = "m"
let SocialBookPostCountAll = "all"
let SocialBookPostCountMine = "mine"

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
    
    var projectName : String = ""
    var projectCode : String = ""
    
    // 업로드
    var projectUploadType : String = ""
    
    var selectedPhotoListObject = [PhotoListObject]()    // 디자인선택후 사진담기에서 선택된 사진(스냅스:selectedAssets) -> assetListType = .select
    var addedPhotoListObject = [PhotoListObject]()  // (스냅스:selectedAssetsData)  편집기에서 사진가져오기로 추가된 사진 -> assetListType = .Add
    
    
    //MARK: methods
    func executeAutosave(){
        
    }
}
