//
//  main.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2019/4/2.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

import Foundation

extension Int {
	func divmod(dividend:Int) -> ((quotient:Int,remainder:Int)) {
		return (self/dividend,self%dividend)
	}
}


public class ListNode {
	public var val: Int
	public var next: ListNode?
	public init(_ val: Int) {
		self.val = val
		self.next = nil
	}
	
	class func changeIntArrayToListNode(array:[Int])->ListNode?{
		var node:ListNode? = nil
		if array.count != 0 {
			node = ListNode.init(array[0])
			var next = node
			for index in 1..<array.count{
				let temp = ListNode.init(array[index])
				next?.next = temp
				next = temp
			}
			next?.next = nil
		}
		return node
	}
	
}

public class Node {
    public var val: Int
    public var left: Node?
    public var right: Node?
    public var next: Node?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
        self.next = nil
    }
}


public class DulNode: Hashable {
    public static func == (lhs: DulNode, rhs: DulNode) -> Bool {
        return lhs.key == rhs.key && lhs.val == rhs.val && lhs.next == rhs.next && lhs.prior == rhs.prior
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public var key: Int
    public var val: Int
    public var next: DulNode?
    public var prior: DulNode?
    
    public init(_ val: Int,_ key: Int) {
        self.key = key
        self.val = val
        self.next = nil
        self.prior = nil
    }
}





public struct Stack<T>{
	private var elements:[T] = []
	
	public mutating func push(_ element: T){
		elements.append(element)
	}
	
	public mutating func pop() -> T?{
		return elements.popLast()
	}
	
	public func peek() ->T?{
		return elements.last
	}
	
	public var isEmpty: Bool{
		return elements.isEmpty
	}
	
	public var count:Int{
		return elements.count
	}
}

extension String {
	func mySubString(to index: Int) -> String {
		return String(self[..<self.index(self.startIndex, offsetBy: index)])
	}
	
