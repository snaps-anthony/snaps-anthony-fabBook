//
//  AssetsTrayViewModel.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation
import RxSwift
import Photos

enum ViewStatus  {
    case preGroupSelected
    case postGroupSelected
    case postGroupSelectedShowGroups
}

class AssetsTrayViewModel {
    
    //MARK: properties
    var disposeBag = DisposeBag()
    var assetsTrayRepository = AssetsTrayRepository()
    // current group
    var currentGroup : PHAlbumData? = nil
    var currentGroupIndex = -1
    // groupSubject
    var groupSelectionStatus = BehaviorSubject<ViewStatus>(value: .preGroupSelected)
    var fetchGroupsResult = BehaviorSubject<[IAssetsGroupInterface]>(value: [])
    // assetSubject
    var fetchAssetReultSubject = BehaviorSubject<[[String:Any]]>(value: [])
    var selectUpdateAssetResult = PublishSubject<(IndexPath, Bool)>() // asset select 여부와 위치
    // trayAssetSubject
    var selectedAssetsSubject = BehaviorSubject<[[String:Any]]>(value: [])
    var selectedAssetCountSubject = BehaviorSubject<Int>(value: 0)      // 우측담기버튼에 선택된 사진 갯수 표시
    var lastUpdatedTrayCollectionvCellIndexSubject = BehaviorSubject<Int>(value: 0)    // 마지막으로 체크or체크해제된 selectedAssets의 인덱스 -> trayCollectionView 애니메이션 효과와 bind
    
    //MARK: methods
    func fetchGroups() {
        assetsTrayRepository.fetchGroup()
            .subscribe { [unowned self] groupList in
                print("Debug : AssetsTrayViewModel onNext")
                self.fetchGroupsResult.on(.next(groupList))
                groupSelectionStatus.on(.next(.preGroupSelected))
            } onError: { err in
                print("Debug : AssetsTrayViewModel onError)")
            } onCompleted: {
                print("Debug : AssetsTrayViewModel onCompleted")
            }.disposed(by: self.disposeBag)

    }
    
    func fetchAssets(groupIndex : IndexPath) {
        var fetchResult : PHFetchResult<PHAsset>?
        var ret = [[String:Any]]()
        
        if let preFetched = currentGroup?.bPreFetched,
           preFetched == false,
           let assetCollection = currentGroup?.assetCollection
        {
            fetchResult = PHAsset.fetchAssets(in: assetCollection, options: PHFetchOptions.imagesOptions())
        }
        else
        {
            fetchResult = currentGroup?.fetchResult
        }
        
        
        if let result = fetchResult {
            
            // PHAssetFetchResult<PHAsset>를 딕셔너리 배열로 변환
            for assetIdx in 0..<result.count {
                print("debug : assetIdx -> \(assetIdx)")
                // PHAsset을 딕셔너리로 변환
                var dic = [String:Any]()
                let asset = result[assetIdx]
                dic["asset"] = asset
                dic["checkSelect"] = getIsSelectedAssetCell(asset:asset)
                // 딕셔너리 배열에 담는다
                dic["isEnable"] = getIsEnableResolution(asset: asset)
                // isEnable
                ret.append(dic)
            }
            fetchAssetReultSubject.on(.next(ret))
        }
        
    }
    
    func getIsEnableResolution(asset : PHAsset) -> Bool {
        
        return true
    }
    func getIsSelectedAssetCell(asset: PHAsset) -> Bool  {
        let currentSelecteddAssets = ProductGenerator.shared.selectedAssets
        var ret = false

        for selectedAssetDic in currentSelecteddAssets {
            let selectedAsset = selectedAssetDic["asset"] as! PHAsset
            if selectedAsset.localIdentifier == asset.localIdentifier {
                ret = true
                break
            }
        }
        return ret
    }
    
    func didTapGroupCollectionViewCell(cellInfo : [String:Any]) {
        let selectedGroup = cellInfo["selectedGroup"] as? PHAlbumData
        let selectedGroupIndex = cellInfo["indexPath"] as! IndexPath
        if currentGroupIndex == selectedGroupIndex.item {
            // 현재 선택된 그룹과 똑같은 그룹 선택
            groupSelectionStatus.on(.next(.postGroupSelected))
            return
        }
        // group update
        currentGroup = selectedGroup
        currentGroupIndex = selectedGroupIndex.item
        // assetsCollection updata
        fetchAssets(groupIndex: selectedGroupIndex)
        // groupSelection status update
        groupSelectionStatus.on(.next(.postGroupSelected))
    }
    
