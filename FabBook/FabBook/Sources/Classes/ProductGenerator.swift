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
    
}
