//
//  IAssetsLibraryInterface.swift
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

import Foundation


protocol IAssetsLibraryInterface {
    func assetsGroup(_ block: @escaping ([Any], Error) -> Void)
    
    func assetsGroup(withParam param: [String], block: @escaping ([Any], Error) -> Void)
}
