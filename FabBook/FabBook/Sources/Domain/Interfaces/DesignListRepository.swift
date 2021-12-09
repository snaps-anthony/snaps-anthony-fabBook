//
//  DesignListRepository.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation

protocol DesignListRepository {
    
    func fetchDesignList(completion: @escaping([Design]?) -> Void)
}
