//
//  IAsset.swift
//  FabBook
//
//  Created by anthony on 2021/12/13.
//

import UIKit

protocol IAssetInterface  {
    
    var thumbnailURL : URL? { get  }
    var schemeThumbnailURLString : String? { get  }
    var schemeThumbnailURLStringForSwift : String? { get  }
    var originalURL : URL? { get  }
    var size : CGSize? { get  }
    var best : UInt? { get  }
    var replies : [Any]? { get  }
    var feeling : [Any]? { get  }
    var numberOfReplies : UInt? { get  }
    var numberOfFeeling : UInt? { get  }
    var assetID : String { get }
    func cancelImageLoad(imageView: UIImageView)
    func insertThumbnail(imageView : UIImageView, wamtSize : CGSize)
    func insertThumbnail(imageView : UIImageView, wamtSize : CGSize, finished: @escaping()->Void  )
    func thumbnailImageWantSize(wantSize: CGSize, resultBlock : @escaping(UIImage, Error?)->Void )
    func exportPhotoListObject() -> PhotoListObject
}
