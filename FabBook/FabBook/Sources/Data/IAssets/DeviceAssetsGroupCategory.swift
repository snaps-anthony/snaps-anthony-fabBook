//
//  DeviceAssetsGroupCategory.swift
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

import UIKit

class DeviceAssetsGroupCategory : IAssetsGroupCategoryInterface {
    
    var icon: UIImage! = UIImage(named: "pic_select_phone")
    
    var name: String = "휴대폰 사진"
    
    var title: String = "앨범목록"
    
    var assetsLibrary: IAssetsLibraryInterface = DeviceAssetsLibrary()
    
    
}
