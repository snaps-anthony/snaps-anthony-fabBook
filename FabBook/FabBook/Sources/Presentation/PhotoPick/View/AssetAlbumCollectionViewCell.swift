//
//  AssetAlbumCollectionViewCell.swift
//  FabBook
//
//  Created by anthony on 2021/12/13.
//

import UIKit


class AssetAlbumCollectionViewCell : UICollectionViewCell {
    static let identifier = "AssetAlbumCollectionViewCell"
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbCount: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("debug : AssetAlbumCollectionViewCell required init " )
        
        backgroundColor = .blue.withAlphaComponent(0.3)
    }
    
    func onData(data : IAssetsGroupInterface, index:Int){
        print("debug : AssetAlbumCollectionViewCell onData :  index -> \(index), onData -> \(data.groupTitle()), ")
        lbTitle.text = data.groupTitle() ?? "group title "
        lbCount.text = "-777"
        imageView.backgroundColor = .black
        
    }
}
