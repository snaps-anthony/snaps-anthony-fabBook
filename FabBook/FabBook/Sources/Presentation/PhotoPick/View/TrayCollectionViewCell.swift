//
//  TrayCollectionViewCell.swift
//  FabBook
//
//  Created by anthony on 2021/12/16.
//

import UIKit
import Photos

class TrayCollectionViewCell : UICollectionViewCell {
    
    //MARK: properties
    static let identifier = "TrayCollectionViewCell"
    private var imageView: UIImageView?
    private var reqid:PHImageRequestID?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deleteBtn: UIImageView!
    
    //MARK: initialize
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("debug : TrayCollectionViewCell required init " )
        
        backgroundColor = .blue.withAlphaComponent(0.3)
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
    }
    
    //MARK: methods
    func onData(_ asset: PHAsset) {
        self.containerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.imageView = self.viewWithTag(15) as? UIImageView ?? nil
        if self.imageView == nil {
            self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height))
            self.imageView?.contentMode = .scaleAspectFill
            self.imageView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.imageView!.tag = 15
            self.containerView.addSubview(self.imageView!)
            self.containerView.layer.masksToBounds = true
        }
        self.prepareForReuse()
        self.getAssetThumbnail(asset: asset)
    }
    
    func getAssetThumbnail(asset: PHAsset) {
        
        let manager = PHImageManager.default()
        if let reqid = self.reqid {
            manager.cancelImageRequest(reqid)
        }
        self.reqid = nil
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.resizeMode = .exact
        option.isSynchronous = false
        self.reqid = manager.requestImage(for: asset, targetSize: CGSize(width: self.containerView.frame.width * UIScreen.main.scale * 2, height: self.containerView.frame.height * UIScreen.main.scale * 2), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
            if let result = result {
                self.imageView?.image = result
            }
        })
    }
}