	func mySubString(from index: Int) -> String {
		return String(self[self.index(self.startIndex, offsetBy: index)...])
	}
}


// MARK: ------- 数组

//MARK: 1.两数之和
/*
 给定一个整数数组 nums 和一个整数目标值 target，请你在该数组中找出 和为目标值 target  的那 两个 整数，并返回它们的数组下标。

 你可以假设每种输入只会对应一个答案。但是，数组中同一个元素在答案里不能重复出现。

 你可以按任意顺序返回答案。
 
 示例 1：
 输入：nums = [2,7,11,15], target = 9
 输出：[0,1]
 解释：因为 nums[0] + nums[1] == 9 ，返回 [0, 1] 。
 
 分析：
 只需要数组里面两个数的和为target，那么，可以每个逐一判断，拿了第一位，就从第二位开始到结尾，判断是否有和为target。

 */

/*
 1.没审题好
 */
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {

    var dict:[Int:Int] = [:]
    
    for index in 0...nums.count-1 {
        let num = nums[index]
        if dict[num] == nil {
            dict[num] = index
            if let i = dict[target-num],
               i != index { //处理这种特例 3,2,4
                return [i,index]
            }
        }else if let i = dict[num],
                 num + num == target {  // 处理 3，3这种特例
            return [i,index]
        }
    }
    return []
}


//MARK: 560. 和为K的子数

/*
 给定一个整数数组和一个整数 k，你需要找到该数组中和为 k 的连续的子数组的个数。
 
 输入:nums = [1,1,1], k = 2
 输出: 2 , [1,1] 与 [1,1] 为两种不同的情况。
 */

//MARK: 974. 和可被 K 整除的子数组

/*
 给定一个整数数组 A，返回其中元素之和可被 K 整除的（连续、非空）子数组的数目。
 
 输入：A = [4,5,0,-2,-3,1], K = 5
 输出：7
 解释：
 有 7 个子数组满足其元素之和可被 K = 5 整除：
 [4, 5, 0, -2, -3, 1], [5], [5, 0], [5, 0, -2, -3], [0], [0, -2, -3], [-2, -3]

 */



/*
 1. 这题没有特别好的想法 ----  看了答案后 ------ <前缀和>思想  ---- 看完前缀和之后再做，又发现自己审题漏了一个连续非空的条件又把自己劝退了。
 2. 看了答案还搞了很久。。。。  发现自己对于一些前提条件没有理解好。  前缀和  每个数得到的时候前面之和，当你presum-k，其实假设的是后面一段和是k，那么如果能有一个presum-k是前端匹配的话
 那么就证明当前的前缀和能匹配为{presum-k}{k}=presum。其实就是这么简单的道理。
 
 */



func subarraysDivByK(_ nums: [Int], _ k: Int) -> Int {
    
    var max = 0
    var result: [Int] = Array.init(repeating: 0, count: nums.count+1)
    var count = 0
    for i in 0..<nums.count {
        result[i] = 0
        for j in i..<nums.count {
            result[j+1] = nums[j] + result[j]
            if result[j+1] % k == 0 {
                count += 1
            }
        }
    }

    
    
    return count
    
    

}


//MARK: 724.  寻找数组的中心下标

/*
 给你一个整数数组 nums ，请计算数组的 中心下标
 
 输入：nums = [1, 7, 3, 6, 5, 6]
 输出：3
 解释：
 中心下标是 3 。
 左侧数之和 sum = nums[0] + nums[1] + nums[2] = 1 + 7 + 3 = 11 ，
 右侧数之和 sum = nums[4] + nums[5] = 5 + 6 = 11 ，二者相等。
 
 */

func pivotIndex(_ nums: [Int]) -> Int {

    let sum = nums.reduce(0) { r, next in
        return r+next
    }
    
    var presum = 0
    
    for i in 0..<nums.count {
        if sum-nums[i]-presum == presum {
            return i
        }
        presum += nums[i]
    }
    
    return -1
}





//MARK: 3.无重复字符的最长子串
func lengthOfLongestSubstring(_ s: String) -> Int {
	var longest = ""
	var temp = ""
	for char in s.characters {
		if !temp.contains(char){
			temp.append(char)
		}else{
			if temp.count > longest.count{
				longest = temp
			}
			//寻找重复的子串并删除
			var reIndex = temp.firstIndex(of: char)
			reIndex = temp.index(reIndex!, offsetBy: 1)
			
			temp = temp.substring(from: reIndex!)
			
			temp.append(char)
		}
	}
	if temp.count > longest.count{
		longest = temp
	}

	return longest.count
}





///




//MARK: 7.整数翻转
func reverse(_ x: Int) -> Int {
	
	var newX = x
	
	var rev = 0
	while newX != 0 {
		let pop = newX % 10
		newX /= 10
		if rev > Int32.max / 10 || (rev == (Int32.max / 10) && pop > 7) {
			return 0
		}
		if rev < Int32.min / 10 || (rev == (Int32.min / 10) && pop < -8){
			return 0
		}
		rev = rev * 10 + pop
	}
	return rev
}


//MARK:8.字符串转换整数 (atoi)
func myAtoi(_ str: String) -> Int {
	let newStr = str.trimmingCharacters(in: [" "])
	if newStr.count <= 0 {
		return 0
	}
	let array = Array<Character>(newStr)
	
	let firstChar = array[0]
	
	var sign = 1
	var start = 0
	var res = 0
	
	if firstChar == "+" {
		sign = 1
		start += 1
	}else if (firstChar == "-"){
		sign = -1
		start += 1
	}
	
	for i in start..<array.count {
		if array[i] >= "0" && array[i] <= "9" {
			if sign == 1 && res > (Int32.max-Int32(String(array[i]))!)/10 {
				return Int(Int32.max)
			}
			if sign == -1 && res > (Int32.max-Int32(String(array[i]))!)/10{
				return Int(Int32.min)
			}
			res = res * 10 + Int(String(array[i]))!
		}else{
			return res * sign
		}
	}
	
	return res * sign
	
}


//MARK: 9.回文数
func isPalindrome(_ x: Int) -> Bool {
	if x < 0 || (x % 10 == 0 && x != 0){
		return false
	}
	
	
	let reverse_ = reverse(x)
	if reverse_ == x {
		return true
	}
	return false
}


//MARK:11盛最多水的容器
func maxArea(_ height: [Int]) -> Int {
	//先找开始
	
	if height.count == 2 {
		return min(height[0],height[1] )
	}
	
	var start = 0
	var end = height.count - 1
	
	var result = 0
	
	while start < end {
		result = max(result, min(height[start], height[end]) * (end-start))
		
		if height[start] < height[end]{
			start += 1
		}else {
			end -= 1
		}
	}
	
	return result
	
}
 
//MARK: 13.罗马数字转整数
func romanToInt(_ s: String) -> Int {
	let dict:[String:Int] = ["I" : 1,
							 "V" : 5,
							 "X" : 10,
							 "L" : 50,
							 "C" : 100,
							 "D" : 500,
							 "M" : 1000
	]
	if s.count < 2 {
		return dict[s]!
	}
	
	var result = 0
	for index in 0...s.count - 1 {
		
		let currentIndex = s.index(s.startIndex, offsetBy: index)
		let currentString :String = String(s[currentIndex])
		let current = dict[currentString]!
		
		if index + 1 < s.count{
			
			let nextIndex = s.index(s.startIndex, offsetBy: index + 1)
			
			
			let nextString :String = String(s[nextIndex])
			
			
			let next = dict[nextString]!
			
			if current < next {
				result -= current
			}else{
				result += current
			}
		}
		else if index + 1 == s.count{
			result += current
		}
	}
	return result
}

//MARK: 14.最长公共前缀
func longestCommonPrefix(_ strs: [String]) -> String {
	
	if strs.count == 0 || strs[0] == "" {
		return ""
	}
	
	
	let matchString = strs[0]
	for wordCount in 0...matchString.count - 1{
		for index in 0...strs.count - 1 {
			
			
			
			let currentIndex = matchString.index(matchString.startIndex, offsetBy: wordCount)
			
			let currentMatchString = strs[index]
			let matchCurrentIndex = currentMatchString.index(currentMatchString.startIndex, offsetBy: wordCount)
			if wordCount == strs[index].count || currentMatchString[matchCurrentIndex] != matchString[currentIndex]{
				return matchString.mySubString(to: wordCount)
			}
			
		}
	}
	
	return strs[0]
}

//MARK: 14.最长公共前缀 二分查找方法
func longestCommonPrefix2(_ strs: [String]) -> String {
	if strs.count == 0 || strs[0] == "" {
		return ""
	}
	
	
	var minLen = Int.max
	for str in strs {
		minLen = min(minLen, Int(str.count))
	}
	
	var low = 1;
	var high = Int(minLen)
	
	while low <= high {
		let mid = (low + high) / 2
		if longestCommonPrefix2_Support(strs, mid){
			low = mid + 1
		}else{
			high = mid - 1
		}
	}
	
	return strs[0].mySubString(to: (low + high) / 2)
	
}

func longestCommonPrefix2_Support(_ strs: [String],_ length:Int) -> Bool {
	let subString = strs[0].mySubString(to: length)
	if strs.count > 1 {
		for i in 1...strs.count - 1 {
			if !strs[i].starts(with: subString){
				return false
			}
		}
	}
	return true
}


//MARK: 15. 三数之和
func threeSum(_ nums: [Int]) -> [[Int]] {
	if nums.count < 3 {
		return []
	}
	
	var result:[[Int]] = []
	let newNums = nums.sorted()
	let count = newNums.count
	
	for i in 0..<count-2 {
		if newNums[i] > 0 {
			break
		}
		if i > 0 &&  newNums[i] == newNums[i-1] {
			continue
		}
		
		var j = i+1
		var k = newNums.count - 1
		
		while j < k {
			let sum = newNums[i] + newNums[j] + newNums[k]
			if sum == 0 {
				result.append([newNums[i] , newNums[j] , newNums[k]])
				while j < k && newNums[j] == newNums[j+1] {
					j += 1
				}
				while j < k && newNums[k] == newNums[k-1] {
					k -= 1
				}
				j += 1
				k -= 1
			}
			else if (sum < 0) {
				j += 1
			}
			else if (sum > 0){
				k -= 1
			}
		}

	}
	return result
	
}


//MARK:16.最接近的三数之和
func threeSumClosest(_ nums: [Int], _ target: Int) -> Int {
	if nums.count < 3 {
		return 0
	}
	
	let newNums = nums.sorted()
	
	var close = newNums[0] + newNums[1] + newNums[2]
	
	for i in 0..<newNums.count-2 {
		

		var start = i+1
		var end = newNums.count-1
		
		while start < end {
			let sum = newNums[i] + newNums[start] + newNums[end]
			
			if abs(sum-target) < abs(close-target) {
				close = sum
			}
			if sum > target {
				end -= 1
			}else{
				start += 1
			}
		}
		
		
	}
	
	
	return close
	
}



//MARK:19. 删除链表的倒数第N个节点
///给定一个链表，删除链表的倒数第 n 个节点，并且返回链表的头结点。
func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
	//快慢指针
	if head == nil {
		return nil
	}
	
