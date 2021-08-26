//
//  数组.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2021/8/25.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

import Foundation

class 数组: Do {
    static func doSomething() {
        
        let test = 数组()
        
//        print(test.threeSum([0,0,0,0]))
        
        print(test.jump( [2,3,1,1,4]))
    }
    
    //MARK: 1. 两数之和
    /*
     给定一个整数数组 nums 和一个整数目标值 target，请你在该数组中找出 和为目标值 target  的那 两个 整数，并返回它们的数组下标。
     */
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dict:[Int:Int] = [:]
        for index in 0..<nums.count {
            let n = nums[index]
            if let pre = dict[target-n] {
                return [pre,index]
            }else {
                dict[n] = index
            }
        }
        return []
    }
    
    //MARK: 45. 跳跃游戏 II
    /*
     给你一个非负整数数组 nums ，你最初位于数组的第一个位置。

     数组中的每个元素代表你在该位置可以跳跃的最大长度。

     你的目标是使用最少的跳跃次数到达数组的最后一个位置。

     假设你总是可以到达数组的最后一个位置。
     
     */
    
    /*
     思路：  从最后一个下标开始，从题干的意思，从前往后找，找到最接近的一个数字达到最后的下标，然后从那个位置继续
     从头开始找最接近的一个数字达到当下位置。
     */
    
    func jump(_ nums: [Int]) -> Int {
        var position = nums.count - 1
        var steps = 0
        while position > 0 {
            for i in 0..<position {
                if i + nums[i] >= position {
                    position = i
                    steps += 1
                    break
                }
            }
        }
        return steps
    }
    
    
    //MARK: 136. 只出现一次的数字
    /*
     给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。

     说明：

     你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？
     */
     
    func singleNumber(_ nums: [Int]) -> Int {
        var dict:[Int:Int] = [:]
        for n in nums {
            if dict[n] == nil {
                dict[n] = 1
            }else {
                dict[n] = 0
            }
        }
        for (key,value) in dict {
            if value == 1 {
                return key
            }
        }
        return -1
    }
    
    //MARK: 169. 多数元素
    /*
     给定一个大小为 n 的数组，找到其中的多数元素。多数元素是指在数组中出现次数 大于 ⌊ n/2 ⌋ 的元素。

     你可以假设数组是非空的，并且给定的数组总是存在多数元素。
     */
    func majorityElement(_ nums: [Int]) -> Int {
        var dict:[Int:Int] = [:]
        for n in nums {
            if let v = dict[n] {
                dict[n] = v + 1
                if v+1 > nums.count/2 {
                    return n
                }
            }else {
                dict[n] = 1
                if nums.count == 1 {
                    return n
                }
            }
        }
        return -1
    }
    
    //MARK: 15. 三数之和
    /*
     给你一个包含 n 个整数的数组 nums，判断 nums 中是否存在三个元素 a，b，c ，使得 a + b + c = 0 ？请你找出所有和为 0 且不重复的三元组。

     注意：答案中不可以包含重复的三元组。
     */
    
    /*
     我的解法：
     使用了i,j,k三重循环，毫无意外，超时。而且少了很多提前折枝的操作.
     (1)因为是三数字和等于0，因此排序之后如果第一个数大于0就不需要了
     (2)j,k这个循环，其实可以同时进行j++,k--,因为不允许数字重复使用
     (3)不允许重复的话，就得while循环到下一个不是当前数字的下标上
     */
    func threeSum(_ nums: [Int]) -> [[Int]] {
        let temp = nums.sorted()
        var result: [[Int]] = []
        let count = temp.count
//        var dict: [Int:Int] = [:]
        for i in 0..<count {
            if temp[i] > 0 {
                return result
            }
            if i > 0 && temp[i-1] == temp[i] {
                continue
            }
            var l = i+1
            var r = count-1
            
            while l < r {
                let t = temp[i] + temp[l] + temp[r]
                if t == 0 {
                    result.append([temp[i] , temp[l] , temp[r]])
                    
                    while l < r && temp[l] == temp[l+1] {
                        l += 1
                    }
                    while l < r && temp[r] == temp[r-1] {
                        r -= 1
                    }
                    l += 1
                    r -= 1
                } else if t > 0 {
                    r -= 1
                } else {
                    l += 1
                }
            }

            
        }
        return result
    }
}
