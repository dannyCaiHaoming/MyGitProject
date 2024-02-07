//
//  乐扣Top100.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2024/2/4.
//  Copyright © 2024 蔡浩铭. All rights reserved.
//

import Foundation

class 乐扣Top100: Do {
    
    static func doSomething() {
        
    
        let test = 乐扣Top100()
     
//        let r = test.generateParenthesis(3)
        
//        let r = test.search([5,1,3], 3)
        
//        let r = test.searchRange([3,3,3], 3)
//        var matrix = [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]
//        test.rotate(&matrix)
        
//        let r = test.groupAnagrams2(["hhhhu","tttti","tttit","hhhuh","hhuhh","tittt"])
        
//        let r = test.maxSubArray( [5,4,-1,7,8])
        
        let r = test.canJump([8,2,4,4,4,9,5,2,5,8,8,0,8,6,9,1,1,6,3,5,1,2,6,6,0,4,8,6,0,3,2,8,7,6,5,1,7,0,3,4,8,3,5,9,0,4,0,1,0,5,9,2,0,7,0,2,1,0,8,2,5,1,2,3,9,7,4,7,0,0,1,8,5,6,7,5,1,9,9,3,5,0,7,5])
        
        print(r)
    }
    
    
    
    //MARK: 22. 括号生成
    /*
     n*2 代表步长，然后（，）需要用一个池子放着，递归看每次能用左，还是右
     难度在剪枝，因为有可能"）"出现在第一位或者"（"出现在最后一位，也有可能"())"这种不匹配的情况
     */
    
    var generateParenthesisResult: [String] = []
    var generateParenthesisCurrent: String = ""
     func generateParenthesis(_ n: Int) -> [String] {
        
        generateParenthesisBacktrace(cur: 0, left: n, right: n,total: n*2)
        return generateParenthesisResult
    }
    
    
    func generateParenthesisBacktrace(cur: Int,left: Int,right: Int,total: Int) {
        // 一位可以是左，可以是右
        
        if left == 0,
           right == 0 {
            generateParenthesisResult.append(generateParenthesisCurrent)
        } else if left < 0 || right < 0 {
            return
        }
   
        if cur != total-1 {
            // 左
            generateParenthesisCurrent += "("
            generateParenthesisBacktrace(cur: cur + 1, left: left-1, right: right,total: total)
            generateParenthesisCurrent.removeLast()
        }
        if cur != 0 && left != right {
            generateParenthesisCurrent += ")"
            generateParenthesisBacktrace(cur: cur + 1, left: left, right: right-1,total: total)
            generateParenthesisCurrent.removeLast()
        }
        

    }
    
    // MARK: 31. 下一个排列  --- 卡很久
    /*
     做题顺序
     1.先找一般序列，然后找一般规律。
     2.将一般规律尝试放入到特殊构造序列，是否通用，是否能得出关键。
     例如官方题解：
     1. 4,5,2,6,3,1  -> 4,5,3,1,2,6 ，一般规律就是，最后的一个降序数据块前一位，和降序里面最小（比这个前一位要大）的一位置换，然后（这个前一位之后）剩下后面是升序。
     2. 将这个放入一些特殊例子
     1,2,3,4,5,6
     只需要家那个最后一个升序快【6】的前一位【5】，将【5】和升序快中【6】比他较大的替换，然后将替换后的升序块【5】进行排序
     6,5,4,3,2,1
     最后一个升序块为-1，那这里就是，特殊情况，当没有找到升序块，然后遍历到头，就整个直接升序。
     
     升序降序升序  1,2,3,6,5,4,7,8,9 -> 1,2,3,6,5,7,4,8,9
     
     降序升序降序  3,2,1,4,5,6,9,8,7  -> 3,2,1,4,5,7,6,8,9
     
     *** 发现关键，还是后面，不管是升序，还是一降序，最重要还是找到，从后往前，后一位，比前一位要大的，这个时候，前一位，就是较小，也是上文发现规律中的“前一位”
     然后在前一位后面的序列中，找打比他“稍大”的，然后交换，剩下的就是后面序列的升序排序。
     */
    
