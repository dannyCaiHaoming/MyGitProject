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
        
//        let r = test.canJump([2,3,1,1,4])
        
//        let r = test.merge([]])
        
//        let r = test.uniquePaths(3, 7)
        
//        let r = test.minPathSum([[7,1,3,5,8,9,9,2,1,9,0,8,3,1,6,6,9,5],[9,5,9,4,0,4,8,8,9,5,7,3,6,6,6,9,1,6],[8,2,9,1,3,1,9,7,2,5,3,1,2,4,8,2,8,8],[6,7,9,8,4,8,3,0,4,0,9,6,6,0,0,5,1,4],[7,1,3,1,8,8,3,1,2,1,5,0,2,1,9,1,1,4],[9,5,4,3,5,6,1,3,6,4,9,7,0,8,0,3,9,9],[1,4,2,5,8,7,7,0,0,7,1,2,1,2,7,7,7,4],[3,9,7,9,5,8,9,5,6,9,8,8,0,1,4,2,8,2],[1,5,2,2,2,5,6,3,9,3,1,7,9,6,8,6,8,3],[5,7,8,3,8,8,3,9,9,8,1,9,2,5,4,7,7,7],[2,3,2,4,8,5,1,7,2,9,5,2,4,2,9,2,8,7],[0,1,6,1,1,0,0,6,5,4,3,4,3,7,9,6,1,9]])
        
//        let r = test.minDistance("horse", "ros")
        
//        let r = test.subsets([1,2,3])
        
//        let r = test.exist([["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"]], "AAAAAAAAAAAAAAa")
        
//        let r = test.numTrees(3)
        
//        let r = test.longestConsecutive([100,4,200,1,3,2])
        
        let r = test.wordBreak("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab", ["a","aa","aaa","aaaa","aaaaa","aaaaaa","aaaaaaa","aaaaaaaa","aaaaaaaaa","aaaaaaaaaa"])
        
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
//    var canJumpDict: [Bool] = []
//    func canJump(_ nums: [Int]) -> Bool {
//        canJumpDict = .init(repeating: false, count: nums.count)
//        
//        var queue:[Int] = []
//        queue.append(nums[0])
//        var cur = 0
//        canJumpDict[cur] = true
//        while !queue.isEmpty {
//            var size = queue.count
//            while size > 0 {
//                size -= 1
//                let next = queue.removeFirst()+cur
//                if canJumpDict[cur] {
////                    let id = next >= (nums.count - 1) ? nums.count-1 : next
//                    for i in cur...next {
//                        if i < nums.count {
//                            queue.append(i)
//                            canJumpDict[i] = true
//                        }
//                    }
////                    for i in cur...id {
////                        canJumpDict[i] = true
////                    }
//                    
//                }
//            }
//        }
//        
//        
//        return canJumpDict[nums.count-1]
//    }
    /*
     贪心。
     每次求最远，因为求是否能走到终点。遍历每个点，看能走多远，最后判断最远是否达到最后一位。
     同时注意的是，要判断可达性，即当前最远可走，和当前下标是否能到。
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
     
    
    
    // MARK: 56. 合并区间
    
    /*
     区间
     
     难点应该在，需要判别的，到底跟已经记录的，是在左，还是在右。
     1.合并完，可能还需要再次合并。
     2.合并完的顺序，并不是顺序。
     
     [[2,3],[4,5],[6,7],[8,9],[1,10]]
     
     [[2,3],[4,6],[5,7],[3,4]]
     */
    
    func merge(_ intervals: [[Int]]) -> [[Int]] {
        var result: [[Int]] = []
        let sortInter = intervals.sorted { l, r in
            return l[0] < r[0]
        }
        for inter in sortInter {
            
            result = result.filter({ match in
                if inter[0] <= match[0] && inter[1] >= match[1] {
                    return false
                }
                return true
            })
            
            var noMatch = true
            for idx in 0..<result.count {
                let match = result[idx]
                if match[0] > inter[1] || match[1] < inter[0] {
                    continue
                }
                var l = inter[0]
                var r = inter[1]
                if match[0] < l {
                    l = match[0]
                }
                if match[1] > r {
                    r = match[1]
                }
                result[idx] = [l,r]
                noMatch = false
            }
            if noMatch {
                result.append(inter)
            }
        }

        var mergeAgain = false
        let sortResult = result

        for i in 0..<sortResult.count {
            if i+1 < sortResult.count {
                /*
                        B
                    A
                 B
                 */
                if sortResult[i+1][0] >= sortResult[i][0] && sortResult[i+1][0] <= sortResult[i][1] && sortResult[i+1][1] >= sortResult[i][1] {
                    mergeAgain = true
                }
                if sortResult[i+1][1] >= sortResult[i][0] && sortResult[i+1][1] <= sortResult[i][1] && sortResult[i+1][0] <= sortResult[i][0] {
                    mergeAgain = true
                }
            }
        }
        if mergeAgain {
            return merge(sortResult)
        }
        
        return sortResult
    }
    
    // 官方题解，nlogn
    /*
     过程差不多，但是先将interval排序好之后，每次的L都是按顺序的，
     因此，只需要判断要插入的最小，是否在之前的边界，
     如果是，则只需要改当前【结果中最后一个】的R
     如果不是，则只需要往结果中新增
     */
    func merge2(_ intervals: [[Int]]) -> [[Int]] {
        var result: [[Int]] = []
        
        let sortInter = intervals.sorted { l, r in
            return l[0] < r [0]
        }
        
        for int in sortInter {
            if result.isEmpty || result.last![1] < int[0]  {
                result.append(int)
            } else {
                if var last = result.last,
                   last[1] < int[1] {
                    last[1] = int[1]
                    result.removeLast()
                    result.append(last)
                }
            }
        }
        
        return result
    }
    
    
    //MARK:  62. 不同路径
    /*
     BFS，广度吧，用一个结果记录多少次达到m,n=0  -- 跑着跑着超时
     
     最后发现能分割，那就是动态规划的题目  --  还是会超时。。。
     
     */