	var result = head
	var fast:ListNode? = head
	var n_ = 0
	while n_ <= n  && fast != nil{
		fast = fast?.next
		n_ += 1
	}
 
	if n_ < n {
		//n大于链表长度
		return head
	}
	
	if fast == nil && n_ == n {
		//移除表头情况
		return head?.next
	}
	
	while fast != nil {
		fast = fast?.next
		result = result?.next
	}
	

	guard let temp = result else {
		return nil
		
	}
	temp.next = temp.next?.next
	
	

	
	return head

}



//MARK: 20.有效括号
func isValid(_ s: String) -> Bool {
	
	if s.count == 0 {
		return true
	}
	
	if s.count == 1 {
		return false
	}
	
	var stack1 = Stack<Character>.init()
	var stack2 = Stack<Character>.init()
	
	for char in s{
		stack1.push(char)
	}
	
	
	while true  {
		
		if  (stack2.count + stack1.count) < 2 || stack1.isEmpty{
			break;
		}
		
		let back = stack1.pop()
		let front = stack1.peek()
		
		if !stack2.isEmpty && isSymbolCompare(front: String(back!), back: String(stack2.peek()!)){
			stack2.pop()
			continue
		}
		
		if stack1.isEmpty {
			break;
		}
		
		if !isSymbolCompare(front: String(front!), back: String(back!)) {
			stack2.push(back!)
		}else{
			stack1.pop()
		}
		
	}
	
	return stack2.isEmpty && stack1.isEmpty
	
	
}


func isSymbolCompare(front:String,back:String) -> Bool {
	let symbols = ["{" : "}",
				   "[" : "]",
				   "(" : ")"
	]
	
	if symbols[front] == back {
		return true
	}
	return false
}

func isValid1(_ s: String) -> Bool {
	
	//        if s.count == 0 {
	//            return true
	//        }
	
	let map:[Character:Character] = ["}" : "{",
									 "]" : "[",
									 ")" : "("
	]
	
	
	var stack:Stack = Stack<Character>.init()
	
	for i in 0..<s.count {
		let index = s.index(s.startIndex, offsetBy: i)
		let word = s[index]
		if map.keys.contains(word){
			let top = stack.isEmpty ? "#" : stack.pop()
			if map[word] != top{
				return false
			}
		}else{
			stack.push(word)
		}
	}
	return stack.isEmpty
}

//MARK: 21.合并两个有序链表
func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
	
	
	let head = ListNode.init(0)
	
	var cur = head
	
	var tempL1 = l1
	var tempL2 = l2
	
	while tempL1 != nil && tempL2 != nil {
		if tempL1!.val <= tempL2!.val {
			cur.next = tempL1
			cur = cur.next!
			tempL1 = tempL1!.next
		}else{
			cur.next = tempL2
			cur = cur.next!
			tempL2 = tempL2!.next
		}
	}
	
	if tempL1 != nil {
		cur.next = tempL1
	}else{
		cur.next = tempL2
	}
	
	return head.next
	
}


//MARK:24. 两两交换链表中的节点
///给定一个链表，两两交换其中相邻的节点，并返回交换后的链表
func swapPairs(_ head: ListNode?) -> ListNode? {
    if head == nil || head?.next == nil {
        return head
    }
    var newHead:ListNode? = ListNode(-1)
    newHead!.next = head
    
    let start = newHead
    
    while newHead?.next != nil && newHead?.next?.next != nil {
        let next = newHead?.next?.next?.next
        
        let first = newHead?.next
        let second = newHead?.next?.next
        
        newHead!.next = second
        second?.next = first
        
        first?.next = next
        
        newHead = first
    }
    
    return start?.next
}

//MARK: 26.删除排序数组中的重复项
func removeDuplicates(_ nums: inout [Int]) -> Int {
	var dict:[Int : Int] = [:]
	
	var index = 0
	var j = 0
	
	while index < nums.count {
		
		while (index + j < nums.count && dict.keys.contains(nums[index + j])){
			j += 1
		}
		
		if index + j >= nums.count {
			break
		}
		
		dict[nums[index + j]] = 1
		
		if j != 0{
			
			let temp = nums[index]
			nums[index] = nums[index + j]
			nums[index + j] = temp
			
			
		}
		
		
		
		index += 1
	}
	
	
	return dict.keys.count
}

func removeDuplicates1(_ nums: inout [Int]) -> Int {
	if nums.count == 0 {
		return 0
	}
	var front = 0
	for back in 1..<nums.count{
		if nums[front] != nums[back]{
			front += 1
			nums[front] = nums[back]
		}
	}
	return front+1
}

//MARK: 27.移除元素
func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
	if nums.count == 0{
		return 0
	}
	
	var count = 0
	
	var front = 0
	var back = 0
	while back < nums.count && front < nums.count  {
		if nums[front] != val{
			
			front += 1
			back = front
			count += 1
			
		}else{
			while back < nums.count - 1 && nums[back] == val   {
				back += 1
			}
			
			if nums[back] == val {
				break
			}
			
			let temp = nums[front]
			nums[front] = nums[back]
			nums[back] = temp
			front += 1
			
			count += 1
		}
	}
	
	return count
}


//MARK: 28.实现strStr()  就是字符串匹配
func strStr(_ haystack: String, _ needle: String) -> Int {
	
	if  needle.count == 0 {
		if haystack.count == 0 {
			return 0
		}
		return 0
	}
	
	var j = 0
	
	for i in 0..<haystack.count {
		
		var temp = i
		
		while  j < needle.count {
			
			if temp >= haystack.count {
				return -1
			}
			
			let iIndex = haystack.index(haystack.startIndex, offsetBy: temp)
			let jIndex = needle.index(needle.startIndex, offsetBy: j)
			
			if haystack[iIndex] == needle[jIndex]{
				
				if j == needle.count - 1{
					return i
				}
				
				temp += 1
				j += 1
			}else{
				j = 0
				break
			}
			
		}
		
		
	}
	
	
	
	
	return -1
}

