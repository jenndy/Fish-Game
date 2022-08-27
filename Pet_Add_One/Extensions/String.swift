//
//  String.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 12/2/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//

import Foundation

extension String {
    static func randomNum(length: Int) -> String {
        var res = ""
        for _ in 0..<length {
            let digit = Int.random(in: 0...9)
            res += "\(digit)"
        }
        return res
    }
    
    func intConvert(at n: Int) -> Int {
        let index = self.index(self.startIndex, offsetBy: n)
        return self[index].wholeNumberValue ?? 0
    }
}