//    func uniquePaths(_ m: Int, _ n: Int) -> Int {
//        if m < 1 || n < 1 {
//            return 0
//        }
//        if m == 1 ,
//           n == 1 {
//            return 1
//        }
//        var r = 0
//        var b = 0
//        if n-1 == 1 {
//            r = 1
//        } else {
//            r = uniquePaths(m, n-1)
//        }
//        if m-1 == 1 {
//            b = 1
//        } else {
//            b = uniquePaths(m-1, n)
//        }
//        return r + b
//    }
    
    func uniquePaths(_ m: Int, _ n: Int) -> Int {
            
        var result:[[Int]] = .init(repeating: .init(repeating: 0, count: n), count: m)
        
        for i in 0..<m {
            result[i][0] = 1
        }
        for i in 0..<n {
            result[0][i] = 1
        }
        for i in 1..<m {
            for j in 1..<n {
                result[i][j] = result[i-1][j] + result[i][j-1]
            }
        }
        return result[m-1][n-1]
    }
    
    
    // MARK: 64. 最小路径和
    /*
     又是把动态规划做成搜索。。。。搜索应该是暴力解法
     */
    var minPathSumResult:[[Int]] = []
    func minPathSum(_ grid: [[Int]]) -> Int {
        let r = grid.count
        let c = grid[0].count
        minPathSumResult = .init(repeating: .init(repeating: .max, count: c), count: r)
        
        
        
        minPathSumBacktrace(grid, row: r, column: c, cur: [0,0], sum: 0)
        
        
        
        return minPathSumResult[r-1][c-1]
    }
    
    let direction = [[1,0],[0,1]]
    func minPathSumBacktrace(_ grid: [[Int]],row: Int,column: Int,cur: [Int],sum: Int) {
        
        let x = cur[0]
        let y = cur[1]
        let cur = grid[x][y]
        
        let step = minPathSumResult[x][y]
        if cur + sum < step {
            minPathSumResult[x][y] = cur + sum
        }
        
    
        for d in direction {
            let dx = x + d[0]
            let dy = y + d[1]
            if dx >= row || dy >= column {
                continue
            }
            minPathSumBacktrace(grid, row: row, column: column, cur: [dx,dy], sum: cur+sum)
        }
        
    }

    
    
    //MARK: 72. 编辑距离
    
    /*
     一个很难的动态规划，以至于根本不知道应该用什么方式。---后面不知道用什么方式的时候，可以先瞎想动态规划。
     这类题目，重点关注
     1. 对于题目给出操作分类，怎么依照情况细化。
        如，这题，可对字符进行增删改，那对于两个字符串，就有6种情况。分别对着6种情况进行分析。
        对A增，等于对B减；对A减，等于对B增。对A修改，等于对B修改。
        即可划分为三大类，对A增，对B增，对A修改。
     2. 细分后，思考如何寻找每步最值。
        1.这里，对A增的情况，可以为A时“”，B是“ABC”，则当知道A经过N次修改，得到A为“AB”后，只需要N+1，则得到结果
        2.同理，当A为“ABC”，B为“”时，当B知道经历N次修改后，得到B为”AB“后，只需要N+1则知道结果
        3.当A为”ABC“，B为”ACB”时，当知道A经过N次修改，得到“ACC”后，只需要N+1则知道结果
        特殊，当A为“ABB”，B为“ACB”时，当A经历N次修改，则只需要N次则知道结果。
     

     */
    
    func minDistance(_ word1: String, _ word2: String) -> Int {
        let row = word1.count
        let column = word2.count
        var result:[[Int]] = .init(repeating: .init(repeating: 0, count: column+1), count: row+1)
        
        for i in 0..<row+1 {
            result[i][0] = i
        }
        for j in 0..<column+1 {
            result[0][j] = j
        }
        
        for i in 1..<row+1 {
            for j in 1..<column+1 {
                let add = result[i-1][j] + 1
                let add2 = result[i][j-1] + 1
                var match = result[i-1][j-1] + 1
                /*
                 因为这里需要记录的是从下标0--i,0---j个元素 因此，dp数组长度是i+1,j+1，下标就是0...i,0...j
                  但是，取字符串的长度，还是0--i-1,0--j-1个。
                 所以i，j对应的结果，是dp[i][j],但是字符串对应的是i-1和j-1
                 */
                if
                    (word1 as NSString).substring(with: .init(location: i-1, length: 1)) == (word2 as NSString).substring(with: .init(location: j-1, length: 1)) {
                    match -= 1
                }
                var min = add
                if add2 < add {
                    min = add2
                }
                if match < min {
                    min = match
                }
                result[i][j] = min
            }
        }
        return result[row][column]
    }
    
    // MARK: 75. 颜色分类
    func sortColors(_ nums: inout [Int]) {
        var left = 0
        var right = nums.count - 1
        var result:[Int] = []
        for i in 0..<nums.count {
            result.append(1)
        }
        for i in 0..<nums.count {
            if nums[i] == 0 {
                result[left] = 0
                left += 1
            }
            if nums[i] == 2 {
                result[right] = 2
                right -= 1
            }
        }
        nums = result
    }
    
    /*
     双指针方法，当初没写出来
     */
    func sortColors2(_ nums: inout [Int]) {
        var left = 0
        var right = nums.count - 1
        var i = 0
        while i <= right {
            while i <= right , nums[i] == 2 {
                let tmp =  nums[right]
                nums[right] = nums[i]
                nums[i] = tmp
                right -= 1
            }
            if nums[i] == 0 {
                let tmp = nums[i]
                nums[i] = nums[left]
                nums[left] = tmp
                left += 1
            }
            i += 1
        }
    }
    
    
    //MARK: 78. 子集
    var subsetsMARK:[Bool] = []
    var subsetsList:[Int] = []
    var subsetsResult:[[Int]] = []
    func subsets(_ nums: [Int]) -> [[Int]] {
        let count = nums.count
        subsetsMARK = .init(repeating: false, count: count)
        if !nums.isEmpty {
            subsetsResult.append([])
        }
        for i in 1...nums.count {
            subsetsBacktrace(nums, count: i, current: 0)
        }
        return subsetsResult
    }
    
    func subsetsBacktrace(_ nums: [Int],count: Int,current: Int) {
        if count == 0 {
            subsetsResult.append(subsetsList)
            return
        }
        if count < 0 {
            return
        }
        if current >= nums.count {
            return
        }
        for i in current..<nums.count {
            subsetsMARK[i] = true
            subsetsList.append(nums[i])
            subsetsBacktrace(nums, count: count-1, current: i+1)
            subsetsList.removeLast()
            subsetsMARK[i] = false
        }
    }
    
    //MARK: 79. 单词搜索
    /*
     我草。偶尔超时。
     */
    var existMark: [[Bool]] = []
    var res = false
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        let row = board.count
        let column = board[0].count
        
        existMark = .init(repeating: .init(repeating: false, count: column), count: row)
        
        for r in 0..<row {
            for c in 0..<column {
                existBacktrace(board: board, word: word,wordIdx: 0,row: r, column: c, totalR: row, totalC: column)
            }
        }

        return res
    }
    let direction_4:[[Int]] = [
        [-1,0],[1,0],
        [0,1],[0,-1]
    ]
    func existBacktrace(board:[[Character]],word: String,wordIdx: Int,row: Int,column: Int,totalR: Int,totalC: Int)  {
        guard row >= 0 ,
              row < totalR,
              column >= 0,
              column < totalC,
              existMark[row][column] == false,
              wordIdx < word.count,
              word[word.index(word.startIndex, offsetBy: wordIdx)] ==  board[row][column] else {
            return
        }
        if wordIdx == word.count - 1 {
            res = true
            return
        }
        existMark[row][column] = true
        for d in direction_4 {
            let newR = row + d[0]
            let newC = column + d[1]
            existBacktrace(board: board, word: word,wordIdx:wordIdx+1, row: newR, column: newC, totalR: totalR, totalC: totalC)
        }
        existMark[row][column] = false
    }
    
    
    // MARK:  96. 不同的二叉搜索树
    /*
     二叉搜索树特性，左边的树节点，比根节点小，右边的树节点，比根节点大。
     因此，如果一个n整数，随机选一个i，作为根节点，那么
     1. 0...i-1，都会比i小，作为左子树
     2. i+1...n-1，都会比i大，作为右子树。
     剩下，将1,2两个情况，也继续拆分，放入这两种情况。
     因此假设左子树为numTrees(start:0,end:i-1)=x,右子树为numsTrees(i+1,n-1)=y，
     则，i作为根节点的时候，二叉搜索树，种数为x*y
     */
    func numTrees(_ n: Int) -> Int {
        return numTrees(start: 0, end: n-1)
    }
    
    func numTrees(start: Int,end: Int) -> Int {
        
        if start == end {
            return 1
        }
        if end - start == 1 {
            return 2
        }
        
        var result = 0
        for i in start...end {
            var left = 1
            var right = 1
            if i > start {
                left = numTrees(start: start, end: i-1)
            }
            if i < end  {
                right = numTrees(start: i+1, end: end)
            }
            result += left * right
        }
        return result
    }
    
    
    //MARK: 98. 验证二叉搜索树
    
    /*
     想不到怎么遍历。 发现中序遍历，每个值都比前一个大。
     
     */
    func isValidBST(_ root: TreeNode?) -> Bool {
        let array = isValidBSTVallues(root: root)
        if array.count > 1 {
            
        } else {
            return true
        }
        for i in 0..<array.count {
            if i + 1 < array.count {
                if array[i] >= array[i+1] {
                    return false
                }
            }
        }
        
        return true
    }
    
    func isValidBSTVallues(root : TreeNode?) -> [Int] {
        guard let root = root else {
            return []
        }
        let left = isValidBSTVallues(root: root.left)
        let right = isValidBSTVallues(root: root.right)
        return left + [root.val] + right
        
    }
    
    /*
     递归没想到，第一次也是想最大最小，但是没想出来是用上下界限。
     根节点的左子树，上限制为根节点的值，下限为负无穷
     根节点的右子树，下限为根节点的值，上限制无正无穷
     */
    func isValidBST2(_ root: TreeNode?) -> Bool {
        return isvalidBSTBacktrace(root: root, less: .min, max: .max)
    }
    
    func isvalidBSTBacktrace(root: TreeNode?,less: Int, max:Int) -> Bool {
        guard let root = root else {
            return true
        }
        if root.val <= less || root.val >                                                      max {
            return false
        }
        var leftV = true
        if let left = root.left {
            leftV = isvalidBSTBacktrace(root: root.left, less: less, max: root.val) && root.val > left.val
        }

        var rightV = true
        if let right = root.right {
            rightV = isvalidBSTBacktrace(root: root.right, less: root.val, max: max) && root.val < right.val
        }
        
        
        return leftV && rightV
    }
    
    //MARK: 102. 二叉树的层序遍历
    /*
     广度搜索
     */
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        var result:[[Int]] = []
        var queue: [TreeNode] = []
        if let root = root {
            queue.append(root)
        }
        while !queue.isEmpty {
            var size = queue.count
            var this: [Int] = []
            while size > 0 {
                size -= 1
                let cur = queue.removeFirst()
                this.append(cur.val)
                if let left = cur.left {
                    queue.append(left)
                }
                if let right = cur.right {
                    queue.append(right)
                }
            }
            if !this.isEmpty {
                result.append(this)
            }
        }
        return result
    }
    
    
    // MARK: 105. 从前序与中序遍历序列构造二叉树
    
    /*
     从知识点知道，前序中第一位，是根节点，然后拿着根节点去中序，进行拆分。
     分成左子树和右子树。
     所以，每次从前序中，取出一位，然后到中序查找，然后将中序分成左子树，和右子树。
     那么构造一个root，那他的左子树，也能用同样的算法，计算，右子树，也是能用同样的算法计算。
     只是要规划好，根据前序得到根节点后，需要用中序，遍历出根节点位置，然后划分好左右子树，然后进行递归。
     */
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        guard !preorder.isEmpty,
              !inorder.isEmpty,
              let rootV = preorder.first else {
            return nil
        }
        let count = preorder.count
        let root = TreeNode.init(rootV)
        var mid = 0
        while inorder[mid] != rootV {
            mid += 1
        }
        let leftCount = mid
        let rightCount = count - leftCount - 1
        
        let left = buildTree(Array(preorder[1..<leftCount+1]), Array(inorder[0..<leftCount]))
        let right = buildTree(Array(preorder[leftCount+1..<count]), Array(inorder[leftCount+1..<count]))
        root.left = left
        root.right = right
        return root
    }
    
    
    //MARK: 114. 二叉树展开为链表
    /*
     看成了中序遍历。
     是先序遍历的顺序。
     
    貌似迭代方法的时候，先入根节点，然后再左右，根再右左，就是不一样的遍历方式。
     
     ** 官方题解，类似双指针，也是链表常用，一个指向上一个节点，用栈存储下一个将要访问的节点。 **
     */
    
    func flatten(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        var array:[TreeNode] = preFlatten(root: root)
        
        for j in 0..<array.count {
            if j+1 < array.count {
                array[j].left = nil
                array[j].right = array[j+1]
            }
        }
    }
    
    func preFlatten(root: TreeNode?) -> [TreeNode] {
        guard let root = root else {
            return []
        }
        let left = preFlatten(root: root.left)
        let right = preFlatten(root: root.right)
        return [root] + left + right
    }
    
    // MARK: 128. 最长连续序列
    /*
     想着用一个字典区间，来查看是否符合。但是还要去重
     
     ** 官方答案，使用Set进行去重。因为筛选连续序列，可以有+-1，因此导致时间复杂度会变成N*N。
     因此我们只需要遍历一个方向的数据是否存在即可。
     
     */
    func longestConsecutive(_ nums: [Int]) -> Int {
        let numSet = Set(nums)
        var longest = 0
        for num in numSet {
            if !numSet.contains(num-1) {
                var currentNum = num
                var currentStreak = 1
                while numSet.contains(currentNum+1) {
                    currentNum += 1
                    currentStreak += 1
                }
                if currentStreak > longest {
                    longest = currentStreak
                }
            }
        }
        return longest
    }
    
    //MARK:  139. 单词拆分
    
    /*
     动态规划
     
     s，每次查看dict里面是否还存在能够去掉的。
     
     超时。
     */
    func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
        let arr = Array(s)
        var dp:[Bool] = .init(repeating: false, count: s.count + 1)
        
        dp[0] = true
        
        for i in 1...s.count {
            for word in wordDict {
                if word.count <= i {
                    dp[i] = dp[i] || (dp[i-word.count] && String(arr[i-word.count..<i]) == word)
                }
            }
        }
        return dp[s.count]
    }
}






































