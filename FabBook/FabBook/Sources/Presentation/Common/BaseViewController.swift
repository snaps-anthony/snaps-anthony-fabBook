//
//  BaseViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/08.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    @IBOutlet weak var naviItem: UINavigationItem!
    
    //MARK: properties
    var disposeBag = DisposeBag()
    var naviTitleView : NavigationTitleView!
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    
    func setupTitleView(title: String = "", imageName: String?){
        naviTitleView = nil
        naviItem.titleView = nil
        naviTitleView = NavigationTitleView(frame: .zero)
        naviTitleView.setup(title: title, imageName: imageName)
        naviTitleView.titleButton.addTarget(self, action: #selector(didTapTitleView), for: .touchUpInside)
        naviItem.titleView = naviTitleView
    }

    @objc func didTapTitleView(){
        print("debug  : BaseViewController didTapTitleView")
    }

}
