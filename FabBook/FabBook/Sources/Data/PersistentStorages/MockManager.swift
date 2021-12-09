//
//  MockManager.swift
//  FabBook
//
//  Created by anthony on 2021/12/09.
//

import Foundation

class MockManager {
    
    
    static let shared = MockManager()
    
    private init() {}
    
    func getDesignList(completion: @escaping ([Design]?) -> Void) {
        
        guard let path = Bundle.main.path(forResource: "design", ofType: "json") else {
            completion(nil)
            return
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            completion(nil)
            return
        }
        let decoder = JSONDecoder()
        let jsonData = jsonString.data(using: .utf8)
        if let data = jsonData, let designList = try? decoder.decode([Design].self, from: data){
            completion(designList)
            return
        }
        completion(nil)
        return
    }
    
}
