//
//  DesignListViewModel.swift
//  FabBook
//
//  Created by anthony on 2021/12/08.
//

import UIKit
import RxSwift

class DesignListViewModel {
    
    //MARK: properties
    let designRepository = DefaultDesignListRepository()
    let designListSubject = BehaviorSubject(value: [Design]())
    
    //MARK: methods
    
    func fetchDesigList() {

        designRepository.fetchDesignList { [weak self] response in
            guard let designList = response  else {
                // no list
                return
            }
            print("debug : DesignListViewModel fetchDesigList ->", designList)
            self?.designListSubject.on(.next(designList))
        }
    }
}
