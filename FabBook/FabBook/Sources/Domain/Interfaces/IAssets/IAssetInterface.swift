//
//  IAsset.swift
//  FabBook
//
//  Created by anthony on 2021/12/13.
//

import UIKit

protocol IAssetInterface  {
    
    var thumbnailURL : URL? { get set }
    var schemeThumbnailURLString : String? { get set }
    var schemeThumbnailURLStringForSwift : String? { get set }
    var originalURL : URL? { get set }
    var size : CGSize? { get set }
    var best : UInt? { get set }
    var replies : [Any]? { get set }
    var feeling : [Any]? { get set }
    var numberOfReplies : UInt? { get set }
    var numberOfFeeling : UInt? { get set }
    var assetID : String? { get set }
    
//    func copyToSource(source: Source)
//    func dateToTextList(testList : TextList)
    
    func cancelImageLoad(imageView: UIImageView)
    func insertThumbnail(imageView : UIImageView, wamtSize : CGSize)
    func insertThumbnail(imageView : UIImageView, wamtSize : CGSize, finished: @escaping()->Void  )
    func thumbnailImageWantSize(wantSize: CGSize, resultBlock : @escaping(UIImage, Error?)->Void )
}
