//
//  DesignCollectionViewCell.swift
//  FabBook
//
//  Created by anthony on 2021/12/08.
//

import UIKit

class DesignCollectionViewCell: UICollectionViewCell {

    
    static let ID = "DesignCollectionViewCell"
    var imageView : UIImageView = {
        var view = UIImageView()
        view.backgroundColor = .gray
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var titleLabel : UILabel = {
       var lbl = UILabel()
        lbl.text = "design title"
        return lbl
    }()
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
        print("Debug : cell prepareForReuse")
    }
    
    func configureUI(){
        print("Debug : cell configureUI")
        backgroundColor = .green
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
        
    }
    
    func onData(_ designData : Design) {
        data = designData
        print("Debug : cell onData")
        print("debug : cell with -> \(self.frame.width)")
        print("debug : cell heigth -> \(self.frame.height)")
        
        // image
        
        // crop image
        
        // assign
    }
}
