//
//  PhotoBookMakeViewModel.swift
//  FabBook
//
//  Created by anthony on 2021/12/27.
//

import UIKit
import CoreGraphics

class PhotoBookMakeViewModel {
    
    
    //MARK: properties
    //    var _isEnableMuteCheckTimer = false   // 소리,진동여부
    //    var _isMuteState = false              // 소리,진동여부
    
    // 애니메이션
    var _isAnimationEnd = false
    
    // 썸네일 업로드
    var _sources : [Source]? = nil
    var _projectTask : ProjectCodeTask? = nil
    var _thumbUploadTask : ThumbnailUploadTask? = nil
    var _projectCodeProgress : Float = 0.0
    
    //MARK: methods
    func configureInstanceVariable() {
        _projectCodeProgress = 0.0
    }
    
    func configureNavigationBarButton() {
        
    }
    
    func configureTitleString() {
        
    }
    
    func configureDescriptionString(){
        
    }
    
    func configureAnimation(){
        
    }
    
    func startThumbnailUpload() {
        // 썸네일 업로드
        // 1. 선택이 된 사진을 PhotoListObject => Source로 변경 (업로드 모듈을 Source로 돌아간다.)
        if _sources == nil {
            _sources = convertPhotoListObjectToSource()
        }
        // 2. 프로젝트 코드를 발급 받는다. ProductGenerator에 projectCode 저장. -> endTask
        // -> 3. 썸네일 업로드를 진행한다. : requestThumbnailUpload
        requestProjectCode() // 프로젝트 코드를 발급 받는다.
    }
    
    func convertPhotoListObjectToSource() -> [Source]{
        var ret = [Source]()
        
        let photoListObjArr = ProductGenerator.shared.selectedPhotoListObject
        
        for photoObject in photoListObjArr {
            let source = Source()
            source.uploadType = SourceUploadTypeFile
            source.originalURL = photoObject.photoId
            source.thumbnailURL = photoObject.photoId
            source.orgFileName = photoObject.orgFileName
            source.width = String(Int(photoObject.imgWidth))
            source.height = String(Int(photoObject.imgHeight))
            if let createDate = photoObject.created_at {
                source.createDate = createDate.toString(format: "yyyy-MM-dd HH:mm:ss")
            }
            ret.append(source)
        }
        
        //  커버사진 체크
        ret.first?.coverType = "cover"
        
        return ret
    }
    
    
    func requestProjectCode() {
        if _projectTask == nil {
            _projectTask = ProjectCodeTask()
        }
        _projectTask?.delegate = self // extension ProjectCodeTaskDelegate
        _projectTask?.performTask(isSaveCart: false)
    }
    
    func requestThumbnailUpload() {
        // 썸네일 업로드를 진행한다.
        _thumbUploadTask = ThumbnailUploadTask()
        if let sources = self._sources {
            _thumbUploadTask?.uploadData(sources: sources)
            _thumbUploadTask?.progressDelegate = self // extension ThumbnailUploadProgressDelegate
            _thumbUploadTask?.performTask(isSaveCart: false)
        }
    }
}

//MARK: ProjectCodeTaskDelegate
extension PhotoBookMakeViewModel : ProjectCodeTaskDelegate {
    func startTask(taskName: TaskName) {
        switch taskName {
        case .kProjectCode:
            break;
        case .kThumbnailImageUpload:
            break;
        default:
            break;
        }
    }
    
    func endTask(taskName: TaskName) {
        switch taskName {
        case .kProjectCode, .kProjectCodeVerify:
            _projectCodeProgress = 1.0
            self.requestThumbnailUpload()
            break;
        case .kThumbnailImageUpload:
            break;
        default:
            break;
        }
    }
    
    func runningTask(taskName: TaskName) {
        //
    }
    
    
    
    func failTask(taskName: TaskName, error: NSError, networkError: NSError) {
        //
    }
    
    
}

//MARK: ThumbnailUploadProgressDelegate
extension PhotoBookMakeViewModel : ThumbnailUploadProgressDelegate {
    
}

