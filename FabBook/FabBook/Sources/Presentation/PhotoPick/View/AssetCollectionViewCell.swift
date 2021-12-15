//
//  AssetCollectionViewCell.swift
//  FabBook
//
//  Created by anthony on 2021/12/14.
//

import UIKit
import Photos
import RxSwift

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
    var _isChecked : Bool? = nil
    var _cellAsset : PHAsset? = nil
    var _isEnable : Bool? = nil
    
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
//        print("debug : AssetCollectionViewCell prepareForReuse " )
        self._isChecked = nil
        self._cellAsset = nil
        self._isEnable = nil
    }
    
    //MARK: methods
    
    func setChecked(_ isChecked: Bool) {
        self.checkOnlyOn.isHidden = !isChecked
    }
    
    func setEnableResolution(_ isEnable: Bool) {
        viewEnableResolution.isHidden = isEnable

    }
    
    func setAlreadySelected(_ alreadySelected: Bool) {
        viewAlreadySelected.isHidden = alreadySelected
    }
    
//    func getCellInfo() -> [String:Any] {
//        var infoDic = [String:Any]()
//        infoDic["asset"] = self._cellAsset!
//        infoDic["checkSelect"] = self._isChecked!
//        infoDic["isEnable"] = self._isEnable!
//        return infoDic
//    }
    func onData(asset : PHAsset){
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
    }
    
    func updateCheckStatus( completion: @escaping(Bool, Bool)-> Void) {
        let currentCheckStatus = !self.checkOnlyOn.isHidden // status와 hidden은 반대관계
        let newStatus = !currentCheckStatus
        self.checkOnlyOn.isHidden = !newStatus // status와 hidden은 반대관계
        let isEnable = true
        completion(newStatus, isEnable)
    }
    
    func updateCheckStatus(newStatus:Bool){
        
    }
}
