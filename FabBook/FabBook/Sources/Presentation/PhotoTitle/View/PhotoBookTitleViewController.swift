//
//  PhotoBookTitleViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/23.
//

import UIKit

class PhotoBookTitleViewController: UIViewController {

    //MARK: properties
    let MAX_LENGTH_TITLE = 25
    var _oldString = ""
    
    //MARK: UI
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var leftBackBarBtn: UIBarButtonItem!
    @IBOutlet weak var rightSaveBarBtn: UIBarButtonItem!
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
        }
    }
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upDot: UIView!
    @IBOutlet weak var bottomDot: UIView!
    @IBOutlet weak var threedot: UIView!
    
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("debug : viewDidAppear")
//        _tfInputPhotoBookName.text = _oldString = [ProductGenerator sharedGenerator].projectName;
//        [_tfInputPhotoBookName becomeFirstResponder];
        _oldString = ProductGenerator.shared.projectName
        tfInputPhotoBookName.text = _oldString
        
        
        print("debug : _oldString -> \(_oldString)")
        print("debug : ProductGenerator.shared.projectNme -> \(ProductGenerator.shared.projectName)")
    }
    
    //MARK: methods
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func setupNavigation() {
        //left
        leftBackBarBtn.target = self
        leftBackBarBtn.action = #selector(didClickLeftBarButton)
     
        //right
        rightSaveBarBtn.title = "다음"
        rightSaveBarBtn.tintColor = .black
        rightSaveBarBtn.target = self
        rightSaveBarBtn.action = #selector(didClickRightBarButton)
    }
    
    private func pushPhotoBookMakeViewController() {
        ProductGenerator.shared.projectName = tfInputPhotoBookName.text ?? ""
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        if storyBoard != nil {
//            let vc = storyBoard.instantiateViewController(withIdentifier: "PhotoBookMakeViewController")
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        let vc = PhotoBookMakeViewController.init(nibName: "RenewalRecommendMakingViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: actions
    @objc func didClickLeftBarButton() {
        print("debug : didClickLeftBarButton ")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didClickRightBarButton() {
        print("debug : didClickRightBarButton ")
        pushPhotoBookMakeViewController()
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        pushPhotoBookMakeViewController()
    }
    
    @IBAction func textEdittingChange(_ sender: Any) {
        print("debyg : textEdittingChange -> \(tfInputPhotoBookName.text)")
        
        if let text = tfInputPhotoBookName.text, text.count > MAX_LENGTH_TITLE {
            tfInputPhotoBookName.text = _oldString
        }
        else{
            _oldString = tfInputPhotoBookName.text ?? ""
        }
        
        print("debug : _oldString -> \(_oldString) ")
        
    }
}

extension PhotoBookTitleViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didClickRightBarButton()
        return true
    }
}
