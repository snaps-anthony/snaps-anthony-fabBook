//
//  ProjectCodeTask.swift
//  FabBook
//
//  Created by anthony on 2021/12/27.
//

import Foundation

enum TaskState : Int {
    case kTaskStateNone = 1        // none
    case kTaskStateStart = 2        // 시작
    case kTaskStateRunning = 3   // 업로드 중
    case kTaskStateEnd = 4          // 완료
}

enum TaskName : Int {
    case kProjectCode = 0                               // 프로젝트 코드 발급
    case kProjectCodeVerify = 1                     // 프로젝트 코드 유효성 체크(주문된 주문건을 재편집하는 경우가 있어서....)
    case kRepretationImageMake = 2            // 대표썸네일 생성
    case kRepretationImageUpload = 3         // 대표썸네일 업로드 (업로드 실패이면 그냥 넘어간다.)
//    case kThumbnailImageLoad = 4               // 썸네일이미지 로드
    case kThumbnailImageUpload = 5           // 썸네일 이미지 업로드
    case kOriginalImageUpload = 6               // 원본이미지 업로드 (썸네일만들기 실패이면 그냥 client가 만들어서 올린다. )
    case kXMLMake = 7                                   // xml 생성
    case kXMLUpload = 8                                  // xml 업로드
}

protocol ProjectCodeTaskDelegate {
    func startTask(taskName : TaskName)
    func runningTask(taskName : TaskName)
    func endTask(taskName : TaskName)
    func failTask(taskName : TaskName, error : NSError, networkError : NSError)
}

class ProjectCodeTask {
    
    //MARK: properties
    var delegate : ProjectCodeTaskDelegate?
//    var isMode : Bool
//    var isStartTask
    var taskState : TaskState
    var taskName : TaskName!
    
    // 유효성 검증, 프로젝트 발급을 이미한 경우에대한 처리..
    var _isProjectCode = false
    var _isVerifyProjectCode = false
    
    //MARK: init
    init(){
        taskState = .kTaskStateNone
    }
    
    //MARK: methods
    func performTask(isSaveCart : Bool) {
        // 인터넷 연결상태 확인
        
        // 실행중이면  cancel 한다.
        if self.taskState == .kTaskStateNone {
            if  1 > ProductGenerator.shared.projectCode.count {
                //프로잭트 코드 없으면 바로 프로젝트 코드 발급한다.
                self.taskName = .kProjectCode
                self.delegate?.startTask(taskName: self.taskName)
                ProductGenerator.shared.projectUploadType = ProjectUploadTypeInsert
                self.receivedProjectCode()
            }
            else { // 프로젝트 코드가 있으면 유효성 체크를 하고 task start
                self.taskName = .kProjectCodeVerify
                // TODO: 유효성 체크를 하고 task start 구현
//                if(_isVerifyProjectCode)
//                    return  [self.delegate endTask:[self name]];
//                [self startTask:[self name]];
//                [self checkUploadableProject];
            }
        }
    }
    
    func receivedProjectCode() {
        HttpManager.shared.restSendGetProjCode { [weak self] success, response in
            if success == false {
                print("debug : fail to get project code")
                ProductGenerator.shared.projectCode = ""
            }
            else { // success = true
                guard let prjCode = response?["projectCode"] as? String else {return}
                ProductGenerator.shared.projectCode = prjCode
                ProductGenerator.shared.executeAutosave()
                self?.projectCodeScussess()
            }
        }
    }
    
    func projectCodeScussess() {
        _isProjectCode = true
        _isVerifyProjectCode = true
        delegate?.endTask(taskName: self.taskName)
    }
}