//MARK:  KMP算法实现
func getNextArray(matchStr:String) -> [Int] {
	var nextArray = Array.init(repeating: -1, count: matchStr.count)
	
	var k = -1 //当前next数组下标
	//        var i = 0 //遍历匹配串
	
	for i in 1..<matchStr.count {
		
		
		
		while k > -1 {
			let iIndex = matchStr.index(matchStr.startIndex, offsetBy: i)
			let kIndex = matchStr.index(matchStr.startIndex, offsetBy: k + 1)
			
			if matchStr[iIndex] != matchStr[kIndex]{
				k = nextArray[k]
			}else{
				break
			}
		}
		
		let iIndex = matchStr.index(matchStr.startIndex, offsetBy: i)
		let kIndex = matchStr.index(matchStr.startIndex, offsetBy: k + 1)
		
		if matchStr[iIndex] == matchStr[kIndex]{
			k += 1
		}
		nextArray[i] = k
	}
	
	return nextArray
}


func
	
	KMP(_ haystack: String, _ needle: String) -> Int {
	var nextArr:[Int] = []
	if needle.count == 0 {
		return 0
	}
	
	nextArr = getNextArray(matchStr: needle)
	
	
	var i = 0
	var j = 0
	
	
	
	while i <= haystack.count - 1 && j <= needle.count - 1 {
		let iIndex = haystack.index(haystack.startIndex, offsetBy: i)
		let jIndex = needle.index(needle.startIndex, offsetBy: j)
		if haystack[iIndex] == needle[jIndex] {
			i += 1
			j += 1
			continue
		}else{
			
			if j > 0 && nextArr[j - 1] >= 0 {
				i -= (nextArr[j - 1] + 1)
				j = 0
			}else {
				i += 1
				j = 0
			}
			
			
		}
	}
	
	
	if i <= haystack.count  && j == needle.count  {
		return i - needle.count
	}
	
	return -1
	
}



//MARK:33. 搜索旋转排序数组
func search(_ nums: [Int], _ target: Int) -> Int {
	
	var start = 0
	var end = nums.count-1
	
	while end > start {
		let mid = (start + end) / 2
		
		if nums[0] <= nums[mid] && (target > nums[mid] || target < nums[0]) {
			start = mid + 1
		}else if target > nums[mid] && target < nums[0] {
			start = mid + 1
		}else {
			end = mid
		}
	}
	
	return start == end && nums[start] == target ? start : -1

}

func search2(_ nums: [Int], _ target: Int) -> Int {
	
	//思路，先二分查找出旋转位置
	
	if nums.count == 0 {
		return -1
	}
	if nums.count == 1 {
		return nums[0] == target ? 0 : -1
	}
	
	let start = 0
	let mid = search2Core(nums)
	let end = nums.count - 1
	
	if mid == 0 {
		if nums[start] > target || target > nums[end] {
			return -1
		}
		return search2Sort(nums, start, end,target)
	}
	
	if target > nums[mid-1]  {
		return -1
	}
	
	if target >= nums[start] && target <= nums[mid-1]  {
		return search2Sort(nums, start, mid, target)
	}
	if target <= nums[end] && target >= nums[mid] {
		return search2Sort(nums, mid, end, target)
	}
	
	
	return -1
	
}

func search2Core(_ nums: [Int]) -> Int{
	var start = 0
	var end = nums.count - 1
	
	var mid = start
	
	while nums[start] >= nums[end] {
		if end - start == 1 {
			mid = end
			break
		}
		mid = (start + end)/2
		if nums[mid] >= nums[start] {
			start = mid
		}else if nums[mid] <= nums[end]{
			end = mid
		}
	}
	return mid
}

func search2Sort(_ nums:[Int],_ start:Int,_ end:Int,_ target:Int) -> Int {
	var s = start
	var e = end
	var mid = s
	while e >= s {
		mid = (s + e)/2
		if nums[mid] == target {
			return mid
		}
		if nums[mid] > target {
			e = mid-1
		}else{
			s = mid+1
		}
	}
	
	return -1
}





//MARK: 35.搜索插入位置
func searchInsert(_ nums: [Int], _ target: Int) -> Int {
	//        if nums.count == 0 {
	//            return 0
	//        }
	//        if nums.count == 1 {
	//            if nums[0] > target{
	//                return 0
	//            }else{
	//                return 1
	//            }
	//        }
	
	var left = 0
	var right = nums.count
	
	
	while right > left  {
		
		let mid = left + (right - left) / 2
		
		if target < nums[mid] {
			right = mid
		}else if target > nums[mid]{
			left = mid + 1
		}else{
			return mid
		}
	}
	
	
	
	
	return left
}


//59. 螺旋矩阵 II
///给定一个正整数 n，生成一个包含 1 到 n2 所有元素，且元素按顺时针顺序螺旋排列的正方形矩阵。
func generateMatrix(_ n: Int) -> [[Int]] {
    var result:[[Int]] = []
    for _ in 0..<n {
        var row:[Int] = []
        for _ in 0..<n {
            row.append(0)
        }
        result.append(row)
    }
    
    var count = 0
    
    var startRow = 0
    var endRow = n-1
    var startColumn = 0
    var endColumn = n-1
    
    while true{
        
        if !(endRow >= startRow && endColumn >= startColumn){
            break
        }
        
        //列 左到右
        for i in startColumn...endColumn {
            count += 1
            result[startRow][i] = count
        }
        
        startRow += 1
        
        if !(endRow >= startRow && endColumn >= startColumn){
            break
        }
        
        
        //行 上到下
        for i in startRow...endRow {
            count += 1
            result[i][endColumn] = count
        }
        
        
        endColumn -= 1
        
        if !(endRow >= startRow && endColumn >= startColumn){
            break
        }
        
        //列 右到左
        for i in (startColumn...endColumn).reversed() {
            count += 1
            result[endRow][i] = count
        }
        
        endRow -= 1
        
        if !(endRow >= startRow && endColumn >= startColumn){
            break
        }
        
        //行 下到上
        for i in (startRow...endRow).reversed(){
            count += 1
            result[i][startColumn] = count
        }
        
        startColumn += 1
    }
    
    
    return result
}



//MARK:61. 旋转链表
///给定一个链表，旋转链表，将链表每个节点向右移动 k 个位置，其中 k 是非负数。
func rotateRight(_ head: ListNode?, _ k: Int) -> ListNode? {
    if k == 0 {
        return head
    }
    if head == nil {
        return nil
    }
    
    var count = 0
    var newHead = head
    
    while count < k && newHead != nil {
        count += 1
        newHead = newHead?.next
    }
    
    if newHead == nil && k % count == 0 {
        return head
    }
    
    if count < k {
        count = k % count
    }
    
    var slow = head
    newHead = head
    for _ in 0..<count {
        newHead = newHead?.next
    }
    while slow != nil && newHead != nil {
        if newHead?.next == nil {
            let temp = slow?.next
            slow?.next = nil
            slow = temp
        }else{
            slow = slow?.next
        }
        
        newHead = newHead?.next

    }
    
    let start = slow
    
    while slow?.next != nil {
        slow = slow?.next
    }
    slow?.next = head
    
    return start
}


