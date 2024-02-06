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
        
        let r = test.groupAnagrams(["ac","c"])
        
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
     */
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        let count = strs.count
        var result: [[String]] = .init(repeating: [], count: count)
        var hash: [[String:Bool]] = []
        
        for str in strs {
            
            var contain = false
            var id = 0
            for idx in 0..<hash.count {
                id = idx
                let h = hash[idx]
                var tmpContain = true
                if str == "" {
                    if h[String("")] ?? false {
                        contain = true
                        break
                    }
                } else {
                    if h.keys.count != str.count {
                        break
                    }
                    for w in str {
                        tmpContain = tmpContain && (h[String(w)] ?? false )
                        if w == str.last,
                           tmpContain{
                            contain = true
                            break
                        }
                    }
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
            var tmp:[String:Bool] = [:]
            if str == "" {
                tmp[""] = true
            } else {
                for w in str {
                    tmp[String(w)] = true
                }
            }

            hash.append(tmp)
            result[id] = [str]
        }
        return result.filter({ !$0.isEmpty }).reversed()
        
//        strs =
//        ["ac","c"]
//
//        添加到测试用例
//        输出
//        [["ac","c"]]
//        预期结果
//        [["c"],["ac"]]
        
//        strs =
//        ["ac","c"]
//
//        添加到测试用例
//        输出
//        [["ac","c"]]
//        预期结果
//        [["c"],["ac"]]
    }
    
}
