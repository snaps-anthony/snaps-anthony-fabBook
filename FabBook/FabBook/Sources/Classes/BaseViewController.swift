//
//  BaseViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/08.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    //MARK: properties
    var disposeBag = DisposeBag()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    


}
