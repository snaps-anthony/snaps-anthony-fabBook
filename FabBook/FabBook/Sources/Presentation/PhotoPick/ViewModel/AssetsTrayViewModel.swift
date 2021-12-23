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
    let defaultPHImageManager = PHImageManager.default()
    
    // imageDataCheck
    var _lock = NSLock()
    var imageDataCheckObservable:Observable<Bool>?
    var imageDataCheckDisposeBag = DisposeBag()
    
    // AssetsTrayViewController
    var route = PublishSubject<[String:Any]>()
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
    var selectedAssetsSubject = BehaviorSubject<[PhotoListObject]>(value: [])
    var selectedAssetsCountSubject = BehaviorSubject<Int>(value: 0)      // 우측담기버튼에 선택된 사진 갯수 표시
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
                // PHAsset을 딕셔너리로 변환
                var dic = [String:Any]()
                let asset = result[assetIdx]
                dic["asset"] = asset
                dic["checkSelect"] = getIsSelectedAssetCell(asset:asset)
                // 딕셔너리 배열에 담는다
                dic["isEnable"] = getIsEnableResolutionCell(asset: asset)
                // isEnable
                ret.append(dic)
            }
            fetchAssetReultSubject.on(.next(ret))
        }
        
    }
    
    func getIsEnableResolutionCell(asset : IAssetInterface) -> Bool {
        
        return true
    }
    
    func getIsSelectedAssetCell(asset: IAssetInterface) -> Bool  {
        let currentSelecteddAssets = ProductGenerator.shared.selectedPhotoListObject
        var ret = false
        for selectedAsset in currentSelecteddAssets {
            if selectedAsset.photoId == asset.assetID {
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
    
    // asset 사진 선택 처리
    func didTapAssetsCollectionViewlCell(cellindex: IndexPath) {
        guard let fetchedAssets = try? fetchAssetReultSubject.value() else { return }
        let cellAsset = fetchedAssets[cellindex.item]["asset"] as! IAssetInterface
        let cellPhotoListObj = cellAsset.exportPhotoListObject()
        
        // 체크설정인지 체크 해제인지 판별
        let isSelectedCell = getIsSelectedAssetCell(asset:cellAsset)
        
        if isSelectedCell == false // 현재미체크 -> 체크 : 체크설정
        {
            // 사진담기 limit 검사 ->  policy.checkAddAssetPolicy()
//            let limit = (ProductGenerator.shared.policy as! FabBookPolicy).numberOfLimitAssets
            let limit = 300
            let currentSelectedAssetCnt = getSelectedPhotoListObjectArrCount()
            if currentSelectedAssetCnt >= limit {
                print("Debug : no select, 맥시멈까지 선택해서 더이상 사진 선택 못함")
                return
            }
            
            selectAssetEvent( cellindex: cellindex, cellAsset: cellPhotoListObj)
        }
        else // 현재체크 -> 체크취소 : 체크 해제
        {
            
            deselectAssetEvent(cellAsset: cellPhotoListObj)
        }
        //emit event
        // 선택된 사진리스트
        selectedAssetsSubject.on(.next(ProductGenerator.shared.selectedPhotoListObject))
        // 선택된 사진 갯수
        selectedAssetsCountSubject.on(.next(ProductGenerator.shared.selectedPhotoListObject.count))
        
    }
    
    // tray 사진 선택 처리
    func didTapTrayCollectionViewCell(cellindex : IndexPath) {
        let asset = ProductGenerator.shared.selectedPhotoListObject[cellindex.item]
        deselectAssetEvent( cellAsset: asset)
        // 선택된 사진리스트 이벤트 emit
        selectedAssetsSubject.on(.next( ProductGenerator.shared.selectedPhotoListObject))
        // 선택된 사진 갯수
        selectedAssetsCountSubject.on(.next(ProductGenerator.shared.selectedPhotoListObject.count))
    }
    
    func selectAssetEvent( cellindex: IndexPath, cellAsset :PhotoListObject) {
        
        let assetListType = ProductGenerator.shared.policy.assetListType
        if assetListType == .kAssetsListTypeSelect {
            ProductGenerator.shared.selectedPhotoListObject.append(cellAsset)
            selectUpdateAssetResult.on(.next((cellindex, true))) // 선택된 assetcell의 checked update
            
            //        let lastIndex = ProductGenerator.shared.selectedAssets.count - 1
            //        lastUpdatedTrayCollectionvCellIndexSubject.on(.next(lastIndex))
        }
        else if assetListType == .kAssetsListTypeAdd {
            
        }
        
    }
    
    func deselectAssetEvent(cellAsset : PhotoListObject)  {
        
        let assetListType = ProductGenerator.shared.policy.assetListType
        if assetListType == .kAssetsListTypeSelect {
            // 1. 선택된 asset을 ProductGenerator.shared.selectedAssets에서 제거
            var idxInselectedAssets = 0
            let currentSelecteddAssets = ProductGenerator.shared.selectedPhotoListObject
            for selectedIAsset in currentSelecteddAssets {
                if selectedIAsset.photoId == cellAsset.photoId {
                    break
                }
                idxInselectedAssets += 1
            }
            ProductGenerator.shared.selectedPhotoListObject.remove(at: idxInselectedAssets)
            
            // 2. 선택된 asset을 view에서 unchecked 처리
            var idxInFetchedAssets = 0
            guard let fetchedAssets = try? fetchAssetReultSubject.value() else { return }
            for fetchedAsset in fetchedAssets {
                let fetchedIAssetData = fetchedAsset["asset"] as! IAssetInterface
                if fetchedIAssetData.assetID == cellAsset.photoId {
                    break
                }
                idxInFetchedAssets += 1
            }
            
            if idxInFetchedAssets < fetchedAssets.count {
                // 현재 fetchedAsset에 존재하는경우
                selectUpdateAssetResult.on(.next((IndexPath(item: idxInFetchedAssets, section: 0), false))) // 선택된 cell의 unchecked update
            }
            
            //        // lastIndex
            //        if ProductGenerator.shared.selectedAssets.count == 0 {
            //            // no scroll move animation
            //            return
            //        }
            //        else {
            //            let lastIndex = idx > 0 ? idx-1 : 0
            ////            lastUpdatedTrayCollectionvCellIndexSubject.on(.next(lastIndex))
            //        }
        }
        else if assetListType == .kAssetsListTypeAdd {
            
        }
    }
    
    func removeAllSelectedAssets() {
        ProductGenerator.shared.selectedPhotoListObject.removeAll()
    }
    
    
    func getSelectedPhotoListObjectArr() -> [PhotoListObject]? {

        let assetListType = ProductGenerator.shared.policy.assetListType
        if assetListType == .kAssetsListTypeSelect   {
            let arr = ProductGenerator.shared.selectedPhotoListObject
            return arr
        }
        else if assetListType == .kAssetsListTypeAdd{
            let arr = ProductGenerator.shared.addedPhotoListObject
            return arr
        }
        return nil
    }
//
    func getSelectedPhotoListObjectArrCount() -> Int {
        
        let assetListType = ProductGenerator.shared.policy.assetListType
        if assetListType == .kAssetsListTypeSelect   {
            let count = ProductGenerator.shared.selectedPhotoListObject.count
            return count
        }
        else if assetListType == .kAssetsListTypeAdd{
            let count = ProductGenerator.shared.addedPhotoListObject.count
            return count
        }
        return 0
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
            // do nothing
        }
        else if currentViewStatus == .postGroupSelectedShowGroups {
            groupSelectionStatus.on(.next(.postGroupSelected))
        }else { // postGroupSelected
            groupSelectionStatus.on(.next(.postGroupSelectedShowGroups))
        }
        
    }
    
    func didClickNavigationLeftBarButton() {
        let assetListType = ProductGenerator.shared.policy.assetListType
        if assetListType == .kAssetsListTypeSelect {
            
            if let currentViewStatus = try? groupSelectionStatus.value(),
               currentViewStatus == .preGroupSelected {
                self.removeAllSelectedAssets()
                
                let routeType = "direct"
                let routeId = "popViewController"
                let animated = true
                
                route.on(.next(["routeType":routeType, "routeId":routeId, "animated":animated]))
            }
            else{
                groupSelectionStatus.on(.next(.preGroupSelected))
            }
        }
        else if assetListType == .kAssetsListTypeAdd{
            
        }
    }
    
    func  didClickNavigationRightBarButton() {
        let assetListType = ProductGenerator.shared.policy.assetListType
        if assetListType == .kAssetsListTypeSelect,
            false == ProductGenerator.shared.policy.checkConfirmPolicy() {
           // alert : _generator.policy.invalidateConformMessage()
            return
        }
        else if assetListType == .kAssetsListTypeAdd, 0 >= self.getSelectedPhotoListObjectArrCount() {
            // dismiss
            let DISMISS_ANIMATED = "DISMISS_ANIMATED"
            self.route.onNext(["routeType":"direct", "routeId":DISMISS_ANIMATED, "animated":true])
            return
        }
        else if assetListType == .kAssetsListTypeSelect || assetListType == .kAssetsListTypeAdd {
            // validation 모두 통과
            // 선택된 asset들의 데이터 체크
            
            selectedPhotoListObjectImageDataCheck()
                .subscribe(onNext:{ [weak self] successed in
                    
//                    if true == self?.bRecievedPhotoChangeDuringUploading {
//                        self?.bRecievedPhotoChangeDuringUploading = false
//                        self?.photoChanging.onNext(())
//                    }
                    
                    //  일단 작업이 끝났으므로 초기화 해준다.
                    //  하단 작업중 memory warnnig 받았을때 다시 한번 돌지 않기 위해.
                    self?.imageDataCheckObservable = nil
                    self?.imageDataCheckDisposeBag = DisposeBag()
                    
                    if true == successed {
                        self?.imageDataCheckAfterFlow()
                    }
                    else {
//                        let alert = SnapsAlertView.init(message: "일부 사진이 변경되어 선택 사진 목록이 바뀌었습니다.\n 다시 한번 확인해 주시기 바랍니다.",
//                                                     title: nil,
//                                                     buttonTitle: [SNLocalizedString("confirm", "확인")],
//                                                     tag: 0)
//                        alert?.show()
                    }
                }, onError: { [weak self] error in
                    
//                    self?.lottieAnimation.onNext(false)
//
//                    if true == self?.bRecievedPhotoChangeDuringUploading {
//                        self?.bRecievedPhotoChangeDuringUploading = false
//                        self?.photoChanging.onNext(())
//                    }
//
//                    var msg = SNLocalizedString( "auto_recommand_making_photobook_error_msg" , "예기치 못한 오류가 발생했습니다.\n다시 시도해 주세요")
//
//                    if 256 == (error as NSError).code {
//                        msg = SNLocalizedString( "iCloud_Disk_space_is_very_low" , "예기치 못한 오류가 발생했습니다. \niPhone 내 공간을 확보해 주신 후, 잠시후 다시 시작해 주세요.")
//                    }
//
//                    let alert = SnapsAlertView.init(message: msg,
//                                                 title: nil,
//                                                 buttonTitle: [SNLocalizedString("confirm", "확인")],
//                                                 tag: 0)
//                    alert?.show()
                })
                .disposed(by: imageDataCheckDisposeBag)
        }
    }
    
    // sync
//    func selectedPhotoListObjectImageDataCheck() -> (success : Bool, error : Error?) {
//
//        let assetListType = ProductGenerator.shared.policy.assetListType
//        let selectedPhotoListObjectCount = assetListType == .kAssetsListTypeSelect ?
//        ProductGenerator.shared.selectedPhotoListObject.count : ProductGenerator.shared.addedPhotoListObject.count
//
//        if selectedPhotoListObjectCount <= 0 {
//            let error = NSError.init(domain: "PhotoListObjectImageDataCheck", code: -999, userInfo: nil)
//            return (false, error)
//        }
//
//        var iCloudError : Error?
//
//        let selectedPhotoObjectArr = self.getSelectedPhotoListObjectArr()!
//
//        // PhotoListObjectArr에서 for-loop로 돌아가며 각각의 obj에서 phasset 정보를 가져오고
//        // phassetd에서 이미지 데이터를 가져와 체크한다
//
//        var completeCount = 0
//
//        print("debug : selectedPhotoListObjectCount -> \(selectedPhotoListObjectCount)")
//        let sDate = Date.init(timeIntervalSinceNow: 0)
//        for (idx, selectedPhotoObject) in selectedPhotoObjectArr.enumerated() {
//
//            guard let phasset = PHAsset.fetchAssets(withLocalIdentifiers: [selectedPhotoObject.photoId], options: nil).firstObject else {
//                let error = NSError.init(domain: "PhotoListObjectImageDataCheck", code: -999, userInfo: nil)
//                iCloudError = error
//                break
//            }
//
//            if selectedPhotoObject.checkImageData == true {
//                //
//            }
//            else {
//                // phasset으로부터 data를 로드
//                let options = PHImageRequestOptions()
//                options.deliveryMode = .highQualityFormat
//                options.isNetworkAccessAllowed = true
//                options.isSynchronous = true
//                options.version = .current
//                options.progressHandler = {
//                    (progress, error, stop, info) in
//                    print("prgress : \(progress * 100) %")
//                    if let err = error {
//                        iCloudError = err
//                    }
//                }
//
//                print("")
//                print("debug : requestImageDataAndOrientation [\(idx)] " )
//                defaultPHImageManager.requestImageDataAndOrientation(for: phasset, options: options) { [weak self] (imageData, dataUTI, orientation, info) in
//
//                    if nil != imageData {
//
//                        completeCount += 1
//                        print("Debug : request success \(completeCount )-> \(dataUTI)")
//                        self?.applyPhotoPrintImageDataInfo( targetImage:selectedPhotoObject, imagedata:imageData! as Data);
//
//
//                        if selectedPhotoListObjectCount == completeCount {
//                            print("Debug : request done, time -> \(Date.init(timeIntervalSinceNow: 0).timeIntervalSince(sDate)), isSynchronous -> \(options.isSynchronous)")
//                        }
//
//                    }
//                    else { // error
//                        print("Debug : request fail ")
//                        let error = NSError.init(domain: "PhotoListObjectImageDataCheck", code: -999, userInfo: nil)
//                        iCloudError = error
//                    }
//
//                }
//            }
//        } // end for loop
//        if selectedPhotoListObjectCount == completeCount {
//            return(true, nil)
//        }
//        return (false, iCloudError)
//    }
    
    // async
    func selectedPhotoListObjectImageDataCheck() -> Observable<Bool> {
        let assetListType = ProductGenerator.shared.policy.assetListType
        let selectedPhotoListObjectCount = assetListType == .kAssetsListTypeSelect ?
        ProductGenerator.shared.selectedPhotoListObject.count : ProductGenerator.shared.addedPhotoListObject.count

        if selectedPhotoListObjectCount <= 0 {
            return Observable.create{ emitter -> Disposable in
                let error = NSError.init(domain: "PhotoListObjectImageDataCheck", code: -999, userInfo: nil)
                emitter.onError(error)
                return Disposables.create()
            }
        }

        var selectedPhotoObjectArr = getSelectedPhotoListObjectArr()!
        let idList = selectedPhotoObjectArr.map{ $0.photoId }
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: idList, options: nil)
        var assetsList: [PHAsset] = []
        assetsList.reserveCapacity(selectedPhotoListObjectCount)
        fetchResult.enumerateObjects { asset, _, _ in
            assetsList.append(asset)
        }

        selectedPhotoObjectArr.sort{ $0.photoId > $1.photoId }
        assetsList.sort{ $0.assetID > $1.assetID }
        let sortedPhotoObjectObserver = Observable.from(selectedPhotoObjectArr)
        let sortedAssetListObserver = Observable.from(assetsList)
        var completeCount = 0
        var iCloudError : Error?
        
        
        imageDataCheckObservable = Observable.zip( sortedPhotoObjectObserver, sortedAssetListObserver)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap{ [weak self] photoListObject, asset in
                
                return Observable<Bool>.create{ emitter in
                    if photoListObject.photoId != asset.localIdentifier {
                        print("photo id : \(photoListObject.photoId), asset id : \(asset.localIdentifier)")
                    }
                    if true == photoListObject.checkImageData {
                        
//                        if photoListObject.gubun != MY_DEVICE_ALBUM_SELECTED {
//                            print("debug : selectedRightBarButtonItem 21 -> \(String(describing: self?._generator.photoPrintObject))")
//                            self?._generator.photoPrintObject.configurePhotoPrintDataSetting(photoListObject)
//                        }
                        
                        self?.performLocked {
                            completeCount += 1
                            print("[pass] index/total : \(completeCount)/\(selectedPhotoListObjectCount)")
                            if completeCount == selectedPhotoListObjectCount {
                                emitter.onNext(true)
                            }
                        }
                    }
                    else {
//                        print("debug : selectedRightBarButtonItem 22 -> \(String(describing: self?._generator.photoPrintObject))")
//                        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [photoListObject.photoId], options: nil)
//                        let resultAsset = PHAsset.album_fetch(withLocalIdentifier: photoListObject.photoId, options: nil)
                        let options = PHImageRequestOptions()
                        options.deliveryMode = .highQualityFormat
                        options.isNetworkAccessAllowed = true
                        options.isSynchronous = false
                        options.version = .current
                        options.progressHandler = {
                            (progress, error, stop, info) in
                            print("prgress : \(progress * 100) %")
                            if let error = error {
                                iCloudError = error
                            }
                        }
//                        if let asset = asset {
                            if #available(iOS 13, *) {
                                PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { (imageData, dataUTI, orientation, info) in
                                    
                                    if nil != imageData {
//                                        gzprintFunc("[\(completeCount)] data is not nil")
                                        self?.applyPhotoPrintImageDataInfo(targetImage:photoListObject, imagedata:imageData! as Data);
//                                        if true == SnapsProduct.photoPrintForSwift() { //사진인화 템플릿에 포토리스트오브젝트의 내용을 머지 시켜준다 진입직전에 해줌
//                                            print("debug : selectedRightBarButtonItem 4")
////                                            self?._generator.photoPrintObject.configurePhotoPrintDataSetting(photoListObject)
//                                        }
                                    }
                                    
                                    self?.performLocked {
                                        completeCount += 1
                                        print("current/total : \(completeCount)/\(selectedPhotoListObjectCount)")
//                                        let image = UIImage.init(data: imageData!, scale: UIScreen.main.scale)
//                                        if nil == image {
//                                            if nil == phAssetDataError {
//                                                phAssetDataError = NSError.init(domain: "PHAssetImageDataError", code: 99911, userInfo: nil)
//                                            }
//                                        }
                                        if completeCount == selectedPhotoListObjectCount {
                                            if let iCloudError = iCloudError {
                                                emitter.onError(iCloudError)
                                            }
                                            else {
                                                emitter.onNext(true)
                                            }
                                        }
                                    }
                                }
                            }
                            else { // iOS 12 이하
                                PHImageManager.default().requestImageData(for: asset, options: options) { (imageData, dataUTI, orientation, info) in
                                    
                                    if nil != imageData {
                                        self?.applyPhotoPrintImageDataInfo(targetImage:photoListObject, imagedata:imageData! as Data);
//                                        if true == SnapsProduct.photoPrintForSwift() { //사진인화 템플릿에 포토리스트오브젝트의 내용을 머지 시켜준다 진입직전에 해줌
//                                            self?._generator.photoPrintObject.configurePhotoPrintDataSetting(photoListObject)
//                                        }
                                    }
                                    
                                    self?.performLocked {
                                        completeCount += 1
                                        if completeCount == selectedPhotoListObjectCount {
                                            if let iCloudError = iCloudError {
                                                emitter.onError(iCloudError)
                                            }
                                            else {
                                                emitter.onNext(true)
                                            }
                                        }
                                    }
                                }
                            }
                    }
                    return Disposables.create()
                }
            }.observe(on: MainScheduler.instance) // end flat map
        return imageDataCheckObservable!
    }
    
    
    
    func applyPhotoPrintImageDataInfo(targetImage:PhotoListObject, imagedata:Data) {
        guard let dic = Utility.metaData(fromImageData: imagedata) else {return}
        var orientation = (Int)(truncating: dic["Orientation"] as? NSNumber ?? 0)
        orientation = Utility.removeMirroredStandardOrientation(orientation: orientation)
        let width = (CGFloat)(dic["PixelWidth"] as? CGFloat ?? 0 )
        let height = (CGFloat)(dic["PixelHeight"] as? CGFloat ?? 0 )
        var imageSize = CGSize(width: width, height: height)
        
        if 0 != orientation {
            let imageOrientation = Utility.imageOrientation(fromEXIFOrientation: orientation)
            let degree = Utility.getDegreeforOrientation(orientation: imageOrientation)
            targetImage.exifAngle = Float(degree)
        }
        else{
            targetImage.exifAngle = 0
        }
        imageSize = Utility.getImageOrientation(fromEXIFOrientation: orientation, imageSize: imageSize)
        targetImage.imgWidth = Float(imageSize.width)
        targetImage.imgHeight = Float(imageSize.height)
        targetImage.checkImageData = true
    }
    
    func performLocked<T>(_ action: () -> T) -> T {
        self._lock.lock(); defer { self._lock.unlock() }
        return action()
    }

    func imageDataCheckAfterFlow(){
        
        if ProductGenerator.shared.policy.assetListType == .kAssetsListTypeSelect {
            if false == showNetworkCheckPopup() {
                let SEGUE_ID_SHOW_INPUT_PHOTO_BOOK_TITLE = "SEGUE_ID_SHOW_INPUT_PHOTO_BOOK_TITLE"
                route.onNext([
                    "routeType":"segue",
                    "routeId":SEGUE_ID_SHOW_INPUT_PHOTO_BOOK_TITLE,
                    "animated":true
                ])
            }
        }
        
    }
    
    func showNetworkCheckPopup() -> Bool {
        // 네트워크 연결및 인터넷종류를 확인
        
        // 네트워크 미연결
        // show alert
        
        // 와이파이외 네트워크 연결
        // show alert
        
        // 와이파이 연결
        return false
    }
    
}
