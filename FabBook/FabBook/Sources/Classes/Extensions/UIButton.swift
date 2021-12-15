//
//  UIButton.swift
//  FabBook
//
//  Created by anthony on 2021/12/15.
//

import UIKit

extension UIButton {
    private struct AssociatedKeys {
        static var indexPath: IndexPath? // 1
        
    }
    var indexPath: IndexPath? {
        get { // 2
            return (objc_getAssociatedObject(self, &AssociatedKeys.indexPath) as? IndexPath)
        }
        set(newValue) { // 3
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.indexPath,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
