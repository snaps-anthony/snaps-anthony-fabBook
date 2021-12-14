//
//  AssetCollectionViewCell.swift
//  FabBook
//
//  Created by anthony on 2021/12/14.
//

import UIKit
import Photos

class AssetCollectionViewCell : UICollectionViewCell {
    
    //MARK: properties
    static let identifier = "AssetCollectionViewCell"
    
    @IBOutlet weak var checkOff: UIImageView!
    @IBOutlet weak var checkOnlyOn: UIImageView!
    @IBOutlet weak var checkOn: UIView!
    @IBOutlet weak var lbSelectedIndex: UILabel!
    @IBOutlet weak var btnCheckSelect: UIButton!
    @IBOutlet weak var viewEnableResolution: UIImageView!
    @IBOutlet weak var viewAlreadySelected: UIView!
    
    private var imageView: UIImageView?
    var loadCompleteAsset: Bool = false
    
    //MARK: initialize
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("debug : AssetCollectionViewCell required init " )
        
        backgroundColor = .blue.withAlphaComponent(0.3)
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
        loadCompleteAsset = false
        print("debug : AssetCollectionViewCell awakeFromNib " )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
        loadCompleteAsset = false
        print("debug : AssetCollectionViewCell prepareForReuse " )
    }
    
    //MARK: methods
    func onData(data asset : PHAsset){
        self.imageView = self.viewWithTag(15) as? UIImageView ?? nil
        if self.imageView == nil {
            self.imageView = UIImageView(frame: self.bounds)
            self.imageView?.contentMode = .scaleAspectFill
            self.imageView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.imageView!.tag = 15
            self.addSubview(self.imageView!)
            self.sendSubviewToBack(self.imageView!)
        }
        self.bringSubviewToFront(self.btnCheckSelect)
        self.prepareForReuse()
        self.getAssetThumbnail(asset: asset )
    }
    
    func setChecked(){
        
    }
    
    func setEnableResolution(){
        
    }
    
    func getAssetThumbnail(asset: PHAsset) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.resizeMode = .exact
        option.isSynchronous = false
        manager.requestImage(for: asset, targetSize: CGSize(width: self.bounds.width * UIScreen.main.scale, height: self.bounds.height * UIScreen.main.scale), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            self.loadCompleteAsset = true
            if let result = result {
                self.imageView?.image = result
            }
        })
        
//        let options = PHImageRequestOptions()
//        options.deliveryMode = .highQualityFormat
//        options.isNetworkAccessAllowed = true
//        options.isSynchronous = false
//        options.version = .current
//        options.progressHandler = {
//            (progress, error, stop, info) in
//            gzprintFunc("prgress" + String(progress))
//        }
//        if #available(iOS 13, *) {
//            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { (imageData, dataUTI, orientation, info) in
//                if let imageData = imageData {
//                    self.phAssetDataLoaded(imageData)
//                }
//            }
//        }
//        else {
//            PHImageManager.default().requestImageData(for: asset, options: options) { (imageData, dataUTI, orientation, info) in
//                self.phAssetDataLoaded(imageData)
//            }
//        }
    }
}
