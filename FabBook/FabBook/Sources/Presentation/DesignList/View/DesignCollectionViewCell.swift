//
//  DesignCollectionViewCell.swift
//  FabBook
//
//  Created by anthony on 2021/12/08.
//

import UIKit

class DesignCollectionViewCell: UICollectionViewCell {

    
    static let ID = "DesignCollectionViewCell"
    var imageView : UIImageView!
    var titleLabel = UILabel()
    var data : Design?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configureUI(){
        backgroundColor = .green
        
        //imageView
        imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.width))
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        // title
        titleLabel.text = "design title"
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    func onData(_ designData : Design) {
        data = designData
        
        // title
        titleLabel.text = data?.templateCode ?? "design title"
        
        // image 
        
        // crop image
        
        // assign
    }
}
