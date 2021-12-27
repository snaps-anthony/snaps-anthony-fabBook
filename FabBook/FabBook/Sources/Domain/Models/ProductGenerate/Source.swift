//
//  Source.swift
//  FabBook
//
//  Created by anthony on 2021/12/27.
//

import Foundation


let SourceTypeColor = "color"
let SourceTypeWebitem = "webitem"
let SourceTypeBrowseFile = "browse_file"
let SourceTypeBorder = "border"
let SourceUploadTypeUnknown = "unknown"
let SourceUploadTypeFile = "file"
let SourceUploadTypeURL = "url"

class Source {
    var uploadType : String
    var originalURL : String
    var thumbnailURL : String
    var orgFileName : String
    var width : String
    var height : String
    var createDate : String
    var coverType : String
    
    init(){
        uploadType = ""
        originalURL = ""
        thumbnailURL = ""
        orgFileName = ""
        width = ""
        height = ""
        createDate = ""
        coverType = ""
    }
    
}
