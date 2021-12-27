//
//  ThumbnailUploadTask.swift
//  FabBook
//
//  Created by anthony on 2021/12/27.
//

import Foundation
import UIKit

protocol ThumbnailUploadTaskDelegate {
    func startTask(taskName : TaskName)
    func runningTask(taskName : TaskName)
    func endTask(taskName : TaskName)
    func failTask(taskName : TaskName, error : NSError, networkError : NSError)
}

protocol ThumbnailUploadProgressDelegate {
    // 이미지 load 실패
    // 이미지 load 완료
    func progressLoadComplete(source : Source)
    // 이미지 load 전체 완료
    func progressLoadAllComplete()
    // 이미지 upload 시작
    func progressUploadBegin(source : Source, imageName: String, orientation: UIImage.Orientation)
    // 이미지 upload 실패
    func progressUploadFail(source: Source)
    // 이미지 upload 완료
    func progressUploadComplete(source:Source)
    func progressUploadComplete(totalCount : Float, completeCount:Float)
    // 이미지 upload 전체 완료
    func progressUploadAllComplete(isSucess:Bool)
}


class ThumbnailUploadTask {
    
    //MARK: properties
    var _uploadOperationQueue : OperationQueue!
    var _loadOperationQueue : OperationQueue!
    let MAX_COUNT = 2
    let MAX_RETRY_COUNT = 3
    let READY_COUNT = 3
    
    var delegate : ThumbnailUploadTaskDelegate?
    var progressDelegate : ThumbnailUploadProgressDelegate?
    
    var taskName : TaskName!
    var taskState : TaskState!
    
    var _needUploadObjects : [Source]?  // 업로드 해야 하는 항목 저장
    var _failedSources : [Source]!
    var _isSaveCart  = false
    var _workCount = 0
    var _totalCount = 0
    
    //MARK: init
    init(){
        // _uploadOperationQueue setting
        _uploadOperationQueue = OperationQueue()
        _uploadOperationQueue.maxConcurrentOperationCount = MAX_COUNT
        
        // _loadOperationQueue setting
        _loadOperationQueue = OperationQueue()
        _loadOperationQueue.maxConcurrentOperationCount = 1
        
        taskName = .kThumbnailImageUpload
        taskState = .kTaskStateNone
        _failedSources = [Source]()
        
    }
    
    //MARK: methods
    
    
    
    
    func uploadData(sources: [Source]) {
        _needUploadObjects = sources
    }
    
    func performTask(isSaveCart:Bool){
        
        self._isSaveCart = isSaveCart
        //TODO: 사진권한체크
        
        //TODO: 프로젝트 코드가 없는 경우
        //TODO: 현재 task가 running 상태
        //TODO: 네트워크 연결 안된경우
        //TODO: useLTE == false
        
        _workCount = 0
        if let haveToUploadImages = _needUploadObjects == nil ? self.haveToUploadImages() : _needUploadObjects {
            if haveToUploadImages.count == 0 {
                delegate?.endTask(taskName: self.taskName)
            }
            else{
                _loadOperationQueue.cancelAllOperations()
                _uploadOperationQueue.cancelAllOperations()
                _totalCount = haveToUploadImages.count
                //TODO:  createLoadOperation -> 썸네일 업로드
                //
                // 썸네일 업로드 과정 없이 바로 완료 처리
                progressDelegate?.progressUploadAllComplete(isSucess: _failedSources.count == 0)
            }
        }
        
        
    }
    
    func haveToUploadImages() -> [Source] {
        //TODO: 업로드 해야 하는 이미지 가져오는 함수
        print("debug : ThumbnailUploadTask haveToUploadImages ")
        return [Source]()
    }
}
