//
//  PhotoBookMakeViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/27.
//

import UIKit
import CoreGraphics


class PhotoBookMakeViewController: BaseViewController {
    
    
    //MARK: UI
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    // title image
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleView: UIButton!
    @IBOutlet weak var lblTitleName: UILabel!
    //photo image
    @IBOutlet weak var photoImageView1: UIImageView!
    @IBOutlet weak var photoImageView2: UIImageView!
    @IBOutlet weak var photoView: UIView!
    
    
    
    //MARK: properties
    var viewModel = PhotoBookMakeViewModel()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up
        // 1. 변수 세팅
        viewModel.configureInstanceVariable()
        // 2. 네비바 세팅
        viewModel.configureNavigationBarButton()
        // 3. 타이틀 및 설명 세팅
        viewModel.configureTitleString()
        viewModel.configureDescriptionString()
        // 4. 썸네일 요청
        viewModel.startThumbnailUpload()
        
        // 5. 포토이미지뷰 및 애니메이션타이머 세팅
        viewModel._isAnimationEnd = true
        self.photoImageView1.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.photoImageView2.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        startAnimationTimer()
    }
    
    
    //MARK: methods
    func startAnimationTimer() {
        
    }
    
    //MARK: actions
    @IBAction func didClickedCancelBtn(_ sender: Any) {
        print("debug : didClickedCancelBtn")
    }
}
