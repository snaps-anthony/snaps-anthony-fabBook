//
//  PhotoBookTitleViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/23.
//

import UIKit

class PhotoBookTitleViewController: UIViewController {

    
    //MARK: UI
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    @IBOutlet weak var tfInputPhotoBookName: UITextField! {
        didSet {
            tfInputPhotoBookName.delegate = self
            print("debug : tfInputPhotoBookName.delegate = self 1")
        }
    }
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upDot: UIView!
    @IBOutlet weak var bottomDot: UIView!
    @IBOutlet weak var threedot: UIView!
    
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        print("debug : tfInputPhotoBookName.delegate = self 2")
    }
    
    
    @IBAction func nextClicked(_ sender: Any) {
        
    }
    
    @IBAction func textEdittingChange(_ sender: Any) {
        print("debyg : textEdittingChange -> \(tfInputPhotoBookName.text)")
    }
    
}

extension PhotoBookTitleViewController : UITextFieldDelegate {
    
}