//MARK:62. 不同路径
/*一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为“Start” ）。
机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为“Finish”）。
问总共有多少条不同的路径？
*/
func uniquePaths(_ m: Int, _ n: Int) -> Int {
    
    if m == 1 {
        return 1
    }
    
    if n == 1 {
        return 1
    }
    
    return uniquePaths(m-1, n) + uniquePaths(m, n-1)
}

func uniquePaths2(_ m: Int, _ n: Int) -> Int {
    
    var result:[[Int]] = []
    for _ in 0..<m {
        var row:[Int] = []
        for _ in 0..<n {
            row.append(0)
        }
        result.append(row)
    }
    
    for i in 0..<m {
        result[i][0] = 1
    }
    for j in 0..<n {
        result[0][j] = 1
    }
    
    for i in 1..<m {
        for j in 1..<n {
            result[i][j] = result[i-1][j] + result[i][j-1]
        }
    }
    return result[m-1][n-1]
    
}



//MARK:81. 搜索旋转排序数组 II
func search3(_ nums: [Int], _ target: Int) -> Bool {
	//思路，先二分查找出旋转位置
	
	if nums.count == 0 {
		return false
	}
	if nums.count == 1 {
		return nums[0] == target ? true : false
	}
	
	let start = 0
	let mid = findMinIndex(nums)
	let end = nums.count - 1
	
	if mid == 0 {
//		return search3Sort(nums, start, end,target)
		for n in nums{
			if n == target {
				return true
			}
		}
		return false
	}
	
	if target > nums[mid-1]  {
		return false
	}
	
	if target >= nums[start] && target <= nums[mid-1]  {
		return search3Sort(nums, start, mid-1, target)
	}
	if target <= nums[end] && target >= nums[mid] {
		return search3Sort(nums, mid, end, target)
	}
	
	
	return false

}

func search3Sort(_ nums:[Int],_ start:Int,_ end:Int,_ target:Int) -> Bool {
	var s = start
	var e = end
	var mid = s
	
	while s <= e {
		if nums[mid] == target {
			return true
		}
		mid = (s + e)/2
		if nums[mid] >= target {
			e = mid-1
		}else{
			s = mid+1
		}
	}
	return nums[mid]==target
}


func findMinIndex(_ nums:[Int]) -> Int {
	
	var start = 0
	var end = nums.count - 1
	
	var mid = start
	
	while nums[start] >= nums[end] {
		if end - start == 1 {
			mid = end
			break
		}
		
		mid = (start + end)/2
		if nums[start] == nums[end] && nums[start] == nums[mid] {
			return findMinIndexCore(nums, start, end)
		}
		
		
		if nums[mid] >= nums[start] {
			start = mid
		}else if nums[mid] <= nums[end]{
			end = mid
		}
	}
	return mid
}

func findMinIndexCore(_ nums:[Int],_ start:Int,_ end:Int) -> Int {
	//寻找最大一位的前面一位
	var min = start
	
	for index in start+1...end{
		if nums[min] > nums[index] {
			min = index
		}
	}
	return min

}


//MARK:82. 删除排序链表中的重复元素 II
func deleteDuplicates1(_ head: ListNode?) -> ListNode? {
	if head == nil {
		return nil
	}
	
	
	let dummy:ListNode? = ListNode.init(-1000)
	dummy?.next = head
	var slow = dummy
	
	var fast = dummy?.next
	
	while fast != nil {
		
		var needNext = false
		while fast?.next != nil && fast?.val == fast?.next?.val {
			needNext = true
			fast = fast?.next
		}
		
		if !needNext {
			slow = slow?.next
		}else{
			slow?.next = fast?.next
		}
		fast = fast?.next
	}
	
	return dummy?.next
	
	
}


//MARK: 83.删除排序链表中重复元素
func deleteDuplicates(_ head: ListNode?) -> ListNode? {
	var dict:[Int:Int] = [:]
	let first = ListNode.init(0)
	first.next = head
	var front = first
	var back = first.next
	while back != nil {
		if !dict.keys.contains(back!.val){
			dict[back!.val] = 1
			front.next = back
			front = back!
			back = back!.next
		}else{
			back = back!.next
			if back == nil {
				front.next = nil
			}
		}
	}
	
	return first.next
}


//MARK: 85 合并两个有序数组
func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
	if m == 0 {
		nums1 = nums2
		return
	}else if n == 0 {
		return
	}
	var total = m + n - 1
	var current_m = m - 1
	var current_n = n - 1
	
	for _ in (0..<total).reversed(){
		
		
		if nums1[current_m] < nums2[current_n] {
			nums1[total] = nums2[current_n]
			current_n -= 1
			
		}else {
			nums1[total] = nums1[current_m]
			current_m -= 1
		}
		total -= 1
		if current_n < 0 || current_m < 0 {
			break
		}
	}
	
	while current_n >= 0 {
		nums1[current_n] = nums2[current_n]
		current_n -= 1
	}
	
}


//MARK: 100 相同的树
func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
	
	if p == nil && q == nil {
		return true
	}
	
	return p?.val == q?.val && (isSameTree(p?.left, q?.left)) && isSameTree(p?.right, q?.right)
	
}


//MARK: 101 对称二叉树
func isSymmetric(_ root: TreeNode?) -> Bool {
	return isSymmetric_Mirror(root1: root, root2: root)
}

func isSymmetric_Mirror(root1:TreeNode?,root2:TreeNode?) -> Bool{
	if root1 == nil && root2 == nil {
		return true
	}
	return root1?.val == root2?.val && isSymmetric_Mirror(root1: root1?.left, root2: root2?.right) && isSymmetric_Mirror(root1: root1?.right, root2: root2?.left)
}

//#104 二叉树的最大深度
func maxDepth(_ root: TreeNode?) -> Int {
	if root == nil {
		return 0
	}
	
	let leftMax = maxDepth(root?.left) + 1
	let rightMax = maxDepth(root?.right) + 1
	
	return leftMax > rightMax ? leftMax : rightMax
	
}

