//
//  贪心.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2024/2/7.
//  Copyright © 2024 蔡浩铭. All rights reserved.
//

import Foundation


class 贪心: Do {
    
    static func doSomething() {
        
        
        
        
        let test =  贪心()
        
    }
    
    
    // MARK: 55. 跳跃游戏
    
    /*
     有点像  图的可达性  递归  广度搜索
     
     每一次递归，用当前下标，加上当前下标值可能走的步数。 只要能大于，即可， 如果小于，即无法达到。
     
     // 方式有问题，最最后1,2,0,0,4，这种，0 的位置无法递归返回。
     
     这种想法问题出现在哪里？
     
     */
    
    /*
     贪心算法，每次去最优解。
     这题，即每部
     */
    func canJump(_ nums: [Int]) -> Bool {
        var max: Int = 0
        for idx in 0..<nums.count {
            if idx > max {
                continue
            }
            let canGo = idx + nums[idx]
            if canGo > max {
                max = canGo
            }
        }
        return max >= nums.count-1
    }
    
}
