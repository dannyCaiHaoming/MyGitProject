//
//  数组.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2021/8/25.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

import Foundation

/*
 1.数组问题，一般遇到O(n)，就是一次遍历完成，极有可能是用双指针。
 */

class 数组: Do {
    static func doSomething() {
        
        let test = 数组()
        
//        print(test.threeSum([0,0,0,0]))
        
//        print(test.jump( [2,3,1,1,4]))
        
//        var i = [5,2,3,1]
//        test.quick(array: &i, start: 0, end: i.count-1)
//        print(i)
        
//        print(test.trap([0,1,0,2,1,0,1,3,2,1,2,1]))
        
//        print(test.findMedianSortedArrays([1,2], [3,4]))
        
//        var i = [0]
//        test.merge(&i, 0, [1], 1)
//        print(i)
        
//        print(test.threeSum([-1,0,1,2,-1,-4]))
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
    
    //MARK: 4. 寻找两个正序数组的中位数
    /*
     两个数组都是有序的，那可以先对数组进行合并排序。然后取中间
     
     解答： 二分法
     */
    
    
    
    //MARK: 剑指 Offer 03. 数组中重复的数字
    /*
     在一个长度为 n 的数组 nums 里的所有数字都在 0～n-1 的范围内。数组中某些数字是重复的，但不知道有几个数字重复了，也不知道每个数字重复了几次。请找出数组中任意一个重复的数字。

     */
    func findRepeatNumber(_ nums: [Int]) -> Int {
        var dict:[Int:Int] = [:]
        for n in nums {
            if let i = dict[n] {
                dict[n] = i+1
                return n
            }else {
                dict[n] = 1
            }
        }
        return 0
    }
    
    //MARK: 42. 接雨水
    /*
     给定 n 个非负整数表示每个宽度为 1 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。
     */
    /*
     思路： 对每一个坑位，往左，往右找第一个比自己高的，如果找不到即没有。同时找到左右都有比自己高的，
     取最小值减去当前自己的值，则为可以装入的水。
     */
    func trap(_ height: [Int]) -> Int {
        var result = 0
        for i in 0..<height.count {
            let current = height[i]
            var l = i-1
            var lMax = -1
            var r = i+1
            var rMax = -1
            while l >= 0 {
                if height[l] > current {
                    lMax = max(lMax, height[l])
                }
                l -= 1
            }
            while r < height.count {
                if height[r] > current {
                    rMax = max(rMax, height[r])
                }
                r += 1
            }
            if lMax > current && rMax > current {
                result += min(lMax, rMax)-current
            }
        }
        return result
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
    
    
    //MARK: 4. 寻找两个正序数组的中位数
    /*
     给定两个大小分别为 m 和 n 的正序（从小到大）数组 nums1 和 nums2。请你找出并返回这两个正序数组的 中位数 。
     */
    /*
     思路：用归并排序，将两个数组合并成有序数组，然后根据是奇偶长度，获取中位数下标值
     */
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        var temp = nums1 + nums2
        temp.sort()
        let count = temp.count
        if count&1 == 1 {
            //
            return Double(temp[count/2])
        }else {
            let r:Double = Double(temp[count/2] + temp[count/2-1])
            return r/2
        }
    }
    
    
    
    //MARK: 15. 三数之和
    /*
     给你一个包含 n 个整数的数组 nums，判断 nums 中是否存在三个元素 a，b，c ，使得 a + b + c = 0 ？请你找出所有和为 0 且不重复的三元组。
     注意：答案中不可以包含重复的三元组。
     */
    /*
     暴力破解，从首位开始，每次从当前位的下一位，同时从末尾开始，找到一个存在为三位数和为0的。
     先将数组排序，然后遍历当前等于上一个的时候就不需要再遍历，就跳过。当前值大于0页不需要了.
     
     */
    func threeSum(_ nums: [Int]) -> [[Int]] {
        let temp = nums.sorted()
        var result: [[Int]] = []
        let count = temp.count
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
                /*
                 
                 */
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
    
    
    
    //MARK: 75. 颜色分类
    /*
     给定一个包含红色、白色和蓝色、共 n 个元素的数组 nums ，原地对它们进行排序，使得相同颜色的元素相邻，并按照红色、白色、蓝色顺序排列。
     我们使用整数 0、 1 和 2 分别表示红色、白色和蓝色。
     必须在不使用库的sort函数的情况下解决这个问题。

     示例 1：

     输入：nums = [2,0,2,1,1,0]
     输出：[0,0,1,1,2,2]
     
     思路：三指针方式。
     左边指针用来指示0交换的位置。右边指针用来指示2交换的位置。还需要一个遍历指针。
     多指针题目可以自己画图进行演绎。
     left，idx，right
     0： 将idx下标值与left的交换，left的下标值只有是0，或者1，两种情况都需要idx++
     1： 直接将idx++，因为左边的值已经是遍历好，只有0，1
     2： 将idx下标值与right交换，right--，当时交换后的idx，可能是0，1，2，因此还需要重新处理，idx就不要加1
     */
//    void sortColors(int* nums, int numsSize){
//        int left = 0,idx = 0,right = numsSize-1;
//        while (idx <= right) {
//            int value = nums[idx];
//            if (value == 2) {
//                array_swap(nums, idx, right);
//                right--;
//            }else if (value == 0) {
//                array_swap(nums, idx, left);
//                left++;
//                idx++;
//            }else {
//                idx++;
//            }
//        }
//    }
    
    
    //MARK: 88. 合并两个有序数组
    /*
     给你两个按 非递减顺序 排列的整数数组 nums1 和 nums2，另有两个整数 m 和 n ，分别表示 nums1 和 nums2 中的元素数目。
     请你 合并 nums2 到 nums1 中，使合并后的数组同样按 非递减顺序 排列。
     */
    /*
     思路: 从后向前，一个指针指向最后面可以插入的位置，两个指针分别指向两个数组末尾，比较哪个大，插入哪个。
     由于如果nums1有剩余，那不用管，肯定是都是比nums2小的。
     如果剩余的是nums2，则需要依次插入到num1剩余位置上。
     */
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var m = m-1
        var n = n-1
        var end = nums1.count-1
        while end >= 0 && m >= 0 {
            if m >= 0 && n >= 0 {
                if nums1[m] > nums2[n] {
                    nums1[end] = nums1[m]
                    m -= 1
                }else {
                    nums1[end] = nums2[n]
                    n -= 1
                }
            }
            end -= 1
        }
        while n >= 0  {
            nums1[end] = nums2[n]
            n -= 1
            end -= 1
        }
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
    
    
    
    //MARK:   面试题 16.16. 部分排序
    /*
     给定一个整数数组，编写一个函数，找出索引m和n，只要将索引区间[m,n]的元素排好序，整个数组就是有序的。注意：n-m尽量最小，也就是说，找出符合条件的最短序列。函数返回值为[m,n]，若不存在这样的m和n（例如整个数组是有序的），请返回[-1,-1]。

     示例：

     输入： [1,2,4,7,10,11,7,12,6,7,16,18,19]
     输出： [3,9]
     
     思路：
     从左到右，应该是要小到大，遇到第一个不符合变大的就是m。
     从右到左，应该是大到小，遇到第一个不符合变小的的就是n
     
     从左到右找，只要是比当前顺序最大值要小的值，都算是顺序错乱了
     从右到左找，只要是比当前顺序最小值要大的值，都算是顺序错乱
     
     
     答案：

     这里没有说升序还是降序，这里假设为升序，思路转换为：

     找到左右两边需要被移动的l和r，那么它们需要满足什么呢？
     对于l， 是需要找到它的右侧有元素比它小，那么按照升序排列，这里就需要把最小值排序；就是从右向左遍历，记录当前最小值，和当前点比较，一旦大于，则说明需要移动
     对于r，类似的道理，就是要找到左侧比它大的元素，则需要把大的元素移动过来；这里采用从左往右的遍历方式，记录最大值，和当前点比较，一旦小于，则说明需要移动
     */
//    int* subSort(int* array, int arraySize, int* returnSize){
//        *returnSize = 2;
//        int *res = malloc(sizeof(int) * 2);
//        res[0] = -1;
//        res[1] = -1;
//        if (array == NULL || arraySize == 0) {
//            return res;
//        }
//        if (arraySize == 1) {
//            return res;
//        }
//        int m = 0;
//        int n = arraySize-1;
//        int max = array[m];
//        for (int i = 0; i < arraySize; i++) {
//            if (array[i] >= max) {
//                max = array[i];
//            }else {
//                m = i;
//            }
//        }
//        int min = array[arraySize-1];
//        for (int i = arraySize-1; i >= 0; i--) {
//            if (array[i] <= min) {
//                min = array[i];
//            }else {
//                n = i;
//            }
//        }
//
//        if (n <= m  ) {
//            res[0] = n;
//            res[1] = m;
//        }
//        return res;
//    }
}
