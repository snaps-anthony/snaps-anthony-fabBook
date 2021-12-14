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
    var fetchAssetReult = BehaviorSubject<[[String:Any]]>(value: [])
    
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
    
    func fetchAssets() {
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
                dic["checkCnt"] = 0
                dic["checkSelection"] = false
                // 기존 편집기 : PHFetchResult.getCheckArrayCount
                var checkSelectArr = [Bool]()
                for _ in 0..<assetIdx {
                    checkSelectArr.append(false)
                }
                dic["checkSelect"] = checkSelectArr
                // 딕셔너리 배열에 담는다
                dic["isEnable"] = getIsEnableResolution(asset: asset)
                // isEnable
                ret.append(dic)
            }
            
            //TODO: 사진 선택화면에서만 기존 선택 여부를 확인한다.
            fetchAssetReult.on(.next(ret))
        }
        
    }
    
    func getIsEnableResolution(asset : PHAsset) -> Bool {
        
        return true
    }
    
    func didTapGroupCollectionViewCell(cellInfo : [String:Any]) {
        let selectedGroup = cellInfo["selectedGroup"] as? PHAlbumData
        let selectedGroupIndex = (cellInfo["indexPath"] as! IndexPath).item
        
        if currentGroupIndex == selectedGroupIndex {
            // 현재 선택된 그룹과 똑같은 그룹 선택
            groupSelectionStatus.on(.next(.postGroupSelected))
            return
        }
        
        // group update
        currentGroup = selectedGroup
        currentGroupIndex = selectedGroupIndex
        
        //TODO: 기존 선택 여부 확인
        
        
        // assetsCollection updata
        fetchAssets()
        // groupSelection status update
        groupSelectionStatus.on(.next(.postGroupSelected))
    }
    
    func didTapAssetsCollectionViewlCell(cellInfo : [String:Any]) {
        print("debug : assetCollectionView clicked ->  cellInfo : \(cellInfo)")
    }
    
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
