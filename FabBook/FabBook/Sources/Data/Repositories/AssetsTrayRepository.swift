//
//  AssetsTrayRepository.swift
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

import Foundation
import RxSwift

final class AssetsTrayRepository : AssetsTrayRepositoryInterface {

    
//    
//    func fetchGroup() -> Observable<[Any]> {
//
//        return Observable.create { emitter in
//
//            ProductGenerator.shared.category.assetsLibrary.assetsGroup { groups, error in
//                if let err = error {
//                    emitter.onError(err)
//                    return
//                }
//                emitter.onNext( groups  )
//                emitter.onCompleted()
//
//            }
//            return Disposables.create()
//        }
//    }
//    
    
    func fetchGroup() -> Observable<[IAssetsGroupInterface]> {

        return Observable.create { emitter in

            ProductGenerator.shared.category.assetsLibrary.assetsGroup { groups, error in
                if let err = error {
                    emitter.onError(err)
                    return
                }
                emitter.onNext( groups! )
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    
    
}