    // 사진 선택 처리
    func didTapAssetsCollectionViewlCell(cellindex: IndexPath, cellAsset : PHAsset) {
        print("debug : assetCollectionView clicked -> cellindex:\(cellindex)")
    
        
        // 체크설정인지 체크 해제인지 판별
        let isSelectedCell = getIsSelectedAssetCell(asset:cellAsset)

        if isSelectedCell == false // 현재미체크 -> 체크 : 체크설정
        {
            // 사진담기 limit 검사
            let limit = (ProductGenerator.shared.policy as! FabBookPolicy).limitPhotos
            let currentSelectedAssetCnt = getSelectedAssetSaveArrCount()
            
            if currentSelectedAssetCnt >= limit {
                // 맥시멈까지 선택해서 더이상 사진 선택 못함
                print("Debug : no select, 맥시멈까지 선택해서 더이상 사진 선택 못함")
                return
            }
            
            selectAssetEvent( cellindex: cellindex, cellAsset: cellAsset)
        }
        else // 현재체크 -> 체크취소 : 체크 해제
        {
            deselectAssetEvent(cellindex: cellindex, cellAsset: cellAsset)
        }
        
        //emit event
        selectedAssetsSubject.on(.next( ProductGenerator.shared.selectedAssets))
        selectedAssetCountSubject.on(.next(ProductGenerator.shared.selectedAssets.count))
        
    }
    
    func selectAssetEvent( cellindex: IndexPath, cellAsset :PHAsset) {
        //TODO: _generator.policy.assetsListType() 에 따른 로직 분기처리
        
        let copyAsset = cellAsset
        let copyIsEnable = getIsEnableResolution(asset: cellAsset)
        var newCellInfo = [String:Any]()
        
        newCellInfo["asset"] = copyAsset
        newCellInfo["checkSelect"] = true
        newCellInfo["isEnable"] = copyIsEnable
        
        ProductGenerator.shared.selectedAssets.append(newCellInfo)
        
        selectUpdateAssetResult.on(.next((cellindex, true)))
//        print("debug : ProductGenerator.shared.selectedAssets insert")
//        dump(ProductGenerator.shared.selectedAssets)
//        print("")
        
        let lastIndex = ProductGenerator.shared.selectedAssets.count - 1
        lastUpdatedTrayCollectionvCellIndexSubject.on(.next(lastIndex))
    }
    
    func deselectAssetEvent(cellindex: IndexPath, cellAsset : PHAsset)  {
        //TODO: _generator.policy.assetsListType() 에 따른 로직 분기처리
        var idx = 0
        let currentSelecteddAssets = ProductGenerator.shared.selectedAssets

        for selectedAssetDic in currentSelecteddAssets {
            let selectedAsset = selectedAssetDic["asset"] as! PHAsset
            if selectedAsset.localIdentifier == cellAsset.localIdentifier {
                break
            }
            idx += 1
        }
        ProductGenerator.shared.selectedAssets.remove(at: idx)
        selectUpdateAssetResult.on(.next((cellindex, false)))
        print("debug : ProductGenerator.shared.selectedAssets removw")
        dump(ProductGenerator.shared.selectedAssets)
        print("")
        
        // lastIndex
        if ProductGenerator.shared.selectedAssets.count == 0 {
            // no scroll move animation
            return
        }
        else {
            let lastIndex = idx > 0 ? idx-1 : 0
            lastUpdatedTrayCollectionvCellIndexSubject.on(.next(lastIndex))
        }
        
    }
    
    
//    func getSelectedAssetSaveArr() -> [PhotoListObject]? {
//
//    }
//
    func getSelectedAssetSaveArrCount() -> Int {
        let count = ProductGenerator.shared.selectedAssets.count
        return count
    }
//
//    func addAssetToSelectedAssets(_ asset: PhotoListObject) {
//
//    }
//
//    func removeAssetInSelectedAssets(_ asset: IAsset) -> Int {
//
//    }
//
//    func removeAssetInSelectedAssets(indexPath: IndexPath) {
//
//    }
//
//    func setSelectedAssetSaveArr(_ photoListArr: [PhotoListObject]?) {
//
//    }
    
    
    func didTapNavigationTitleView(){
        print("debug :  didTapNavigationTitleView ")
        let currentViewStatus = try! groupSelectionStatus.value()
        
        if currentViewStatus == .preGroupSelected {
            //
        }
        else if currentViewStatus == .postGroupSelectedShowGroups {
            groupSelectionStatus.on(.next(.postGroupSelected))
        }else { // postGroupSelected
            groupSelectionStatus.on(.next(.postGroupSelectedShowGroups))
        }
        
    }
}
