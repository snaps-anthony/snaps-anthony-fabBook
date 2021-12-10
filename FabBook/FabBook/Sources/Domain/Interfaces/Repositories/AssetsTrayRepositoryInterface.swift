//
//  AssetsTrayRepositoryInterface.swift
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

import Foundation
import RxSwift

protocol AssetsTrayRepositoryInterface {
    
    func fetchGroup() -> Observable<[IAssetsGroup]>
}
