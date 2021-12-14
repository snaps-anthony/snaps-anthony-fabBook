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
    
    
    //MARK: initialize
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("debug : AssetCollectionViewCell required init " )
        
        backgroundColor = .blue.withAlphaComponent(0.3)
    }
    
    //MARK: methods
    func onData(data : PHAsset){
        
        
    }
}
