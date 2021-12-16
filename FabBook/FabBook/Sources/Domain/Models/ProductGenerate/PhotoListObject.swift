//
//  PhotoListObject.swift
//  FabBook
//
//  Created by anthony on 2021/12/16.
//

import UIKit


class PhotoListObject  {
    
    var content : String
    var linedText : String?
    var created_at : Date?
    var photoId : String
    var media_thumbnail_url : String
    var media_type : String
    var media_url : String
    var imageType : String
    var gubun : String
    var selected : Bool
    var rotate : Float
    var thumbAngle : Float
    var needOffsetCalc : Bool? //사진 인화 오프셋 적용시 exif 정보가 90, 180도의 경우 각값에 -1을 하여 계산해야함.
    var exifOrientation : NSNumber?
    var year : String
    var seq : String
    var saveFileName : String
    var orgFileName : String
    var modifyDate : String?
    var btn : UIButton?
    var imgWidth : Float
    var imgHeight : Float
    var exifAngle : Float
    var commentCount : Int
    var likeCount : Int
    var offsetX : CGFloat?
    var offsetY : CGFloat?
    var cropImage : UIImage?
    var imageOrientation : Int
    var pendingImage : Bool
    var checkImageData : Bool
    var uploadedProgress : Float?
    var imageByte : Float?
    var uploadedOrginPath : String?
    var uploadedThumbPath : String?
    var orderCount : Int
    var retryCount : Int?
    var logz_media_subtypes : UInt // 로그용 이미지 subtypes
    var logz_imgWidth : Float // 로그용 이미지 Width
    var logz_imgHeight : Float // 로그용 이미지 Height
    
    func replica() -> PhotoListObject {
        let newObj = PhotoListObject()
        
        return newObj
    }
    
    func removeCropInfo() {
        self.offsetX = 0
        self.offsetY = 0
        self.cropImage = nil
    }
    
    init() {
        self.content = ""
        self.created_at = nil
        self.photoId = ""
        self.media_thumbnail_url = ""
        self.media_type = ""
        self.media_url = ""
        self.selected = false
        self.imageType = ""
        self.gubun = ""
        self.rotate = 0.0
        self.year = ""
        self.seq = ""
        self.saveFileName = ""
        self.orgFileName = ""
        self.imgWidth = 0.0
        self.imgHeight = 0.0
        self.commentCount = 0
        self.likeCount = 0
        self.orderCount = 0
        self.thumbAngle = 0.0
        self.imageOrientation = UIImage.Orientation.up.rawValue
        self.pendingImage = false
        self.exifAngle = 0.0
        self.checkImageData = false
        
        self.logz_media_subtypes = 0
        self.logz_imgWidth = 0.0
        self.logz_imgHeight = 0.0
    }
}
