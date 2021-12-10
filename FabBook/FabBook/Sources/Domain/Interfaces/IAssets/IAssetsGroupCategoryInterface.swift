//
//  IAssetsGroupCategoryInterface.swift
//  FabBook
//
//  Created by anthony on 2021/12/10.
//


import UIKit

protocol IAssetsGroupCategoryInterface {
    
    var icon : UIImage! { get set }
    var name : String { get set }
    var title : String { get set }
    var assetsLibrary : IAssetsLibraryInterface { get set }
    
    
    
}
