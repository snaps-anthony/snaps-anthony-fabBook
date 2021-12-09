//
//  Design.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation

struct Design : Codable {
    let thumbnailImageUrl : String?
    let middleSizeImageUrl : String?
    var templateId : String?
    let templateCode : String?
    let xmlPath : String?
    let searchTags : String?
    let maskCount : String?
    let displayType : String?
    let displayName : String?
    let displayNumber : String?
    let registrationDate : String?
    let version : String?
    let outerYn : String?
    let jsonContents : String?
}


struct JsonContents : Codable {
    
}
