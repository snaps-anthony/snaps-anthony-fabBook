//
//  Utility.swift
//  FabBook
//
//  Created by anthony on 2021/12/17.
//

import UIKit


enum STANDARD_ORIENTATION : Int {
    case Standard_Orientation_Up = 1
    case Standard_Orientation_UpMirrored = 2
    case Standard_Orientation_Down = 3
    case Standard_Orientation_DownMirrored = 4
    case Standard_Orientation_LeftMirrored = 5
    case Standard_Orientation_Right = 6
    case Standard_Orientation_RightMirrored = 7
    case Standard_Orientation_Left = 8
}

class Utility {
    
    class func metaData(fromImageData : Data) -> [AnyHashable:Any]? {
        let cfImageData = fromImageData as CFData
        guard let imageSource = CGImageSourceCreateWithData(cfImageData, nil) else { return nil}
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) else { return nil}
        return imageProperties as? [AnyHashable : Any]
    }
    
    class func removeMirroredStandardOrientation(orientation : Int) -> Int {
        var ret = orientation
        switch ret {
        case UIImage.Orientation.upMirrored.rawValue:
            ret = UIImage.Orientation.up.rawValue
            break
        case UIImage.Orientation.downMirrored.rawValue:
            ret = UIImage.Orientation.down.rawValue
            break
        case UIImage.Orientation.leftMirrored.rawValue:
            ret = UIImage.Orientation.left.rawValue
            break
        case UIImage.Orientation.rightMirrored.rawValue:
            ret = UIImage.Orientation.right.rawValue
            break
        default:
            break
        }
        return ret
    }
    
    class func imageOrientation(fromEXIFOrientation exifOrientation : Int) -> UIImage.Orientation {
        
        var imageOrientation = UIImage.Orientation.up
        
        switch exifOrientation {
        case STANDARD_ORIENTATION.Standard_Orientation_Up.rawValue: // 1
            imageOrientation = UIImage.Orientation.up
            break
        case STANDARD_ORIENTATION.Standard_Orientation_Down.rawValue: // 3
            imageOrientation = UIImage.Orientation.down
            break
        case STANDARD_ORIENTATION.Standard_Orientation_Left.rawValue: // 8
            imageOrientation = UIImage.Orientation.left
            break
        case STANDARD_ORIENTATION.Standard_Orientation_Right.rawValue: // 6
            imageOrientation = UIImage.Orientation.right
            break
        case STANDARD_ORIENTATION.Standard_Orientation_UpMirrored.rawValue: // 2
            imageOrientation = UIImage.Orientation.upMirrored
            break
        case STANDARD_ORIENTATION.Standard_Orientation_DownMirrored.rawValue: // 4
            imageOrientation = UIImage.Orientation.downMirrored
            break
        case STANDARD_ORIENTATION.Standard_Orientation_LeftMirrored.rawValue: // 5
            imageOrientation = UIImage.Orientation.leftMirrored
            break
        case STANDARD_ORIENTATION.Standard_Orientation_RightMirrored.rawValue: // 7
            imageOrientation = UIImage.Orientation.rightMirrored
            break
        default:
            break
        }
        
        return imageOrientation
    }
    
    class func getDegreeforOrientation(orientation : UIImage.Orientation) -> CGFloat {
        
        switch orientation {
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            return 0.0
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            return 180.0
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            return 270.0
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            return 90.0
        default:
            return 0.0
        }
    }
//    
    class func getImageOrientation(fromEXIFOrientation exifOrientation : Int, imageSize: CGSize) -> CGSize {
        
        switch exifOrientation {
        case 5,6,7,8:
            return CGSize(width: imageSize.height, height: imageSize.width)
        default:
            return imageSize
        }
    }
    
}
