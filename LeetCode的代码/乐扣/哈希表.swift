//
//  哈希.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2024/2/21.
//  Copyright © 2024 蔡浩铭. All rights reserved.
//

import Foundation



class 哈希表: Do {
    static func doSomething() {
        
        let calendar = MyCalendar()
        let tmp = [[97,100],[33,51],[89,100],[83,100],[75,92],[76,95],[19,30],[53,63],[8,23],[18,37],[87,100],[83,100],[54,67],[35,48],[58,75],[70,89],[13,32],[44,63],[51,62],[2,15]]
        
//        [null,true,true,false,false,true,false,true,true,false,false,false,false,false,false,false,false,false,false,false,true]
        
//        [null,true,true,true,true,true,false,true,true,true,false,false,false,true,false,true,false,true,false,true,true]
//        [null,true,true,false,false,true,false,true,true,false,false,false,false,false,false,false,false,false,false,false,true]
        
//        [null,true,true,false,false,true,false,true,true,false,false,false,false,false,false,false,false,true,false,false,false]
//        let tmp = [[1,2],[2,3]]
        var result: [Bool] = []
        for t in tmp {
            result.append(calendar.book(t[0], t[1]))
        }
        print(result)
    }
    
    

    
    // MARK:
    class MyCalendar {

        var mark: [[Int]] = []

        init() {

        }
        
        func book(_ start: Int, _ end: Int) -> Bool {
            var canAdd = true
            for m in mark {
                if start < m[1] && end > m[0] {
                    canAdd = false
                }
            }
            if canAdd {
                mark.append([start,end])
            }
            return canAdd
        }
    }
    
    
}