//MARK: 107 二叉树的层次遍历 II
func levelOrderBottom(_ root: TreeNode?) -> [[Int]] {
	
	if root == nil {
		return []
	}
	
	var r:[[Int]] = []
	
	var stack = Stack<TreeNode>.init()
	stack.push(root!)
	
	while stack.peek() != nil {
		var popArray:[Int] = []
		var nodeArray:[TreeNode] = []
		
		while stack.peek() != nil {
			//                popArray.append(stack.pop()!)
			let node = stack.pop()!
			//                popArray.append(node.val)
			popArray.insert(node.val, at: 0)
			//                nodeArray.append(node)
			nodeArray.insert(node, at: 0)
		}
		
		r.insert(popArray, at: 0)
		
		for node in nodeArray {
			if node.left != nil {
				stack.push(node.left!)
			}
			if node.right != nil {
				stack.push(node.right!)
			}
		}
	}
	
	return r
	
}


//MARK: 105 从前序与中序构造二叉树
func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
	if preorder.count == 0 || inorder.count == 0{
		return nil;
	}
	
	let treeNode:TreeNode = TreeNode.init(preorder.first!)
	
	let preArray:NSArray = preorder as NSArray
	let inArray:NSArray = inorder as NSArray
	
	let rootIndex = inArray.index(of: preArray[0])
	let count = preArray.count
	
	//先计算前序的左右子树
	let leftPreTree = preArray.subarray(with: NSRange.init(location: 1, length: rootIndex))
	let leftInTree = inArray.subarray(with: NSRange.init(location: 0, length: rootIndex))
	
	let rightPreTree = preArray.subarray(with: NSRange.init(location: rootIndex + 1, length: count - rootIndex - 1))
	let rightInTree = inArray.subarray(with: NSRange.init(location: rootIndex + 1, length: count - rootIndex - 1))
	
	
	//计算左子树的pre，in数组
	if leftPreTree.count > 0 {
		treeNode.left = buildTree(leftPreTree as! [Int], leftInTree as! [Int])
	}
	
	//计算右子树的pre，in数组
	if rightPreTree.count > 0 {
		treeNode.right = buildTree(rightPreTree as! [Int], rightInTree as! [Int])
	}
	
	return treeNode
	
}


//MARK: 108 将有序数组转换成二叉搜索树
func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
	
	if nums.count == 0 {
		return nil
	}
	
	let mid = nums.count / 2
	let root:TreeNode = TreeNode.init(nums[mid])
	
	var leftNums:[Int] = []
	var rightNums:[Int] = []
	for left in 0..<mid{
		leftNums.append(nums[left])
	}
	if mid + 1 < nums.count{
		for right in mid+1..<nums.count{
			rightNums.append(nums[right])
		}
	}
	
	root.left = sortedArrayToBST(leftNums)
	root.right = sortedArrayToBST(rightNums)
	return root
	
}

//MARK: 110 平衡二叉树
func isBalanced(_ root: TreeNode?) -> Bool {
	
	if root == nil {
		return true
	}
	
	let left = maxDepth(root?.left)
	let right = maxDepth(root?.right)
	if abs(left - right) > 1 {
		return false
	}
	return isBalanced(root?.left) && isBalanced(root?.right)
}


//MARK: 111 二叉树的最小深度
func minDepth(_ root: TreeNode?) -> Int {
	
	if root == nil {
		return 0
	}
	
	var count = 1
	var queue:[TreeNode] = []
	queue.append(root!)
	
	while true && queue.count != 0 {
		
		var remove_nodes:[TreeNode] = []
		remove_nodes.append(contentsOf: queue)
		
		queue.removeAll()
		
		for node in remove_nodes{
			if node.left == nil && node.right == nil {
				return count
			}
			
			if node.left != nil {
				queue.append(node.left!)
			}
			if node.right != nil {
				queue.append(node.right!)
			}
		}
		count += 1
		
	}
	
	return count
	
}


//MARK: 112 路径总和
func hasPathSum(_ root: TreeNode?, _ sum: Int) -> Bool {
	
	if root != nil && root!.val == sum && root?.left == nil && root?.right == nil {
		return true
	}
	
	if root != nil && (root?.left != nil || root?.right != nil){
		return hasPathSum(root?.left, sum - root!.val) || hasPathSum(root?.right, sum - root!.val)
	}
	
	return false
}


//MARK: 121 买卖股票的最佳时机
func maxProfit(_ prices: [Int]) -> Int {
	if prices.count == 0 {
		return 0
	}
	
	var maxProfit = 0
	var min = prices[0]
	var max = prices[0]
	
	for index in 1..<prices.count {
		let current = prices[index]
		
		if current < min && index != prices.count - 1 {
			min = current
			max = current
			continue
		}
		
		if current > max {
			if current - min > maxProfit {
				max = current
				maxProfit = max - min
			}
			continue
		}
	}
	
	
	return maxProfit
}

//MARK: 122 买卖股票的最佳时机 II
func maxProfit2(_ prices: [Int]) -> Int {
	if prices.count == 0 {
		return 0
	}
	
	var maxProfit = 0
	var minIndex = 0
	var maxIndex = 0
	var isFindingMin:Bool = false
	
	for index in 1..<prices.count{
		let current = prices[index]
		
		if current >= prices[maxIndex] {
			isFindingMin = true
			if index == prices.count - 1 {
				maxProfit += current - prices[minIndex]
			}
			
			maxIndex = index
			continue
		}
		
		if isFindingMin && current < prices[maxIndex]{
			maxProfit += prices[maxIndex] - prices[minIndex]
			minIndex = index
			maxIndex = index
			isFindingMin = false
			continue
		}
		
		if current < prices[minIndex]{
			minIndex = index
			maxIndex = index
			isFindingMin = false
			continue
		}
		
		
		
	}
	return maxProfit
	
}

//MARK: 125 验证回文串
func isPalindrome(_ s: String) -> Bool {
	let lowerCase = s.lowercased()
	var newS:String = ""
	
	for char in lowerCase {
		if (char >= "a" && char <= "z") || (char >= "0" && char <= "9") {
			newS.append(char)
		}
	}
	
	let reversedS = String(newS.reversed())
	
	return  reversedS == newS
	
}


//MARK: 136 只出现一次的数字
func singleNumber(_ nums: [Int]) -> Int {
	var result = 0
	for num in nums {
		result ^= num
	}
	return result
}


//#141 环形链表
//    bool hasCycle(struct ListNode *head) {
//
//    }


//MARK:153. 寻找旋转排序数组中的最小值
func findMin(_ nums: [Int]) -> Int {

	if nums.count == 0 {
		return -1
	}
	if nums.count == 1 {
		return nums[0]
	}

	
	var start = 0
	var end = nums.count - 1
	var mid = start
	
	
	while nums[start] > nums[end] {
		
		if end - start == 1 {
			mid = end
			break
		}
		
		mid = (start+end)/2
		if nums[mid] > nums[start] {
			start = mid
		}else if nums[mid] < nums[end]{
			end = mid
		}
	}


	
	return nums[mid]
	
}

