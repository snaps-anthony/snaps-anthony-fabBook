//
//  DesignListViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/08.
//

import UIKit

class DesignListViewController: BaseViewController {
    
    //MARK: UI
    var titleLabel : UILabel = {
        var lbl = UILabel()
        lbl.text = "디자인"
        lbl.font = .boldSystemFont(ofSize: 18)
        return lbl
    }()
    var cartBtn : UIButton?
    var menuBtn : UIButton?
    var collectionView : UICollectionView!
    
    
    //MARK: properties
    var viewModel = DesignListViewModel()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        viewModel.getDesigList()
    }
    
    //MARK: methods
    private func setup(){
        
        // titleLabel
        
        
        
        
        // collectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        let width = (view.frame.width / 2) - 60
        layout.itemSize = CGSize(width: width, height: 200)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DesignCollectionViewCell.self, forCellWithReuseIdentifier: DesignCollectionViewCell.ID)
        view.addSubview(collectionView)
        
    }
    
    private func bind(){
        
    }
    
    
}
