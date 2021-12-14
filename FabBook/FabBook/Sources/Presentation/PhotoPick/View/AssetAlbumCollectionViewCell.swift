//
//  AssetAlbumCollectionViewCell.swift
//  FabBook
//
//  Created by anthony on 2021/12/13.
//

import UIKit
import Photos

class AssetAlbumCollectionViewCell : UICollectionViewCell {
    static let identifier = "AssetAlbumCollectionViewCell"
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbCount: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("debug : AssetAlbumCollectionViewCell required init " )
        backgroundColor = .red.withAlphaComponent(0.3)
    }
    
    func onData(data : IAssetsGroupInterface, index:Int){
        imageView.backgroundColor = .black.withAlphaComponent(0.5)
        lbTitle.text = data.groupTitle() ?? "group title "
        lbCount.text = "\(data.numberOfAssets()!.intValue)"
        
        let width = self.imageView.frame.size.width * UIScreen.main.scale
        let height = self.imageView.frame.size.height * UIScreen.main.scale
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        if let thumInfo = data.groupThumnail() as? PHAsset {
            PHImageManager.default().requestImage(for:thumInfo, targetSize: CGSize(width: width , height: height), contentMode: .aspectFill, options: options) { [weak self] image, info in
                self?.imageView.image = image
            }
        }
        
    }
}