//MARK:154. 寻找旋转排序数组中的最小值 II
func findMin2(_ nums: [Int]) -> Int {
	if nums.count == 0 {
		return -1
	}
	if nums.count == 1 {
		return nums[0]
	}
	
	var start = 0
	var end = nums.count - 1
	var mid = start
	
	while nums[start] >= nums[end] {
		
		if end - start == 1 {
			mid = end
			break
		}
		mid = (start + end)/2
		
		if nums[start] == nums[end] && nums[start] == nums[mid] {
			return findMin2Core(nums, start, end)
		}
		
		if nums[mid] >= nums[start] {
			start = mid
		}else if nums[mid] <= nums[end] {
			end = mid
		}
	}
	
	return nums[mid]
}

func findMin2Core(_ nums: [Int] ,_ start:Int, _ end:Int) -> Int {
	var min = nums[start]
	for index in start+1...end {
		if min > nums[index] {
			min = nums[index]
		}
	}
	return min
	
}

//MARK: 167 两数之和II 输入有序数组
func twoSum2(_ numbers: [Int], _ target: Int) -> [Int] {
	var i = 0
	var j = numbers.count-1
	while i != j{
		if numbers[i] + numbers[j] == target {
			return [i+1,j+1]
		}
		if numbers[i] + numbers[j] < target {
			i += 1
			continue
		}
		j -= 1
	}
	return []
}

//MARK: 168 Excel表列名称
func convertToTitle(_ n: Int) -> String {
	
	
	var result = ""
	
	var num = n
	
	while num !=  0 {
		var (n,y) = num.divmod(dividend: 26)
		if y == 0 {
			n -= 1
			y = 26
			
		}
		num = n
		result = String(Character(UnicodeScalar(y + 64)!)) + result
	}
	
	return result
}

//MARK: 169 求众数
func majorityElement(_ nums: [Int]) -> Int {
	
	var max = 0
	var res = 0
	
	var dic :[Int:Int] = [:]
	for num in nums {
		if dic.keys.contains(num) {
			let value = dic[num]!
			dic[num] = value + 1
		}else {
			dic[num] = 1
		}
	}
	
	
	for (key,value) in dic {
		if value > max {
			max = value
			res = key
		}
	}
	return res
}

//MARK: 171 Excel表列序号
func titleToNumber(_ s: String) -> Int {
	/*
	思路：将每一位字符串取出来，然后转成数字第0位乘26的0次方，第1位乘26的1次方...
	*/
	
	var nums:[Int] = []
	
	var res = 0
	
	
	for char in s.unicodeScalars {
		let value = Int(char.value) - 65 + 1
		nums.append(value)
	}
	
	
	
	for i in 0..<nums.count {
		
		res = nums[i] +  26 * res
	}
	
	return res
}

//MARK: 172 阶乘后的零
func trailingZeroes(_ n: Int) -> Int {
	var res = 0
	
	var n_ = n
	
	while n_ >= 5 {
		res += n_/5
		n_ /= 5
	}
	return res
}

//MARK: 189. 旋转数组
func rotate(_ nums: inout [Int], _ k: Int) {
	//
	var newNums:[Int] = nums
	newNums.append(contentsOf: nums)
	
	let move = k % (nums.count)
	
	//        nums = newNums
	
	let startIndex = nums.count - move
	
	let endIndex = startIndex + nums.count - 1
	
	nums = Array(newNums[startIndex...endIndex])
}

func rotate1(_ nums: inout [Int], _ k: Int) {
	for _ in 0..<k {
		var last = nums[nums.count-1]
		var temp:Int
		for i in 0..<nums.count {
			temp = nums[i]
			nums[i] = last
			last = temp
		}
	}
}

//MARK: 198. 打家劫舍
func rob(_ nums: [Int]) -> Int {
	//每次最多可以隔1个跳1个或者跳2个，即每次可以跳2个或者3个。
	//题解：动态规划
	var start = -2
	
	var res = 0
	
	while true {
		if start+3 > nums.count {
			break
			
		}
		let l = nums[start+2]
		let r = nums[start+3]
		if l > r {
			start += 2
			res += l
		} else {
			start += 3
			res += r
		}
	}
	
	return res
}





//MARK: 155 最小栈
class MinStack {
	
	var minStack:Stack<Int>
	var stack:Stack<Int>
	
	/** initialize your data structure here. */
	init() {
		minStack = Stack.init()
		stack = Stack.init()
	}
	
	func push(_ x: Int) {
		if minStack.peek() == nil || minStack.peek()! >= x  {
			minStack.push(x)
		}
		stack.push(x)
	}
	
	func pop() {
		if stack.peek() == minStack.peek() {
			minStack.pop()
		}
		stack.pop()
	}
	
	func top() -> Int {
		return stack.peek()==nil ? 0 : stack.peek()!
	}
	
	func getMin() -> Int {
		return minStack.peek()==nil ? 0 : minStack.peek()!
	}
}



//MARK: 232  用栈实现队列
class MyQueue {
	
	var stackA:Stack<Any>;
	var stackB:Stack<Any>;
	
	
	/** Initialize your data structure here. */
	init() {
		stackA = Stack.init()
		stackB = Stack.init()
	}
	
	/** Push element x to the back of queue. */
	func push(_ x: Int) {
		stackA.push(x)
	}
	
	/** Removes the element from in front of queue and returns that element. */
	func pop() -> Int {
		if !stackB.isEmpty {
			return stackB.pop() as! Int
		}else{
			while !stackA.isEmpty {
				let element = stackA.pop()
				stackB.push(element as Any)
			}
			return stackB.pop() as! Int
		}
	}
	
	/** Get the front element. */
	func peek() -> Int {
		if !stackB.isEmpty {
			return stackB.peek() as! Int
		}else{
			return stackA.peek() as! Int
		}
	}
	
	/** Returns whether the queue is empty. */
	func empty() -> Bool {
		return stackA.isEmpty && stackB.isEmpty
	}
}


//MARK: 343. 整数拆分
func integerBreak(_ n: Int) -> Int {
    if n <= 3 {
        return n-1
    }

    var arr:[Int] = Array(repeating:0,count:n)
    for i in 1...n {
        var temp = 0
        for j in 1..<i {
            if j*(i-j) > arr[i-1-j] * j {
                temp = max(temp, j*(i-j))
            }else {
                temp = max(temp,arr[i-1-j] * j)
            }
        }
        arr[i-1] = temp
    }
    return arr[n-1]
}


