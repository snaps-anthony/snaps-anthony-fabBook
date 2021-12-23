//
//  PhotoBookTitleViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/23.
//

import UIKit


class PhotoBookTitleViewController: BaseViewController {

    //MARK: properties
    var viewModel = PhotoBookTitleViewModel()
    
    
    //MARK: UI
    @IBOutlet weak var _backgroundView: UIView!
    @IBOutlet weak var _iconImageView: UIImageView!
    @IBOutlet weak var _iconImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var _lblDescription: UILabel!
    
    @IBOutlet weak var _nextButton: UIButton!
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    

    
    
    
}


extension PhotoBookTitleViewController : UITextFieldDelegate {
    
}
