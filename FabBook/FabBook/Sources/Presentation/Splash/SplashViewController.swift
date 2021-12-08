//
//  SplashViewController.swift
//  FabBook
//
//  Created by anthony on 2021/12/08.
//

import UIKit

class SplashViewController: BaseViewController {

    //MARK: UI
    var titleLabel : UILabel = {
        var lbl = UILabel()
        lbl.text = "FAB BOOK"
        lbl.font = .boldSystemFont(ofSize: 30)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        goDesingListViewController()
    }
    
    //MARK: methods
    private func setup(){
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func goDesingListViewController(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let controller = DesignListViewController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
    }

}
