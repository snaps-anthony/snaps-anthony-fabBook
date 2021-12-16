//
//  AssetsTrayViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class AssetsTrayViewController: BaseViewController {

    
    //MARK: UI
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var leftBackBarBtn: UIBarButtonItem!
    @IBOutlet weak var rightSaveBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var assetsCollectionView: UICollectionView! {
        didSet{
            assetsCollectionView.backgroundColor = .yellow
        }
    }
    @IBOutlet weak var assetsCollectionViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var groupsCollectionView: UICollectionView! {
        didSet {
            groupsCollectionView.backgroundColor = .orange
        }
    }
    @IBOutlet weak var groupsCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var trayCollectionView: UICollectionView! {
        didSet {
            trayCollectionView.backgroundColor = .green
        }
    }
    @IBOutlet weak var trayCollectionViewHeight: NSLayoutConstraint!
    
    //MARK: properties
    var viewModel = AssetsTrayViewModel()
    var disposeThrottleBag = DisposeBag()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        setupNavigationItems()
        setupBindings()
        viewModel.fetchGroups()
    }
    
    
    //MARK: methods
    func setupNavigationItems(){
    
        //left
        leftBackBarBtn.target = self
        leftBackBarBtn.action = #selector(didClickLeftBackButton)
     
        //right
        rightSaveBarBtn.title = "(0/30) 담기"
        rightSaveBarBtn.tintColor = .black
        rightSaveBarBtn.target = self
        rightSaveBarBtn.action = #selector(didClickRightSavekButton)
    }
    
    func trayViewAnimationShow(isHide : Bool) {
        
    }
    
    
    func setupBindings(){
        
        // groupSelectionStatus
        viewModel.groupSelectionStatus
            .subscribe(
                onNext: { [unowned self] viewStatus in
                    switch viewStatus {
                    case .preGroupSelected:
                        // navigation title
                        self.setupTitleView(title: "사진선택", imageName: "")
                        // navigation right item
                        
                        // show groupCollectionView
                        self.groupsCollectionViewHeight.constant = (self.view.frame.size.height) - (self.navigationBar.frame.size.height)
                        break
                    case .postGroupSelected:
                        // navigation title
                        self.setupTitleView(title: self.viewModel.currentGroup?.groupTitle() ?? "사진선택", imageName: "")
                        // navigation right item
                        // hide groupCollectionView
                        self.groupsCollectionViewHeight.constant = 0
                        break
                    case .postGroupSelectedShowGroups:
                        // show groupCollectionView
                        self.groupsCollectionViewHeight.constant = (self.view.frame.size.height) - (self.navigationBar.frame.size.height)
                        break
                        
                    }
                }
            ).disposed(by: self.disposeBag)
        
        // 선택된 사진 갯수
        viewModel.selectedAssetCountSubject
            .subscribe(
                onNext: { [weak self] count in
                    self?.rightSaveBarBtn.title = "(\(count)/30) 담기"
                }
            ).disposed(by: self.disposeBag)
        
        
        // groupsCollectionView data binding
        viewModel.fetchGroupsResult
            .bind(to: groupsCollectionView.rx.items(cellIdentifier: AssetAlbumCollectionViewCell.identifier, cellType: AssetAlbumCollectionViewCell.self)) { indexPath, item, cell in
                cell.onData(data: item, index: indexPath)
            }.disposed(by: self.disposeBag)
        
        // groupsCollectionView  flowlayout
        groupsCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        // groupsCollectionView select
        Observable.zip( groupsCollectionView.rx.itemSelected, groupsCollectionView.rx.modelSelected(IAssetsGroupInterface.self))
            .bind{ [weak self] indexPath, model in
                self?.viewModel.didTapGroupCollectionViewCell(cellInfo: ["indexPath":indexPath, "selectedGroup":model])
            }
            .disposed(by: disposeBag)
        
        // assetCollectionView data binding
        viewModel.fetchAssetReultSubject
            .bind(to: assetsCollectionView.rx.items(cellIdentifier: AssetCollectionViewCell.identifier, cellType: AssetCollectionViewCell.self)) { [unowned self] indexPath, item, cell in

                let asset = item["asset"] as! IAssetInterface
                let checkSelect = viewModel.getIsSelectedAssetCell(asset: asset)
                let isEnableResolution = viewModel.getIsEnableResolutionCell(asset: asset)
                
                cell.onData(asset: asset)
                cell.setChecked(checkSelect)
                cell.setEnableResolution(isEnableResolution)
                cell.btnCheckSelect.indexPath = IndexPath(item: indexPath, section: 0)
                cell.btnCheckSelect.addTarget(self, action: #selector(didClickAssetCellCheckBtn(_:)), for: .touchUpInside)
            }.disposed(by: self.disposeBag)
        
        // assetCollectionView  flowlayout
        assetsCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        // assetCollectionView select
        Observable.zip( assetsCollectionView.rx.itemSelected, assetsCollectionView.rx.modelSelected([String:Any].self))
//            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .bind{ [weak self] indexPath, model in
                self?.didClickAssetCollectionViewCell(cellIndex: indexPath)
            }
            .disposed(by: self.disposeBag)
        
        // 선택된 assetCollectionViewCell의 checked/unchecked 업데이트
        viewModel.selectUpdateAssetResult
            .subscribe { [weak self]  cellIndex, selectStatus in
                if let visibleCell = self?.assetsCollectionView.cellForItem(at: cellIndex) as? AssetCollectionViewCell{
                    visibleCell.setChecked(selectStatus)
                }
            }.disposed(by: self.disposeBag)
        
        // trayCollcetionView data binding
        viewModel.selectedAssetsSubject
            .bind(to: trayCollectionView.rx.items(cellIdentifier: TrayCollectionViewCell.identifier, cellType: TrayCollectionViewCell.self)) { index, item, cell in
                let asset = item["asset"] as! IAssetInterface
                cell.onData(asset)
            }.disposed(by: self.disposeBag)
        
        // trayCollcetionView select
        Observable.zip( trayCollectionView.rx.itemSelected, trayCollectionView.rx.modelSelected([String:Any].self))
//            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .bind{ [weak self] indexPath, model in
                self?.viewModel.didTapTrayCollectionViewCell(cellindex: indexPath)
            }
            .disposed(by: self.disposeBag)
        
        // taryCollectionView scroll,
        viewModel.lastUpdatedTrayCollectionvCellIndexSubject.subscribe { tayScrollIndex in
            // taryCollectionView scroll
        }.disposed(by: self.disposeBag)
        
        // trayCollectionView  flowlayout
        trayCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
    
    @objc func didClickLeftBackButton(){
        print("debug : didClickLeftBackButton ")
        if let currentViewStatus = try? viewModel.groupSelectionStatus.value(), currentViewStatus == .preGroupSelected {
            viewModel.removeAllSelectedAssets()
            navigationController?.popViewController(animated: true)
        }else {
            viewModel.groupSelectionStatus.on(.next(.preGroupSelected))
        }
    }
    
    
    @objc func didClickRightSavekButton(){
        print("debug : didClickRightSavekButton ")
    }
    
    override func didTapTitleView() {
        viewModel.didTapNavigationTitleView()
    }
    
    @objc func didClickAssetCellCheckBtn(_ sender: Any){
        
        if let btnView = sender as? UIButton {
            if let cell = btnView.superview?.superview as? AssetCollectionViewCell {
                if cell.loadCompleteAsset {
                    let indexPath = btnView.indexPath!
                    self.viewModel.didTapAssetsCollectionViewlCell(cellindex: indexPath)
                }
            }
        }
    }
    
    func didClickAssetCollectionViewCell(cellIndex: IndexPath){
        guard let clickedCell = self.assetsCollectionView.cellForItem(at: cellIndex) as? AssetCollectionViewCell else {return}
        if clickedCell.loadCompleteAsset {
            self.viewModel.didTapAssetsCollectionViewlCell(cellindex: cellIndex)
        }
    }
}

