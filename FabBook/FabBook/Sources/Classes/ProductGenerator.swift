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
    var policy : PolicyInterface?
    var templateCode : String?
    var productCode : String?
    var glossytype : String?
    var paperCode : String?
    var category : IAssetsGroupCategoryInterface! // 앨범을 어디서 불러올것인가 : 디바이스, 구글, ...
    
}
