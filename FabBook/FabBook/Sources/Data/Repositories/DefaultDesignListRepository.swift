//
//  DefaultDesignListRepository.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation

final class DefaultDesignListRepository : DesignListRepository {
    
    func fetchDesignList(completion: @escaping ([Design]?) -> Void) {
//        HttpManager.shared.getDesignList { designList in
//            completion(designList)
//        }
        MockManager.shared.getDesignList { designList in
            completion(designList)
        }
    }
}
