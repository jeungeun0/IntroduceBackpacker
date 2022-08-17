//
//  StringExtension.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/16.
//

import Foundation


extension String {
    public var fullRange: NSRange {
        return NSRange(location: 0, length: self.count)
    }
    
    func isEmptyWithNoSpaces() -> Bool {
        var result = true
        
        guard self != "", self != " " else {
            return result
        }
        
        let arr = self.components(separatedBy: " ")
        
        for temp in arr {
            if temp.count > 0 {
                result = false
                return result
            }
        }
        
        return result
    }
}
