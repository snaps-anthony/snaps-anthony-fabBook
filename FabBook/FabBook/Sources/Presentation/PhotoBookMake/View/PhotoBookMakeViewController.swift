//
//  PhotoBookMakeViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/27.
//

import UIKit

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

    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("debug : PhotoBookMakeViewController view did load" )
    }
    
    
    //MARK: actions
    
    
    @IBAction func didClickedCancelBtn(_ sender: Any) {
        print("debug : didClickedCancelBtn")
    }
    

}