//MARK: extension UICollectionViewDelegateFlowLayout
extension AssetsTrayViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var isHorizentalInfinitCollection = false
        
        var cellCntInRow: CGFloat = 2.0
        if collectionView == assetsCollectionView {
            cellCntInRow = 3.0
        }
        else if collectionView == trayCollectionView {
            cellCntInRow = 5.5
            isHorizentalInfinitCollection = true
        }
        
        var itemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        if true == isHorizentalInfinitCollection {
            //  가로 방향 collectionView 의 경우 itemSpacing 은 실제로 lineSpace 로 결정된다.( vertical 과 반대.. )
            itemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: indexPath.section)
        }
        let sectionInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let used = itemSpacing * ( ceil(cellCntInRow) - 1 ) + sectionInset.left + ( isHorizentalInfinitCollection == false ? sectionInset.right : 0 )
        
        let widthForRow = self.view.frame.size.width - used
        let cellWidth = widthForRow / cellCntInRow
        
        if collectionView == trayCollectionView {
            self.trayCollectionViewHeight.constant = cellWidth + sectionInset.top + sectionInset.bottom
        }
        
        var cellHeight = cellWidth
        if collectionView == groupsCollectionView {
            cellHeight = cellWidth + ( 20 * 2 + 1 )
        }
    
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var insetForSection = UIEdgeInsets.zero
        if collectionView == groupsCollectionView {
            insetForSection = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
        }
        else if collectionView == assetsCollectionView {
            insetForSection = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
        }
        else if collectionView == trayCollectionView {
            insetForSection = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        }
        return insetForSection
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        var lineSpacing: CGFloat = 0
        if collectionView == groupsCollectionView {
            lineSpacing = 16
        }
        else if collectionView == assetsCollectionView {
            lineSpacing = 3
        }
        else if collectionView == trayCollectionView {
            lineSpacing = 8
        }
        
        return lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var itemSpacing: CGFloat = 0
        if collectionView == groupsCollectionView {
            itemSpacing = 16
        }
        else if collectionView == assetsCollectionView {
            itemSpacing = 3
        }
        else if collectionView == trayCollectionView {
            itemSpacing = 8
        }
        
        return itemSpacing
    }
    
}
