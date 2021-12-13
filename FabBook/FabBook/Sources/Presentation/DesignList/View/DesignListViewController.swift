//
//  DesignListViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/08.
//

import UIKit
import RxSwift
import RxCocoa

class DesignListViewController: BaseViewController {
    
    //MARK: UI
    var titleLabel : UILabel = {
        var lbl = UILabel()
        lbl.text = "디자인"
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    var cartBtn : UIButton = {
        var btn = UIButton()
        btn.setTitle("장바구니", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didClickCartBtn), for: .touchUpInside)
        return btn
    }()
    var menuBtn : UIButton = {
        var btn = UIButton()
        btn.setTitle("메뉴", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didClickMenuBtn), for: .touchUpInside)
        return btn
    }()
    var collectionView : UICollectionView!
    
    
    //MARK: properties
    var viewModel = DesignListViewModel()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureUI()
        bind()
        viewModel.fetchDesigList()
    }
    
    //MARK: methods
    
    private func setupCollectionView(){
        //layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let width = (view.frame.width - 60 ) / 2
        layout.itemSize = CGSize(width: width, height: (width * 1.4))
        // collectionview
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .yellow
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DesignCollectionViewCell.self, forCellWithReuseIdentifier: DesignCollectionViewCell.ID)
    }
    
    private func configureUI(){
        
        // hide navigation bar
        navigationController?.isNavigationBarHidden = true
        
        // titleLabel
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    
        // menuBtn
        view.addSubview(menuBtn)
        menuBtn.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        menuBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        // cartBtn
        view.addSubview(cartBtn)
        cartBtn.centerYAnchor.constraint(equalTo: menuBtn.centerYAnchor).isActive = true
        cartBtn.rightAnchor.constraint(equalTo: menuBtn.leftAnchor, constant: -20).isActive = true
        
        // collectionView
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func bind(){
    
        viewModel.designListSubject.bind(to: collectionView.rx.items(cellIdentifier: DesignCollectionViewCell.ID, cellType: DesignCollectionViewCell.self)) { index, data, cell in
            cell.onData(data)
        }.disposed(by: self.disposeBag)
        
        Observable.zip(collectionView.rx.modelSelected(Design.self), collectionView.rx.itemSelected)
            .bind { [weak self] model, indexPath in
                print("debug : selected template Code -> \(model.templateCode ?? "no template code")")
                
                // ProductGenerator setting
                let policy = FabBookPolicy()
                ProductGenerator.shared.policy = policy
                ProductGenerator.shared.templateCode = model.templateCode
                ProductGenerator.shared.category = DeviceAssetsGroupCategory() // 디바이스 사진 picker
                
                //execute PhotoPicker                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                if storyBoard != nil {
                    print("debug : find storyboard")
                    let vc = storyBoard.instantiateViewController(withIdentifier: "AssetsTrayViewController")
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }.disposed(by: self.disposeBag)
    }
    
    @objc func didClickCartBtn(){
        print("debug: DesignListViewController didClickCartBtn ")
    }
    
    @objc func didClickMenuBtn(){
        print("debug: DesignListViewController didClickMenuBtn ")
    }
    
}
