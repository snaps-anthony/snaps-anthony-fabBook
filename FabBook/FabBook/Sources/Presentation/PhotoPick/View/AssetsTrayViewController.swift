//
//  AssetsTrayViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import UIKit

class AssetsTrayViewController: BaseViewController {

    
    //MARK: UI
    @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet weak var leftBackBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var rightSaveBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var assetsCollectionView: UICollectionView!
    @IBOutlet weak var assetsCollectionViewTop: NSLayoutConstraint!
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    @IBOutlet weak var groupsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var trayCollectionView: UICollectionView!
    @IBOutlet weak var trayCollectionViewHeight: NSLayoutConstraint!
    
    //MARK: properties
    var viewModel = AssetsTrayViewModel()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        setupNavigationItems()
        setupBindings()
        
//        //  FethGroups
//        viewModel.groupsFetching.onNext(())
    }
    
    
    //MARK: methods
    func setupNavigationItems(){
    
        leftBackBarBtn.target = self
        leftBackBarBtn.action = #selector(didClickLeftBackButton)
     
        rightSaveBarBtn.title = "담기"
        rightSaveBarBtn.tintColor = .black
        rightSaveBarBtn.target = self
        rightSaveBarBtn.action = #selector(didClickRightSavekButton)
        
    }
    
    
    func setupBindings(){
        
    }
    
    @objc func didClickLeftBackButton(){
        print("debug : didClickLeftBackButton ")
    }
    
    
    @objc func didClickRightSavekButton(){
        print("debug : didClickRightSavekButton ")
    }
    

}