    func nextPermutation(_ nums: inout [Int]) {
        var needSorted = false
        var start: Int = 0
        for i in (0..<nums.count).reversed() {
            if i - 1 >= 0 {
                if nums[i] > nums[i-1] {
                    start = i-1
                    needSorted = true
                    break
                }
            }
        }
        if start == 0 && !needSorted {
            nums = nums.sorted()
        } else {
            var min: Int = start+1
            for i in start+1..<nums.count {
                
                if nums[i] > nums[start] {
                    if nums[i] > nums[min] {
                        continue
                    }
                    min = i
                }
                
            }
            let tmp = nums[min]
            nums[min] = nums[start]
            nums[start] = tmp
            let firt = nums[0...start]
            let last = nums[start+1...nums.count-1].reversed()
            nums = Array(firt) + Array(last)
        }
    }
    
    
    //MARK: --  33. 搜索旋转排序数组
    /*
     题目的是意思，就是在一个顺序不规则的数组里面查找某个数字，而且要nlogn的时间复杂度的  ------> 二分
    
     1.  顺序  从小到大 1,2,3,4,5,6
        end > stat ,
      mid > start ,   start = mid
     mid < end ,  end = mid
     2.  旋转了   4,5,6,1,2,3
        分为：
        1. target [[在4，5,6升序中]]，那么 target < mid , target > start , 漏了升序判断
        2. target [[在 1,2,3升序中]]，那么target > start ,target < end
     而还有一步就是，开头的， mid > start ,mid > end , end = mid
                         mid < start ,mid < end ,start = mid
     
     这题，自己分析的条件漏掉，直接写了结论，导致有些判断条件失败。
     
     */
    func search(_ nums: [Int], _ target: Int) -> Int {
        var l = 0
        var r = nums.count-1
        var mid = (l+r) / 2
        var result: Int = -1
        if nums[l] < nums[r] {
            while l <= r {
                if nums[mid] == target {
                    result = mid
                    break
                }
                if nums[mid] > target {
                    r = mid - 1
                } else {
                    l = mid + 1
                }
                mid = (l + r) / 2
            }
        } else {
            while l <= r {
                if nums[mid] == target {
                    result = mid
                    break
                }
                if nums[mid] >= nums[l] {
                    if nums[mid] > target && nums[l] <= target {
                        r = mid - 1
                    } else {
                        l = mid + 1
                    }
                } else {
                    if target > nums[mid] && nums[r] >= target {
                        l = mid + 1
                    } else {
                        r = mid - 1
                    }
                }
                mid = (l + r) / 2
            }
        }
        return result
    }
    
