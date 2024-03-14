//
//  排序.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2024/2/26.
//  Copyright © 2024 蔡浩铭. All rights reserved.
//

import Foundation

class 排序: Do {
    
    static func doSomething() {
        
        let t = 排序()
        
        var tmp = [8,8,7,1,2,3,4,5,6]
        t.quickUpgrade(array: &tmp, start: 0, end: tmp.count-1)
        print(tmp)
    }
    
    
    // MARK: 215. 数组中的第K最大元素
    /*
      第一思路，想着用快排， 排完再去取下标。
     */
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
        var tmp = nums
        return  quickSelect(nums: &tmp, start: 0, end: tmp.count-1, k: k-1)
    }
    
    
    func quickSelect( nums: inout [Int],start: Int, end: Int,k: Int) -> Int {
        if start == end {
            return nums[k]
        }
        let portrait = nums[start]
        var left = start - 1
        var right = end + 1
        while left < right {
            repeat {
                left += 1
            } while nums[left] > portrait
            repeat {
                right -= 1
            } while nums[right] < portrait
            if left < right {
                let tmp = nums[left]
                nums[left] = nums[right]
                nums[right] = tmp
            }
        }
        if k <= right {
            return quickSelect(nums: &nums, start: start, end: right, k: k)
        } else {
            return quickSelect(nums: &nums, start: right+1, end: end, k: k)
        }
        
    }
    
    //MARK: 912. 排序数组
    
    /*
     给你一个整数数组 nums，请你将该数组升序排列。
     */
    
    /*
     思路：
     用的快排，为的是检验自己能不能写出快排
     问题：
     快排在有序倒序的情况下，时间复杂度为O(n2)，因此可以在每次开始计算portrait之前，
     将随机数和最后一个哨兵进行替换，人为打断有序
     */
    func sortArray(_ nums: [Int]) -> [Int] {
        var i = nums;
        quick(array:&i,start:0,end:nums.count-1)
        return i
    }
    
    func quick(array: inout [Int],start: Int, end: Int)  {
        
        guard start >= 0,
              end < array.count,
              end > start else {
            return
        }
        let range = Array(start...end)
        if let i = range.randomElement()  {
            swap(&array, l: i, r: end)
        }
        let p = portrait(array: &array, start: start, end: end)
        
        quick(array: &array, start: start, end: p-1)
        quick(array: &array, start: p+1, end: end)
    }
    
    func portrait( array:inout [Int],start: Int, end: Int) -> Int {
        var s = start-1
        let p = array[end]
        var c = start
        while c < end {
            if array[c] < p {
                s += 1
                swap(&array, l: s, r: c)
            }
            c += 1
        }
        s += 1
        swap(&array, l: s, r: end)
        return s
    }
    
    func swap(_ array: inout[Int] ,l: Int, r: Int) {
        let temp = array[l]
        array[l] = array[r]
        array[r] = temp
    }
    
    // 快排升级版
    func quickUpgrade(array: inout [Int],start: Int, end: Int)  {
        if start >= end {
            return
        }
        var leftPtr = start - 1
        var rightPtr = end + 1
        let portrait = array[(start + end) >> 1]
        while leftPtr < rightPtr {
            repeat {
                leftPtr += 1
            } while array[leftPtr] < portrait
            repeat {
                rightPtr -= 1
            } while array[rightPtr] > portrait
            if leftPtr < rightPtr {
                swap(&array, l: leftPtr, r: rightPtr)
            }
        }
        //要使用rightPtr.因为最终array[leftPtr] >= x，并不一定在左边部分区间
        // 如1,2,3,3,4,5
        quickUpgrade(array: &array, start: start, end: rightPtr)
        quickUpgrade(array: &array, start: rightPtr+1, end: end)
    }
}
