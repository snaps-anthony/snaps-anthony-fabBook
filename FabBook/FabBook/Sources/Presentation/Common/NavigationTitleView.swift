//
//  NavigationTitleView.swift
//  FabBook
//
//  Created by anthony on 2021/12/10.
//s

import UIKit

class NavigationTitleView: UIView {
    let titleButton = UIButton()
    private var allConstraintsDidSetup = false
    
    init(title: String, imageName:String, action:Selector) {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup( title: String, imageName:String?) {
        titleButton.setTitle(title, for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.titleLabel?.lineBreakMode = .byTruncatingTail
        titleButton.backgroundColor = .lightGray
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleButton)

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: titleButton.topAnchor),
            self.bottomAnchor.constraint(equalTo: titleButton.bottomAnchor),
            self.leftAnchor.constraint(equalTo: titleButton.leftAnchor),
            self.rightAnchor.constraint(equalTo: titleButton.rightAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard allConstraintsDidSetup else {
            NSLayoutConstraint.activate([
                titleButton.widthAnchor.constraint(equalTo: self.window!.widthAnchor, constant: -120 * 2)
            ])
            allConstraintsDidSetup = true
            return
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
