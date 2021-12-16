//
//  Date.swift
//  FabBook
//
//  Created by anthony on 2021/12/16.
//

import Foundation

extension Date {
    
    func toString(format : String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateStr = formatter.string(from: self)
        
        return dateStr
    }
}
