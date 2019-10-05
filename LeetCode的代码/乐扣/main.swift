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
		}
		return node
	}
	
}


public class TreeNode {
	public var val: Int
	public var left: TreeNode?
	public var right: TreeNode?
	public init(_ val: Int) {
		self.val = val
		self.left = nil
		self.right = nil
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




//MARK: 1.两数之和
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
	
	
	//        var result:[Int] = []
	
	
	
	//        for i in stride(from: 0, to:nums.count, by: 1) {
	//            for j in stride(from: i+1, to: nums.count, by: 1){
	//                if result.count > 0 {
	//                    break
	//                }
	//                if nums[i] + nums[j] == target{
	//                    result.append(i)
	//                    result.append(j)
	//                    break
	//                }
	//
	//            }
	//        }
	
	
	var dic:[Int:Int] = [:]
	
	for i in 0...nums.count - 1 {
		dic[nums[i]] = i
	}
	
	for i in 0...nums.count{
		let key = target - nums[i]
		if let j = dic[key], i != j{
			return[i,j]
		}
	}
	
	
	return []
	
}


//MARK: 2.两数相加
func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
	var newNode:ListNode? = nil;
	var tempNode:ListNode? = nil;
	
	
	var tempL1 = l1
	var tempL2 = l2
	
	var needAdd = 0
	
	while true {
		if tempL1 == nil || tempL2 == nil {
			break;
		}
		
		var sum = (tempL1?.val)! + (tempL2?.val)! + needAdd
		
		if sum >= 10 {
			needAdd = 1
			sum = sum - 10
		}else{
			needAdd = 0
		}
		
		
		
		let node = ListNode.init(sum)
		
		
		
		
		if newNode == nil {
			newNode = node
		}
		
		
		
		if tempNode != nil{
			tempNode!.next = node;
		}
		
		tempNode = node;
		tempL1 = tempL1?.next
		tempL2 = tempL2?.next
	}
	
	
	while true{
		if tempL1 == nil {
			break
		}
		var sum = (tempL1?.val)! + needAdd
		
		
		if sum >= 10 {
			needAdd = 1
			sum = sum - 10
		}else{
			needAdd = 0
		}
		let node = ListNode.init(sum)
		
		tempNode?.next = node
		
		tempNode = node
		
		tempL1 = tempL1?.next
		
	}
	
	
	while true{
		if tempL2 == nil {
			break
		}
		var sum = (tempL2?.val)! + needAdd
		
		
		if sum >= 10 {
			needAdd = 1
			sum = sum - 10
		}else{
			needAdd = 0
		}
		let node = ListNode.init(sum)
		
		tempNode?.next = node
		
		tempNode = node
		
		tempL2 = tempL2?.next
		
	}
	
	
	if needAdd == 1 {
		tempNode?.next = ListNode.init(needAdd)
	}
	
	
	return newNode
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


//MARK: 5.最大回文子串
///动态规划
func longestPalindrome(_ s: String) -> String {
	
	var sChar:[Character] = []
	
	for char in s {
		sChar.append(char)
	}
	
	if s.count <= 1 {
		return s
	}
	
	
	var longestCount = 1
	var sIndex = 0
	var maxIndex = 0
	
	var dp:[[Bool]] = []
	
	for i in 0..<s.count {
		dp.append([])
		for _ in 0...i {
			(dp[i]).append(false)
		}
	}
	
	for i in 1..<s.count {
		(dp[i])[i] = true
		for j in 0..<i {
			
			
			if (sChar[j] == sChar[i]) && (i-j <= 2 || (dp[i-1])[j+1] == true) {
				(dp[i])[j] = true
				
				if i-j+1 > longestCount {
					longestCount = i-j+1
					sIndex = j
					maxIndex = i
				}
			}
		}
	}
	
	let start = s.index(s.startIndex, offsetBy: sIndex)
	let end = s.index(s.startIndex, offsetBy: maxIndex)
	
	return String(s[start...end])
	
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
//let l1 = ListNode.init(1)
//let l2 = ListNode.init(1)
//let l3 = ListNode.init(2)
//let l4 = ListNode.init(3)
//let l5 = ListNode.init(3)
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

var a = [1,2,3,4,5,6,7]

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

print(search([4,5,6,7,0,1,2], 0))



