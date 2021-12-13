//
//  SplashViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/08.
//

import UIKit
import Photos

class SplashViewController: BaseViewController {

    //MARK: UI
    var titleLabel : UILabel = {
        var lbl = UILabel()
        lbl.text = "FAB BOOK"
        lbl.font = .boldSystemFont(ofSize: 30)
        lbl.isHidden = false
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        PHPhotoLibrary.requestAuthorization { status in
            print("debug : PHPhotoLibrary requestAuthorization -> \(status)")
        }
        goDesingListViewController()
    }
    
    //MARK: methods
    private func configureUI(){
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }

    private func goDesingListViewController(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let controller = DesignListViewController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
    }

}
