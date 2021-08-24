//
//  动态规划.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2021/8/24.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

import Foundation

class 动态规划: Do {
    
    /*
     动态规划： 核心思想是将一个大问题，分解为可以重叠的子问题，还有最优子结构性质的问题。动态规划通常能分解成很多相似的子问题，然后只需要记下每次计算的子结果，然后再后续计算中，只要重复出现的子结果都能直接查表获取，提高计算效率。
     
     解题步骤：
     1.确定状态
     2.根据状态列转移方程，确定该状态上可以执行的操作，然后是该状态和前一个状态或者前多个状态的关联，通常该状态下可执行的操作必定关联我们之前的几个状态
     */
    
    static func doSomething() {
        
//        print(minimumTotal([[2],[3,4],[6,5,7],[4,1,8,3]]))
        
//        print(backPack(packTotal: 15, itemsQuality: [1,7,7,10]))
        
//        print(canPartition([23,13,11,7,6,5,5]))
//        print(canPartition1([9,5]))
        print(canPartition2([1,2,5]))
        
    }
    
    
    //MARK: 数字三角形
    
    /*
     问题描述
     给定一个数字三角形，找到从顶部到底部的最小路径和。每一步可以移动到下面一行的相邻数字上。
     每一步只能移动到下一行中相邻的结点上。相邻的结点 在这里指的是 下标 与 上一层结点下标 相同或者等于 上一层结点下标 + 1 的两个结点。也就是说，如果正位于当前行的下标 i ，那么下一步可以移动到下一行的下标 i 或 i + 1 。

     [2],
     [3,4],
     [6,5,7],
     [4,1,8,3]

     从顶到底部的最小路径和为11 ( 2 + 3 + 5 + 1 = 11)。
     */
    
    /*
     思路：
     （1）由于有个要点，就是每一步只能移动到下一行，或者下一行的下一个，因此，当前所在T[i][j]的最小值，是由上一行，
     或者上一行的前一个最小值决定，因此可以将问题拆分成T[i][j] + min(T[i-1][j],T[i-1][j-1])
     */
    
    static func minimumTotal(_ triangle: [[Int]]) -> Int {
        if triangle.isEmpty {
            return 0
        }
        let row = triangle.count
        var status:[[Int]] = .init(repeating: .init(repeating: 0, count: row), count: row)
        
        status[0][0] = triangle[0][0]
        for i in 1..<row {
            for j in 0...i {
                
                var uppon = Int.max
                // 要判断上一行元素是否存在，然后取出到上一行元素的最小值
                // 或者判断上一行左移元素是否存在，然后取出到上一行左移元素的最小值
                if j != i {
                    uppon = status[i-1][j]
                }
                if j-1 >= 0 {
                    uppon = min(uppon, status[i-1][j-1])
                }

                status[i][j] = uppon + triangle[i][j]
            }
        }
        
        var result = Int.max
        for k in 0..<row {
            result = min(result, status[row-1][k])
        }
        return result
    }
    
    //MARK: 背包问题
    
     /*
     背包问题1 --- 01背包问题，要么放要么不放
     问题描述
     在n个物品中挑选若干物品装入背包，最多能装多满？假设背包的大小为m，每个物品的大小为A[i]
     */
    
    /*
     思路：  要找出固定背包大小能放最多的物品，其实就是分解成从若当前背包仍有空间，剩余空间能放多大物品。
     (1)首先需要对物品列表按小到大重量排序，为了方便后面寻找可用空间能放入哪个物品装的更多
     (2)状态转换有两种情况：
        a. 剩余空间能放的下当前的物品，所以status[c][q] = current + status[c-1][q]
        b. 剩余空间不足放下物品status[c][q] = status[c-1][q]
     */
    
    /*
     测试用例：
     （1）total = 0  (2)items = [] (3) total = 15,[1,2,3,4,5,6]
     (4) total = 15,[1,1,2,3,4,4,5]  (4) total = 15, [4,5,8,13]
     */
    static func backPack(packTotal: Int,itemsQuality:[Int]) -> Int {
        if packTotal <= 0 || itemsQuality.isEmpty {
            return 0
        }
        let count = itemsQuality.count
        // 先按质量排序
        let sortQuality = itemsQuality.sorted(by: { $0 < $1 })
        // 构建空白记录   质量为X轴， 个数为Y轴， 质量需要从1开始才有效，第一列都会为0，第一行也会为0
        var status: [[Int]] = .init(repeating: .init(repeating: 0, count: packTotal+1), count: count+1)
        
        for c in 1...count {
            for q in 1...packTotal {
                let current = sortQuality[c-1]
                
                if current > q {
                    // 当前物品大于可用，因此最大还是保留前一个个数最多时的质量
                    status[c][q] = status[c-1][q]
                } else {
                    /*
                     WARN: 注意这里需要考虑
                     只想到如果空间能放下后，即用前q-current的空间加上current的质量，
                     status[c][q] = status[c-1][q-current] + current
                     但是没考虑到：
                     ~~~~~~~~~~~~~~~~~~~~~~~~
                     例如总空间只有15， [1,7,7,10]，即当最大元素空间占用之后，能放下的内容不够最大空间物品之前之和的大。
                     所以除了判断这个物品能不能放下，还要判断这个物品放下之后有没有贡献
                     ~~~~~~~~~~~~~~~~~~~~~~~~
                     */
                    status[c][q] = max(status[c-1][q-current] + current, status[c-1][q])
                }
            }
        }
        var maxV = Int.min
        for i in 0...packTotal {
            maxV = max(maxV, status[count][i])
        }
        
        
        return maxV
        
    }
    
    
    /*
     背包问题2
     问题描述
     给出n个物品的体积A[i]和其价值V[i]，将他们装入一个大小为m的背包，最多能装入的总价值有多大？
     */

    
    