    /*
     public int search(int[] nums, int target) {
          int n = nums.length;
          if (n == 0) {
              return -1;
          }
          if (n == 1) {
              return nums[0] == target ? 0 : -1;
          }
          int l = 0, r = n - 1;
          while (l <= r) {
              int mid = (l + r) / 2;
              if (nums[mid] == target) {
                  return mid;
              }
              if (nums[0] <= nums[mid]) {
                  if (nums[0] <= target && target < nums[mid]) {
                      r = mid - 1;
                  } else {
                      l = mid + 1;
                  }
              } else {
                  if (nums[mid] < target && target <= nums[n - 1]) {
                      l = mid + 1;
                  } else {
                      r = mid - 1;
                  }
              }
          }
          return -1;
      }
     */
    
    
    // MARK: 34. 在排序数组中查找元素的第一个和最后一个位置
    /*
     题目需要nlogn的时间复杂度，二分。
     寻找一个元素的的开头和结束，而二分只能找到这个元素所在的地方。
     那么可以左搜索最小下标，加上右搜索最大下标。
     */
    func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
        var l = 0
        var r = nums.count - 1
        var mid = (l + r) / 2
        var result: [Int] = []
        if !nums.isEmpty {
            while l <= r {
                if nums[mid] == target {
                    break
                }
                if nums[mid] > target {
                    r = mid - 1
                } else {
                    l = mid + 1
                }
                mid = (l + r) / 2
            }
            if nums[mid] == target {
                
                var left = mid
                var minLeft = Int.max
                while left >= 0 {
                    if nums[left] == target {
                        if left < minLeft {
                            minLeft = left
                        }
                    }
                    left -= 1
                }
                result.append(minLeft)

                var right = mid
                var maxRight = -1
                while right < nums.count {
                    if nums[right] == target {
                        if right > maxRight {
                            maxRight = right
                        }
                    }
                    right += 1
                }
                result.append(maxRight)
            }
        }
        if result.isEmpty {
            return [-1,-1]
        }
        return result
    }
    
    
    // 48. 旋转图像
    
    /*
     也是需要分析的题目。
     
     1,2,3    7,4,1
     4,5,6    8,5,2
     7,8,9    9,6,3
     
     5,1,9,11     15,13,2,5
     2,4,8,10     14,3,4,1
     13,3,6,7     12,6,8,9
     15,14,12,16  16,7,10,11
     
     观察简单的3,4行矩阵，发现，是从外到内，一圈一圈的，从四个方向进行替换。
     而一圈一圈，全数其实就是刚好数量的一半
     
     需要注意，转的时候，会有一些位置会被覆盖掉
     1,2,3   7,4,1
     4,5,6   4,5,6
     7,8,9   7,8,9
     这时候右边的1,6,9就会被影响到。
     
     官方题解
     
     1,2,3            1,4,7                 7,4,1
     4,5,6  =对折=>    2,5,8   =左右反转=》    8,5,2
     7,8,9            3,6,9                 9,6,3
     
     
     */
    func rotate(_ matrix: inout [[Int]]) {
        
        let last = matrix.count-1
        let round = matrix.count / 2
        
        for i in 0..<round {
            
            // 先临时记住 左边的，最后要覆盖回面
            var tmpTop:[Int] = []
            var tmpRight:[Int] = []
            var toAdd:[Int] = []
            var tmp: [Int] = []
            
            
            // 左边覆盖上面 ,覆盖完，右边就变形了
            for l in (i...last-i).reversed() {
                toAdd.append(matrix[l][i])
            }
            for r in (i...last-i).reversed() {
                tmpRight.append(matrix[r][last-i])
            }
            for t in i...last-i {
                tmpTop.append(matrix[i][t])
                matrix[i][t] = toAdd[t-i]
            }

            // 底下覆盖左边
            for b in i...last-i {
                tmp.append(matrix[last-i][b])
            }
            for l in i...last-i {
                matrix[l][i] = tmp[l-i]
            }
                        
            for r in i...last-i {
                // 顺便覆盖右边
                matrix[r][last-i] = tmpTop[r-i]
            }
            // 右边覆盖下边
            for b in i...last-i {
                matrix[last-i][b] = tmpRight[b-i]
            }

        }
        
    }
    
    
    //MAKR: 49. 字母异位词分组
    /*
     也是分析题
     
     ["eat","tea","tan","ate","nat","bat"]
     
     增加 【"e":1,"a":1,"t":1】
     
     eat 怎么构造hash 如果把askii码拼接，顺序怎么处理
     
     特殊情况，多个字母重复的时候。但是
     */
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        let count = strs.count
        var result: [[String]] = .init(repeating: [], count: count)
        var hash: [[Int:Int]] = []
        
        let a = "asdf"
        
        for str in strs {
            
            var matchHash:[Int: Int] = [:]
            for w in str {
                let ascii = Int(w.unicodeScalars.first?.value ?? 0)
                if ascii > 0 {
                    var tmp = matchHash[ascii] ?? 0
                    tmp += 1
                    matchHash[ascii] = tmp
                }
            }
            
            var contain = false
            var id = 0
            for idx in 0..<hash.count {
                id = idx
                let h = hash[idx]
                var tmpContain = true
                if str == "" {
                    let ascii = Int(str.unicodeScalars.first?.value ?? 0)
                    if (h[ascii] ?? 0) > 0  {
                        contain = true
                        break
                    }
                } else {
                    
                    if matchHash.keys.count != h.keys.count {
                        continue
                    }

                    
                    for k in matchHash.keys {
                        tmpContain = (tmpContain && h[k] == matchHash[k])
                    }
                    contain = tmpContain
                }
                if contain {
                    break
                }
            }
            if contain {
                var tmp = result[id]
                tmp.append(str)
                result[id] = tmp
                continue
            }
            id = hash.count
            var tmp:[Int:Int] = [:]
            if str == "" {
                let ascii = Int(str.unicodeScalars.first?.value ?? 0)
                tmp[ascii] = 1
            } else {
                for w in str {
                    let ascii = Int(w.unicodeScalars.first?.value ?? 0)
                    if ascii > 0 {
                        var tmpV = tmp[ascii] ?? 0
                        tmpV += 1
                        tmp[ascii] = tmpV
                    }
                }
            }
            hash.append(tmp)
            result[id] = [str]
        }
        return result.filter({ !$0.isEmpty }).reversed()

    }
    
    // 艹。还是出在找hash key这步，自己的方法太差
    
    func groupAnagrams2(_ strs: [String]) -> [[String]] {
        var hash: [String: [String]] = [:]
        
        for str in strs {
            let sortStr = String(str.sorted())
            if hash[sortStr]?.isEmpty ?? false {
                hash[sortStr] = [str]
            } else {
                var t = hash[sortStr] ?? []
                t.append(str)
                hash[sortStr] = t
            }
        }
        
        return hash.values.map({ $0 })
    }
    
    
    
    
    // MARK: 53. 最大子数组和
    
    /*
     [-2,1,-3,4,-1,2,1,-5,4]
     
     [4,-1,2,1]
     
     [5,4,-1,7,8]
     
     [5,4,-1,7,8]
     
     
     初步规律， 因为要找越大的数
     左边开始，第一个不小于0的数。  但是如果都是负数呢
     
     假设  用当前值 跟 下一个值比较
     如果下一个值大
                     如果都是负数 ，那就直接用下个值
                     如果都是正数，相加
                    如果前负，后正，那就直接用后面的。
     
     并且用一个位记录最大
     
     然后举一些特殊例子，-1，-2，-3 ； -3，-2，-1 ，进行代入纠错
     发现，当当前结果小于0，且当前轮询值比当前结果大的时候，需要直接替换。
     */
    
    func maxSubArray(_ nums: [Int]) -> Int {
        var max = Int.min
        var result = 0
        for i in 0..<nums.count {
            let cur = nums[i]
            
            if cur > 0 {
                if result >= 0 {
                    result += cur
                    if result > max {
                        max = result
                    }
                } else {
                    result = cur
                    if result > max {
                        max = result
                    }
                }
            } else {
                if result < 0 ,
                   cur > result {
                    result = cur
                    if result > max {
                        max = result
                    }
                } else {
                    result += cur
                    if result > max {
                        max = result
                    }
                }
            }
        }
        return max
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
//    var canJump = false
//    ///  0  未访问，1，可行，-1不可行
//    var jumpDic:[Int] = []
//    func canJump(_ nums: [Int]) -> Bool {
//        
//        jumpDic = .init(repeating: 0, count: nums.count)
//        
//        for s in 0...nums[0] {
//            if s < nums.count {
//                canJumpBacktrace(cur: s, nums: nums)
//            }
//        }
//        
//        return canJump
//    }
//    
//    // cur 是跳转后的下标，step，是下标还能跳转的步数
//    func canJumpBacktrace(cur: Int,nums:[Int]) {
//        if cur >= nums.count-1 {
//            jumpDic[cur] = 1
//            canJump = true
//            return
//        }
//        let step = nums[cur]
//        
//        if step == 0,
//           cur + step < nums.count-1 {
//            jumpDic[cur+step] = -1
//        }
//        
//        if cur + step >= nums.count-1 {
//            if cur + step == nums.count-1 {
//                jumpDic[cur+step] = 1
//            } else {
//                jumpDic[cur] = 1
//            }
//            canJump = true
//            return
//        }
//        
//        if jumpDic[cur] == 0 {
//            
//            if nums[cur+step] == 0 {
//                if cur < nums.count-1 {
//                    jumpDic[cur+step] = -1
////                    return
//                } else {
//                    jumpDic[cur] = 1
//                    return
//                }
//
//            }
//            
//            for i in 1...step {
//                if canJump {
//                    return
//                }
//                if jumpDic[cur+i] == -1 {
//                    continue
//                }
//                if step > 0 {
//                    canJumpBacktrace(cur: cur+i, nums: nums)
//                }
//                else {
//                    canJumpBacktrace(cur: cur, nums: nums)
//                }
//            }
//        }
//        
//    }
    
    /*
     那就是BFS，DFS概念没搞清楚。
     导致数据结构，错误。
     
     */
    
    /*
     BFS
     
     [2,3,1,1,4]
     
     [3,2,1,0,4]
     */
    var canJumpDict: [Bool] = []
    func canJump(_ nums: [Int]) -> Bool {
        canJumpDict = .init(repeating: false, count: nums.count)
        
        var queue:[Int] = []
        queue.append(nums[0])
        var cur = 0
        canJumpDict[cur] = true
        while !queue.isEmpty {
            var size = queue.count
            while size > 0 {
                size -= 1
                let next = queue.removeFirst()+cur
                if canJumpDict[cur] {
//                    let id = next >= (nums.count - 1) ? nums.count-1 : next
                    for i in cur...next {
                        if i < nums.count {
                            queue.append(i)
                            canJumpDict[i] = true
                        }
                    }
//                    for i in cur...id {
//                        canJumpDict[i] = true
//                    }
                    
                }
            }
        }
        
        
        return canJumpDict[nums.count-1]
    }

     
}