//MARK:415. 字符串相加
//func addStrings(_ num1: String, _ num2: String) -> String {
//
//}


//MARK:516. 最长回文子序列
func longestPalindromeSubseq(_ s: String) -> Int {
	if s.count <= 1{
		return s.count
	}
	
	let str = Array<Character>(s)
	
	
	var dp:[[Int]] = []
	
	
	for i in 0..<s.count {
		dp.append([])
		for _ in 0..<s.count {
			(dp[i]).append(0)
		}
	}
	
	for i in (0..<s.count).reversed() {
		(dp[i])[i] = 1
		if i+1 >= s.count {
			continue
		}
		for j in i+1..<s.count {
			if str[i] == str[j] {
				(dp[i])[j] = (dp[i+1])[j-1] + 2
			}else {
				(dp[i])[j] = max((dp[i+1])[j], (dp[i])[j-1])
			}
		}
	}
	
	
	return (dp[0])[s.count-1]
}



//MARK:647. 回文子串
func countSubstrings(_ s: String) -> Int {
	if s.count <= 1{
		return s.count
	}
	
	let str = Array<Character>(s)
	
	var dp:[[Bool]] = []
	
	for i in 0..<s.count {
		dp.append([])
		for _ in 0...i {
			(dp[i]).append(false)
		}
	}
	
	var count = 0
	
	for i in 0..<str.count {
		
		
		
		for j in 0...i {
			
			if i == j {
				(dp[i])[j] = true
				count += 1
				continue
			}
		                         
			if str[j] == str[i] && (i-j <= 1 || (dp[i-1])[j+1] == true) {
				count += 1
				(dp[i])[j] = true
			}
		}
	}
	

	
	return count
	
}


//MARK:905. 按奇偶排序数组
func sortArrayByParity(_ A: [Int]) -> [Int] {
	var B = A
	var i = 0
	for j in i..<A.count {
		if B[j] & 1 !=  1 {
			let temp = B[i]
			B[i] = B[j]
			B[j] = temp
			i += 1
		}
		
	}
	return B
}

//MARK:922. 按奇偶排序数组 II
func sortArrayByParityII(_ A: [Int]) -> [Int] {
	var B = A
	var i = 0
	var j = 1
	
	for num in A {
		if num & 1 == 1 {
			B[j] = num
			j += 2
		}else{
			B[i] = num
			i += 2
		}
	}
	
	

	
	return B
}

//
////a.twoSum([3,2,4], 6)
////let b = a.longestPalindrome("babad")
//let n1 = ListNode.changeIntArrayToListNode(array: [1,2,4])
//let n2 = ListNode.changeIntArrayToListNode(array: [1,3,4])
//
////var aa = [2,2,2]
//
//
//let b = a.searchInsert([1,3], 2)
//
//print(b)
//
let l1 = ListNode.init(1)
//let l2 = ListNode.init(2)
//let l3 = ListNode.init(3)
//let l4 = ListNode.init(4)
//let l5 = ListNode.init(5)
//
//l1.next = l2
//l2.next = l3
//l3.next = l4
//l4.next = l5
//
//let c = a.deleteDuplicates(l1)


//var b = [2,0]
//let c = [1]
//
//let d = a.merge(&b, 1, c, 1)
//print(b)

//let a = TreeNode.init(-2)
//
//
//let a12 = TreeNode.init(-3)
//
//a.right = a12
//
//s.hasPathSum(a, -5)

//let c = [1,9,6,9,1,7,1,1,5,9,9,9]
//let t = s.maxProfit2(c)

//var a = [1,2,3,4,5,6,7]
//var a = [1,2,3,3,4,4,5]
//
//let l = ListNode.changeIntArrayToListNode(array: a)
//
//let r = deleteDuplicates1(l)

//let c = s.singleNumber(a)
//
//let zzz = s.titleToNumber("XYZ")
//
//print(zzz)

//let zzz = s.rob([2,7,9,3,1])

//print(longestPalindromeSubseq("bbbab"))
//print(countSubstrings("aaaaa"))
//print(myAtoi("-91283472332"))

//print(maxArea([1,2,1]))
//print(threeSum([-1, 0, 1, 2, -1, -4]))
//print(threeSumClosest([1,1,1,0],100))

//print(search([4,5,6,7,0,1,2], 0))
//print(search2([1,2,2,2,0,1,1], 0))

//print(findMin([2,1]))
//print(findMin2([0,0,1,1,2,0]))
//print(search2([4,5,6,7,0,1,2], 0))
//print(search3([2,2,2,0,2,2],0))
//print(sortArrayByParityII([2,0,3,4,1,3]))

//let c = removeNthFromEnd(l1, 2)
//print(c)
//let c = swapPairs(l1)
//print(c)
//let c = rotateRight(l1, 1)


//let c = generateMatrix(3)
//let c = uniquePaths2(19, 13)
//print(c)



//print(integerBreak(10))


//print(pivotIndex([1, 2, 3]))

//class Base: NSObject {
//    @objc  func method5() {print("Base.method5")}
//}
//class Subclass: Base {
//
//}
//
//extension Subclass {
//    @objc override func method5() {
//        print("Subclass.method5")
//    }
//}
//
//
//let base: Base = Subclass()
//base.method5()


//print(longestPalindrome_2("jglknendplocymmvwtoxvebkekzfdhykknufqdkntnqvgfbahsljkobhbxkvyictzkqjqydczuxjkgecdyhixdttxfqmgksrkyvopwprsgoszftuhawflzjyuyrujrxluhzjvbflxgcovilthvuihzttzithnsqbdxtafxrfrblulsakrahulwthhbjcslceewxfxtavljpimaqqlcbrdgtgjryjytgxljxtravwdlnrrauxplempnbfeusgtqzjtzshwieutxdytlrrqvyemlyzolhbkzhyfyttevqnfvmpqjngcnazmaagwihxrhmcibyfkccyrqwnzlzqeuenhwlzhbxqxerfifzncimwqsfatudjihtumrtjtggzleovihifxufvwqeimbxvzlxwcsknksogsbwwdlwulnetdysvsfkonggeedtshxqkgbhoscjgpiel"))




var classes: [Do.Type] = [数组.self,字符串.self,链表.self,栈和队列.self,哈希表.self,动态规划.self,树.self,搜索.self,乐扣Top100.self]

for c in classes {
    c.doSomething()
}


print(UnicodeScalar("r").value)
print(UnicodeScalar("t").value)