    //MARK: 416.选择子集和等于所有元素值和的一半
    
    /*
     给你一个 只包含正整数 的 非空 数组 nums 。请你判断是否可以将这个数组分割成两个子集，使得两个子集的元素和相等。
     */
    
    /*
     思路： 跟01背包类似，只需要将背包容量设置为所有元素值和的一半，然后跑一遍01背包算法即可
     */
    
    /*
     优化：  即将状态数组记录成，status[i][j]，使用i个数值的时候，是否存在一个值等于j，最终返回status[i][target]即可，target为数组和的一半。
     WARN:
     ~~~~~~~~~~~~~~~~~~~~~~~~
     且需要注意的是第二层的循环我们需要从大到小计算，因为如果从小到大，即
     ~~~~~~~~~~~~~~~~~~~~~~~~
     
     优化2：  背包问题都是使用二位数组保存状态，并且由于每次需要的结果，其实只是需要上一次结果中对应的上一行，以及上一行的左侧数据，
     因此完全可以二维数组缩减为一维数组。
     WARN:
     ~~~~~~~~~~~~~~~~~~~~~~~~
     注意是，因为我们使用的状态会取自上一行及上一行左侧的数据，如果我们复写这一行数据的时候，从左到右，则会把数据抹掉，造成不对。
     这里只要把数据怎么填写的过程过一遍，就知道为什么需要从后往前。因为我们用到的数据是从上一行及左侧拿的，如果我们从这行的左侧开始复写，
     等于一边复写上一行的数据，一边用上一行的数据
     ~~~~~~~~~~~~~~~~~~~~~~~~

     */
    
    /*
     被忽略的细节：
     
     解释设置 dp[0][0] = true 的合理性（重点）
     修改状态数组初始化的定义：dp[0][0] = true。考虑容量为 00 的时候，即 dp[i][0]。按照本意来说，应该设置为 false ，但是注意到状态转移方程（代码中）：


     dp[i][j] = dp[i - 1][j] || dp[i - 1][j - nums[i]];
     当 j - nums[i] == 0 成立的时候，根据上面分析，就说明单独的 nums[i] 这个数就恰好能够在被分割为单独的一组，其余的数分割成为另外一组。因此，我们把初始化的 dp[i][0] 设置成为 true 是没有问题的。
     */
    static func canPartition(_ nums: [Int]) -> Bool {
        let sum = nums.reduce(0) { r, v in
            return r+v
        }
        if sum%2 != 0 {
            return false
        }
        let half = sum/2
        return backPack(packTotal: half, itemsQuality: nums) == half
    }
    
    
    static func canPartition1(_ nums: [Int]) -> Bool {
        var maxX = Int.min
        let sum = nums.reduce(0) { r, v in
            maxX = max(v, maxX)
            return r+v
        }
        guard !nums.isEmpty,
              nums.count >= 2,
              sum%2 == 0 else {
            return false
        }
        let temp = nums.sorted(by: {$0<$1})
        let half = sum/2
        if maxX > half {
            return false
        }
        let count = temp.count
        var status: [[Bool]] = .init(repeating: .init(repeating: false, count: half+1), count: count)
        for i in 0..<count {
            status[i][0] = true
        }
        status[0][nums[0]] = true
        for c in 1..<count {
            let current = temp[c]
            for T in 1...half {
                if T >= current {
                    status[c][T] = status[c-1][T] || status[c-1][T-current]
                }else {
                    status[c][T] = status[c-1][T]
                }
                // 增加提前找到half这个值的判断，叫做剪枝操作
                if status[c][half] {
                    return true
                }
                
            }
        }
        return status[count-1][half]
    }
    
    
    static func canPartition2(_ nums: [Int]) -> Bool {
        let count = nums.count
        let sum = nums.reduce(0) { r, v in
            return r + v
        }
        guard sum&1 == 0 else {
            return false
        }
        let half = sum/2
        var status:[Bool] = .init(repeating: false, count: half+1)
        if nums[0] <= half {
            status[0] = true
        }
        for c in 1..<count {
            //WARN: 这里取值等于是上一行找T或者是上一行找剔除T的值
            if nums[c] > half {
                continue
            }
            for T in (nums[c]...half).reversed() {
                if status[half] {
                    return true
                }
//                status[T] = status[half-T] || status[nums[c]]
                //WARN: 这里取值等于是上一行找T或者是上一行找剔除T的值
                status[T] = status[T] || status[T-nums[c]]
            }
        }
        
        
        return status[half]
    }
}
