//
//  main.swift
//  剑指Offer
//
//  Created by Danny on 2019/8/24.
//  Copyright © 2019 Danny. All rights reserved.
//

import Foundation


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

//MARK: 面试3：数组中重复的数字

///题目一：找出数组中重复的数字
func duplicate(numbers:[Int]) -> Int? {
    if numbers.isEmpty {
        return nil
    }
    
    var newNumbers = numbers
    
    for (index,value) in newNumbers.enumerated() {
        if value < 0 || value > newNumbers.count {
            return nil
        }
        //如果下标和数值不一样,就替换数值到对应下标处，如果该下标已经有了，则返回该数值
        
        while value != index {
            if value == newNumbers[value]{
                return value
            }
            
            let temp = numbers[value]
            newNumbers[value] = value
            newNumbers[index] = temp
        }
        
    }
    
    return nil
}

///题目二：不修改数组找出重复的数字
func getDuplication(numbers:[Int]) -> Int? {
    
    if numbers.isEmpty {
        return nil
    }
    
    //这里的start和end是表示数字的，不是表示数组下标
    var start = 1
    var end = numbers.count - 1
    while start <= end {
        
        let mid = (end - start)/2 + start
        let count = countRange(numbers: numbers, start: start, end: mid)
        
        if start == end {
            ///////似乎二分法最后结束条件都会前等于后
            if count > 1 {
                return start
            }else {
                break
            }
        }
        
        if count > mid - start + 1{
            end = mid
        }else {
            start = mid + 1
        }
    }
    
    
    return nil
}

func countRange(numbers:[Int],start:Int,end:Int) -> Int{
    if numbers.isEmpty {
        return 0
    }
    
    var count = 0
    for (_,value) in numbers.enumerated() {
        if value >= start && value <= end {
            count += 1
        }
    }
    return count
}


//MARK: 面试题4 二维数组中的查找


///题目：
func Find(numbers:[Int],rows:Int,columns:Int,number:Int) -> Bool {
    
    var row_ = 0
    var column_ = columns - 1
    
    if numbers.isEmpty || numbers.count < rows * columns  {
        return false
    }
    
    while (row_ <= rows - 1) && column_ >= 0 {
        
        if numbers[columns * row_ + column_] > number {
            //右上比Target大，这一列都不要
            column_ -= 1
            continue
        }
        
        if numbers[columns * row_ + column_] < number {
            //右上比Target小，这一行都不要
            row_ += 1
            continue
        }
        
        if numbers[columns * row_ + column_] == number {
            return true
        }
        
    }
    
    return false
}


//MARK: 面试题5: 替换空格


///题目：
func ReplaceBlank( string:inout [Character]){
    
    var newString = string
    
    for char in string {
        if char == " " {
            newString.append(contentsOf: [" "," "])
        }
    }
    
    var p1 = string.count - 1
    var p2 = newString.count - 1
    
    while p1 >= 0 && p2 > 0 {
        if newString[p1] == " "{
            newString[p2] = "0"
            p2 -= 1
            newString[p2] = "2"
            p2 -= 1
            newString[p2] = "%"
            p2 -= 1
            p1 -= 1
        }else{
            newString[p2] = newString[p1]
            
            p2 -= 1
            p1 -= 1
        }
        print(newString)
    }
    
    string =  newString
    
    
    
}


//MARK: 面试题6：从尾到头打印链表

///题目：
class ListNode<T:Equatable>:Equatable{
    static func == (lhs: ListNode<T>, rhs: ListNode<T>) -> Bool {
//        return (lhs.value == rhs.value) && (lhs.pNext == rhs.pNext)
		return lhs === rhs
    }
    
    var value:T?
    var pNext: ListNode<T>?
    
    init(value: T?,next:ListNode<T>?) {
        self.value = value
        self.pNext = next
    }
}


func PrintListReversingly_Recursively(pHead:ListNode<Int>) {
    if pHead.pNext != nil {
        PrintListReversingly_Recursively(pHead: pHead.pNext!)
    }
    print(pHead.value!)
}


//MARK: 面试题7：重建二叉树

///题目：
class BinaryTreeNode<T:Equatable>:Equatable {
    static func == (lhs: BinaryTreeNode<T>, rhs: BinaryTreeNode<T>) -> Bool {
        return lhs.value == rhs.value && lhs.pLeft == rhs.pLeft && lhs.pRight == rhs.pRight && lhs.pParent == rhs.pParent
    }
    
    var value:T?
    var pLeft:BinaryTreeNode<T>?
    var pRight:BinaryTreeNode<T>?
    var pParent:BinaryTreeNode<T>?
    
    init(value:T?,left:BinaryTreeNode<T>?,right:BinaryTreeNode<T>?) {
        self.value = value
        self.pLeft = left
        self.pRight = right
    }
    
    init(value:T?,left:BinaryTreeNode<T>?,right:BinaryTreeNode<T>?,parent:BinaryTreeNode<T>?) {
        self.value = value
        self.pLeft = left
        self.pRight = right
        self.pParent = parent
    }
}


func Contruct(preorder:[Int],inorder:[Int]) -> BinaryTreeNode<Int>? {
    
    
    if preorder.isEmpty || inorder.isEmpty || (preorder.count != inorder.count) {
        return nil
    }
    
    
    return ConstructCore(preorder: preorder, inorder: inorder)
}


func ConstructCore(preorder:[Int],inorder:[Int]) -> BinaryTreeNode<Int>? {
    
    if preorder.isEmpty && inorder.isEmpty {
        return nil
    }
    
    let firstRoot = inorder.firstIndex(of: preorder[0])!
    
    //    let inleftCount:Int = firstRoot //3
    
    
    var leftTree:BinaryTreeNode<Int>? = nil
    if firstRoot >= 1 {
        leftTree = ConstructCore(preorder: Array(preorder[1...firstRoot]), inorder: Array(inorder[0..<firstRoot]))
    }
    
    let rightPreStart:Int = firstRoot + 1
    
    var rightTree:BinaryTreeNode<Int>? = nil
    if firstRoot+1 < inorder.count {
        rightTree = ConstructCore(preorder: Array(preorder[rightPreStart..<preorder.count]), inorder: Array(inorder[firstRoot+1..<inorder.count]))
    }
    
    let tree = BinaryTreeNode.init(value: preorder[0], left: leftTree, right: rightTree)
    
    return tree
}


//MARK: 面试题8：二叉树的下一个节点

///题目：
func GetNext(pNode:BinaryTreeNode<Int>?) -> BinaryTreeNode<Int>? {
    
    guard let pRoot = pNode, pRoot.pLeft == nil && pRoot.pRight == nil else {
        return nil
    }
    
    //存在右子树
    if pNode?.pRight != nil {
        return pNode?.pRight
    }
    
    //是父节点的左子树
    if pNode?.pParent != nil && pNode?.pParent?.pLeft == pNode {
        return pNode?.pParent
    }
    
    var parent = pNode?.pParent
    //如果二者都不是，就需要向上查找到是某父节点的左子树
    while parent != nil {
        if parent?.pParent != nil && parent!.pParent?.pLeft == parent {
            return parent
        }
        parent = parent?.pParent
    }
    
    return nil
}


//MARK: 面试题9：用两个栈实现队列


///题目：
struct Stack<T> {
    var sequence:[T] = []
    
    mutating func push(element:T) {
        sequence.append(element)
    }
    
    mutating func pop() -> T? {
        return sequence.popLast()
    }
    
    func top() -> T? {
        return sequence.last
    }
}


struct Queue<T> {
    
    var stack1:Stack<T> = Stack.init()
    var stack2:Stack<T> = Stack.init()
    
    
    mutating func appendTail(element:T)  {
        stack1.push(element: element)
    }
    
    
    mutating func deleteHead() -> T? {
        
        if stack2.top() == nil {
            while stack1.top() != nil {
                stack2.push(element: stack1.pop()!)
            }
        }
        return stack2.pop()
    }
    
}


//MARK: 面试题10 斐波那契数列

///题目一：求斐波那契数列的第n项
func Fibonacci(n:Int) -> Int {
    if n <= 0 {
        return 0
    }
    if n == 1 {
        return 1
    }
    return Fibonacci(n:n-1) + Fibonacci(n:n-2)
}


func Fibonacci1(n:Int) -> Int {
    
    var front = 0
    var back = 1
    var count = n
    
    while count >= 2 {
        
        let temp = front + back
        front = back
        back = temp
        count -= 1
    }
    return back
}


///题目二：青蛙跳台阶问题

func FragJump(n:Int) -> Int {
    
    if n == 0 {
        return 0
    }
    if n == 1 {
        return 1
    }
    if n == 2 {
        return 2
    }
    
    return FragJump(n: n-1) + FragJump(n: n-2)
}


//MARK：查找算法

///顺序查找
func OrderSearch(list:[Int],n:Int) -> Int?{
    
    for int in list {
        if int == n {
            return int
        }
    }
    return nil
}

///二分查找
func BinarySearch(list:[Int],n:Int) -> Int?{
    
    var front = 0
    var back = list.count - 1
    var mid = list.count / 2
    
    
    while back >= front {
        
        mid = (back - front) / 2 + front
        
        if list[mid] == n {
            return n
        }
        
        if list[mid] > n {
            //取前面
            back = mid - 1
        }else {
            front = mid + 1
        }
    }
    
    return nil
}


///哈希查找





///二叉排序树查找
func BinarySearchTree(tree:BinaryTreeNode<Int>?,value:Int) -> BinaryTreeNode<Int>? {
    
    var currentNode = tree
    
    while currentNode != nil {
        if currentNode!.value! == value {
            return currentNode
        }
        
        if currentNode!.value! > value {
            currentNode = currentNode!.pLeft
            continue
        }
        
        if currentNode!.value! < value {
            currentNode = currentNode!.pRight
            continue
        }
    }
    return nil
}




//MARK: 排序算法


///冒泡排序
func BubbleSort(list:inout [Int]) {
    var back = list.count
    
    while back > 0 {
        for index in 0..<back-1 {
            if list[index] > list[index+1] {
                let temp = list[index+1]
                list[index+1] = list[index]
                list[index] = temp
            }
        }
        back -= 1
    }
    print(list)
}


///选择排序
func SelectionSort(list:inout [Int]){
    
    if list.isEmpty || list.count <= 1 {
        return
    }
    
    for i in (1...list.count-1).reversed() {
        
        for j in 0...i-1{
            if list[j] > list[j+1] {
                let temp = list[j+1]
                list[j+1] = list[j]
                list[j] = temp
            }
        }
        
    }
    print(list)
}



///插入排序
func InsertSort(list:inout [Int]){
    
    for start in 0..<list.count {
        var temp = list[start]//当前操作要做插入的元素
        for i in 0..<start {
            if temp < list[i] {
                let t = list[i]
                list[i] = temp
                temp = t
            }
        }
        list[start] = temp
    }
    print(list)
}

func InsertSort1(list:inout [Int]){
    if list.count == 1 {
        return
    }

    var temp = 0
    
    for i in 1..<list.count {
        if list[i] < list[i-1] {
            temp = list[i]
            list[i] = list[i-1]
            
            var j = i-1
            while j >= 0 && list[j] > temp {
                list[j+1] = list[j]
                j -= 1
            }
            list[j+1] = temp
        }
    }
    print(list)
}


///希尔排序
func ShellSort(list:inout [Int]){
    
    var length = list.count / 2
    
    while length >= 1 {
        var i = 0
        
        while i < list.count {
            var temp = list[i]
            var j = 0
            while j < i {
                if temp < list[j] {
                    let t = list[j]
                    list[j] = temp
                    temp = t
                }
                
                if j+length >= i{
                    list[j+length] = temp
                }
                j += length
                
            }
            
            i += length
        }
        length /= 2
    }
    print(list)
    
}

func ShellSort1(list: inout [Int])  {
    var length = list.count / 2
    while length >= 1 {
        
        for var i in 0..<list.count {
            for var j in i..<list.count {
                if list[j] < list[i] {
                    let temp = list[i]
                    list[i] = list[j]
                    list[j] = temp
                }
                j += length
            }
            i += length
        }
        
        length /= 2
    }
    print(list)
}


///归并排序
func MergeSort(list:[Int]) -> [Int] {
    
    
    return CoreMergeSort(list: list)
    
}


func CoreMergeSort(list:[Int]) -> [Int] {
    
    if list.count/2 < 1 {
        return list
    }
    
    let newMid = list.count/2
    
    let leftList = CoreMergeSort(list: Array(list[0..<newMid]))
    let rightList = CoreMergeSort(list: Array(list[newMid..<list.count]))
    
    
    
    var newList:[Int] = []
    
    var i = 0
    var j = 0
    
    while i < leftList.count && j < rightList.count {
        if leftList[i] <= rightList[j]{
            newList.append(leftList[i])
            i += 1
            continue
        }else {
            newList.append(rightList[j])
            j += 1
            continue
        }
    }
    
    while i < leftList.count {
        newList.append(leftList[i])
        i += 1
    }
    while j < rightList.count {
        newList.append(rightList[j])
        j += 1
    }
    
    return newList
}


///快速排序
func QuickSort(list:inout [Int])  {
    
    if list.count <= 1  {
        return
    }
    
    
    let index = Partition1(list: &list, start: 0, end: list.count - 1)
    
	
	var left = Array(list[0...index])
    var right = Array(list[index+1..<list.count])
    QuickSort(list: &left)
    QuickSort(list: &right)
    
    list = left + right
    
//    print(list)
    
}


///划分左小右大  返回划分位置
func Partition(list:inout [Int],start:Int,end:Int) -> Int {
    //将基准数放到最后,调整的时候就不会影响到
    //将小的往前面放，并记录下放的位置
    var index = 0
    
    list.swapAt(0, end)
    
    for i in start..<end {
        if list[end] >= list[i] {
            list.swapAt(index, i)
            index += 1
        }
    }
	list.swapAt(index, end)
	
    
    print(list)
    return index
    
}


func Partition1(list:inout [Int],start:Int,end:Int) -> Int {
    //将基准数放到最后,调整的时候就不会影响到
    //将小的往前面放，并记录下放的位置
    var i = start
    var j = end
    let mark = list[i]
    while i < j {
        while i < j, list[j] >= mark {
            //从后找出比基准值小的挪到前面
            j -= 1
        }
        list[i] = list[j]
        while i < j, list[i] <= mark {
            //从前找出基准值比大的挪到后面
            i += 1
        }
        list[j] = list[i]
    }
    list[i] = mark
    print(list)
    return i
}


///堆排序

///构建大顶堆
func BuildMaxHeap(list:inout [Int]){
    if list.count/2-1 < 0 {
        return
    }
    for i in (0...list.count/2-1).reversed() {
		AdjustHeap(list: &list, index: i,length: list.count)
    }
}


func AdjustHeap(list:inout [Int],index:Int,length:Int){
    
    var maxIndex = index
    
    let left = 2*index+1
    let right = 2*index+2
    
    //存在左子节点
    if left < length && list[left] > list[maxIndex] {
        maxIndex = left
    }
    
    //存在右子节点
    if right < length && list[right] > list[maxIndex] {
        maxIndex = right
    }
    
    if maxIndex != index {
        list.swapAt(maxIndex, index)
        AdjustHeap(list: &list, index: maxIndex,length: length)
    }
    print(list)
}


// 只能调整一个节点的根节和左右字数
func HeapAdjust(list: inout [Int], s: Int, m: Int){
    var temp = list[s];
    var start = s
    var index = 2*start+1;
    var j = 2*start+1
    while j <= m {
        if j < m, list[j] < list[j+1] {
            j += 1
        }
        if temp > list[j] {
            break
        }
        list[start] = list[j]
        start = j;

        j = j * 2 + 1
        index = start;
    }
    list[index] = temp;
    print(list)
}

func HeapSort1(list: inout [Int], n: Int) {
    for var i in (0...n/2-1).reversed() {
        HeapAdjust(list: &list, s: i, m: n-1)
        print(list)
        i -= 1
    }
    print(list)
}

func HeapSort(list: inout [Int]) {
    BuildMaxHeap(list: &list)
    
    var i = list.count - 1
	
	print(list)
    
    while i > 0 {
        list.swapAt(i, 0)
		i -= 1
		AdjustHeap(list: &list, index: 0,length: i)
		print(list)

        
    }
    print(list)
}


///桶排序
//TODO: 没写



//MARK: 面试题11：旋转数组的最小数字
func Min(list:[Int],start:Int,end:Int) -> Int {
    
    var s = start
    var e = end
    
    if list[e] > list[s] {
        return list[s]
    }
    
    var mid = (e-s)/2
    while s != mid {
        
        if list[s] == list[mid] && list[e] == list[mid]{
            ///如果头，中间，尾都相等，则不能判断出最小值在哪个区间
            return MinInSort(list: Array(list[s...e]))
        }
        
        if list[mid] >= list[s] {
            s = mid + 1
        }
        if list[mid] <= list[e] {
            e = mid - 1
        }
        mid = (s-e)/2+s
    }
    
    return list[mid+1]
}

func MinInSort(list:[Int]) -> Int {
    var min = list[0]
    
    for i in 0..<list.count{
        if list[i] < min {
            min = list[i]
        }
    }
    return min
}


//MARK: 面试题12: 矩阵中的路径
//row,colum表示二位数组多大而已
func HasPath(list:[Character],rows:Int,columns:Int,matchStr:[Character]) -> Bool {
    
    //1.从任意出发
    //2.走过的不能走
    //3.边界的值不能走
    var selectedList:[Int] = []
    for _ in 0..<rows * columns {
        selectedList.append(0)
    }
    var hasPath = false
    for r in 0..<rows {
        for c in 0..<columns {
            if list[r*columns+c] == matchStr[0] {
                
                let firstTime = CoreHasPath(list: list, rows: rows, columns: columns, row: r, column: c, matchStr: Array(matchStr[0..<matchStr.count]), selectedList: &selectedList)
                
                hasPath = hasPath || firstTime
                
            }
        }
    }
    return hasPath
}

//row,column表示位置在哪儿
func CoreHasPath(list:[Character],rows:Int,columns:Int,row:Int,column:Int,matchStr:[Character],selectedList:inout [Int]) -> Bool{
    
    //需要分上左下右四个情况
    var hasPath = false
    
    if row >= 0 && row < rows && column >= 0 && column < columns && selectedList[row*columns+column] == 0 && list[row*columns+column] == matchStr[0]{
        
        selectedList[row*columns+column] = 1
        
        if matchStr.count == 1  {
            return true
        }
        
        //上
        
        let top = CoreHasPath(list: list, rows: rows, columns: columns, row: row-1, column: column, matchStr: Array(matchStr[1..<matchStr.count]), selectedList: &selectedList)
        
        
        
        //左
        
        let left = CoreHasPath(list: list, rows: rows, columns: columns, row: row, column: column-1, matchStr: Array(matchStr[1..<matchStr.count]), selectedList: &selectedList)
        
        
        //下
        
        let bottom = CoreHasPath(list: list, rows: rows, columns: columns, row: row+1, column: column, matchStr: Array(matchStr[1..<matchStr.count]), selectedList: &selectedList)
        
        
        //右
        
        let right = CoreHasPath(list: list, rows: rows, columns: columns, row: row, column: column+1, matchStr: Array(matchStr[1..<matchStr.count]), selectedList: &selectedList)
        
        
        hasPath = top || left || bottom || right
        
        if hasPath == false {
            selectedList[row*columns+column] = 0
        }
        
    }
    
    return hasPath
}


//MARK: 面试题13： 机器人的运动范围





//MARK: 面试题 14 剪绳子

///动态规划
func MaxProductAfterCutting_Solution1(length: Int) -> Int{
	
	if length < 2  {
		return 0
	}
	if length == 2 {
		return 1
	}
	if length == 3 {
		return 2
	}
	
    var products:[Int] = [0,1,2,3]
	var max = 0
	for i in 4...length {
		//第一层循环，由开始数字，一个个计算f(4),f(5),f(6)等等子问题的最大值，到时候的f(n) = f(n-m)+f(m)子问题组成结果
		max = 0
		for j in 1...i/2{
			//第二层循环，计算子问题最大乘积记录下来，用作当前问题的结果供后面更大的问题使用
			let product = products[j] * products[i-j]
			if product > max {
				max = product
			}
		}
		products.append(max)
	}

    
    return products[length]
}


///贪婪算法
func MaxProductAfterCutting_Solution2(length: Int) -> Int{
    //就是穷举出最优解的几种情况，或者每次能有规律找出最优解，从而叠加起来完成最优解的情况
    //这道题中就是分成f(5)就是找f(2)*f(3),f(4)=f(2)*f(2),所以就是解决最多能细分几个4，几个3
    var l = length
    //    var products:[Int] = [0,0,1,2,4]
    
    var time = 0
    var result = 0
    
    while l/4 >= 1 {
        result *= 4
        l -= 4
    }
    
    if l >= 3 {
        result *= 2
    }
    
    result *= l
    
    
    
    
    return result
}


//MARK:面试题15： 二进制中1的个数(整数带正和负的)
//func NumberOf1(n:Int) -> Int {
//    var m = n
//    var count = 0
//
//    while m/2 > 0 {
//        if m%2 != 0 {
//            count += 1
//        }
//        m /= 2
//        if m == 1 {
//            count += 1
//            break
//        }
//    }
//
//    return count
//
//}

//负数的表示方式使用二进制的补码，就是先按位取反再加一
func NumberOf1(n:Int8) -> Int {
    var flag:Int8 = 0b00000001
    var count = 0
    
    while flag > 0 {
        if n&flag > 0 {
            count += 1
        }
        flag = flag<<1
    }
    
    
    return count
}


//二进制数-1再与自身&运算，将会将最后一个1消除
func NumberOf1_1(n:Int8) -> Int {
    var newN = n
    var count = 0
    while newN > 0 {
        newN = (newN-1)&newN
        count += 1
    }
    return count
}


//MARK:面试题16: 数值的整数次方
func MyPower(base:Double,exponent:Int) ->  Double {
    
    if base.isEqual(to: 0.0) {
        return 0.0
    }
    
    var p = MyPositivePower1(base: base, exponent: abs(exponent))
    
    if exponent < 0 {
        p = 1/p
    }
    
    return p
}

///简单的循环解决
func MyPositivePower(base:Double,exponent:Int) ->  Double{
    var result = 1.0
    for _ in 0..<exponent {
        result *= base
    }
    return result
}

///使用斐波那契数列公式解决
func MyPositivePower1(base:Double,exponent:Int) ->  Double{
    
    if exponent == 0 {
        return 1
    }
    if exponent == 1 {
        return base
    }
    
    let half = MyPositivePower1(base: base, exponent: exponent>>1)
    
    var result = half * half
    
    if exponent&(0b1) == 1 {
        result *= base
    }
    return result
    
    
}


//MARK: 面试题17：打印从1到最大的n位数
func Print1ToMaxOfNDigits(n:Int){
    var list:[Int] = []
    for _ in 0..<n {
        list.append(0)
    }
    
    
    var stop = false
    
    while stop == false {
        stop = Increment(list: &list)
        PrintList(list: list)
    }
    
}

func Increment(list: inout[Int]) -> Bool {
    
    var addOne = 0
    
    list[list.count-1] += 1
    for i in (0..<list.count).reversed() {
        
        
        
        list[i] = list[i] + addOne
        addOne = 0
        if list[i] >= 10 {
            addOne = 1
            list[i] = list[i] - 10
        }
        
        if i == 0 && addOne == 1 {
            return true
        }
        
    }
    
    return false
    
}


func PrintList(list:[Int]){
    var str = ""
    var ignore = true
    
    for value in list{
        if ignore == true && value == 0 {
            continue
        }
        ignore = false
        str = str + " \(value)"
    }
    print(str)
}


//MARK:面试题18：删除链表的节点


///题目一：在O(1)时间内删除链表节点
func DeleteNode(pListHead:inout ListNode<Int>?,pToBeDeleted: ListNode<Int>){
    //判断是否在头结点
    //判断是否在末尾
    //判断是否为空
    if pListHead == nil ||  pListHead!.value == nil {
        return
    }
    
    if pListHead == pToBeDeleted  {
        pListHead = pListHead!.pNext
    }
    
    var next = pToBeDeleted.pNext
    if next != nil {
        pToBeDeleted.value = next?.value
        pToBeDeleted.pNext = next?.pNext
        //清理不用的数据
        next = nil
    }else{
        while pListHead?.pNext != nil {
            if pListHead?.pNext == pToBeDeleted {
                pListHead?.pNext = nil
            }
            pListHead = pListHead?.pNext
        }
    }
    
}


///题目二：删除链表中重复的节点
func DeleteDuplication(pHead:inout ListNode<Int>?){
    
    //判断链表为空
    //链表只有一个的情况
    //链表所有内容都相等的情况
    //链表开头都相等的情况
    //链表结尾都相等的情况
    
    if pHead == nil || pHead!.value == nil {
        return
    }
    
    var preNode:ListNode<Int>? = nil
    
    var head = pHead
    
    while head !=  nil {
        
        if head?.pNext?.value == head?.value {
            //重复的，遍历到不重复的
            
            let temp = head
            while head != nil {
                if head!.value! > temp!.value! {
                    break
                }
                head = head?.pNext
            }
            if preNode == nil {
                preNode = head
            }else {
                preNode?.pNext = head
            }
        }else{
            
            if preNode == nil {
                preNode = head
            }else {
                preNode?.pNext = head
                preNode = preNode?.pNext
            }
            
            head = head?.pNext
        }
        
        
    }
    
}





//MARK:面试题19：正则表达式匹配

///题目
func Match(str:[Character],pattern:[Character]) -> Bool {
    
    //	if str[0] != pattern[0] && pattern[0] != "." {
    //		return false
    //	}
    
    if str.isEmpty && pattern.isEmpty {
        return true
    }
    
    if str.isEmpty && !pattern.isEmpty {
        return false
    }
    
    if pattern.count > 1 && pattern[1] == "*" {
        //特殊模式
        
        
        if pattern[0] == str[0] || (pattern[0] == "." && !str.isEmpty){
            //这里有三种情况
            //1.将*和前面的符号忽略，匹配串移动2个
            //2.将*和前面的符号跟字符串匹配一个，字符串移动一个跟匹配串移动两个
            //3.匹配下一个字符串，匹配串不动，字符串移动一个
            return Match(str: str, pattern: Array(pattern[2..<pattern.count])) || Match(str: Array(str[1..<str.count]), pattern: Array(pattern[1..<pattern.count])) || Match(str: Array(str[1..<str.count]), pattern: pattern)
            
        }else{
            //由于星号前的字符不匹配，所以必须忽略掉
            return Match(str: str, pattern: Array(pattern[2..<pattern.count]))
        }
    }
    
    if str[0] == pattern[0] || (pattern[0] == "." && !str.isEmpty){
        return Match(str: Array(str[1..<str.count]), pattern: Array(pattern[1..<pattern.count]))
    }
    
    return false
    
}

//func Match2(str:[Character],pattern:[Character]) -> Bool{
//
//	var i = 0
//	var j = 0
//	while i < str.count && j < pattern.count {
//
//		if j+1 < pattern.count && pattern[j+1] == "*" {
//
//			if pattern[j] == str[i] || pattern[j] == "."{
//				//
//			}
//
//
//		}
//	}
//}



//MARK：面试题20：表示数值的字符串

///题目
//-  A[.[B]][e|EC]
//-  .B[e|EC]
func IsNumberic(str:[Character]) -> Bool {
    
    if str.isEmpty {
        return false
    }
    
    var numeric = ScanInteger(str: str)
    
    
    if numeric.1 == str.count {
        return numeric.0
    }
    
    if str[numeric.1] == "." {
        //A之后跟着小数点的话
        
        let result = ScanUnsignedInteger(str: Array(str[numeric.1+1..<str.count]))
        numeric.0 =  numeric.0 || result.0
        numeric.1 += result.1
    }
    
    
    
    if str[numeric.1] == "e" || str[numeric.1] == "E" {
        //如果是指数的话
        if numeric.1+1 == str.count {
            //指数末尾还要跟着数字
            return false
        }
        
        
        let result = ScanInteger(str: Array(str[numeric.1+1..<str.count]))
        numeric.0 = numeric.0 && result.0
        numeric.1 += result.1
    }
    
    
    return numeric.0 && (numeric.1 + 1 == str.count)
    
}


func ScanInteger(str:[Character]) -> (Bool,Int) {
    var start = 0
    if str[0] == "+" || str[0] == "-" {
        start = 1
    }
    let result = ScanUnsignedInteger(str: Array(str[start..<str.count]))
    let index = result.0 == true ? result.1 + start : 0
    return (result.0,index)
}


func ScanUnsignedInteger(str:[Character]) -> (Bool,Int) {
    var index = 0
    if !str.isEmpty {
        while index < str.count  {
            if str[index] >= "0" && str[index] <= "9"{
                index += 1
                continue
            }
            break
        }
        return (index != 0, index)
    }
    return (false,0)
}



//MARK:面试题21：调整数组顺序使奇数位于偶数前面

///题目
func ReorderOddEvent(pdata: inout [Int]){
    
    var front = 0
    var back = pdata.count - 1
    
    while back > front {
        
        while front<back && pdata[front]&1 == 1{
            front += 1
        }
        
        while front<back && pdata[back]&1 == 0 {
            back -= 1
        }
        
        if pdata[front]&1 == 0 && pdata[back]&1 == 1{
            //前面是偶数，后面是奇数
            let temp = pdata[front]
            pdata[front] = pdata[back]
            pdata[back] = temp
            front += 1
            back -= 1
        }
        
    }
    print(pdata)
}


//MARK: 面试题22：链表中倒数第k个节点

//题目：
func FindKthToTail(pListHead:ListNode<Int>,k:Int) -> ListNode<Int>? {
    var front:ListNode<Int>? = pListHead
    var back:ListNode<Int>? = pListHead
    
    var count = 1
    while back != nil && count < k  {
        back = back?.pNext
        count += 1
    }
    if back == nil {
        return nil
    }
    
    while back?.pNext != nil && front != nil {
        back = back?.pNext
        front = front!.pNext
    }
    
    return front
}




//MARK: 面试题23:链表中环的入口节点

///题目
func EntryNodeOfLoop(pHead:ListNode<Int>) -> ListNode<Int>? {
	var one:ListNode<Int>? = pHead
	var two:ListNode<Int>? = pHead
	
	while two != nil {
		one = one?.pNext
		two = two?.pNext?.pNext
		
		if one == two {
			return one
		}
	}
	
	return nil
}


//MARK:面试题24：翻转链表

///题目
func ReverseList(pHead:inout ListNode<Int>?) -> ListNode<Int>? {
	if pHead == nil || pHead?.pNext == nil {
		return pHead
	}
	
	var preNode:ListNode<Int>? = nil
	while pHead != nil {

		let temp = pHead?.pNext
		pHead?.pNext = preNode
		
		let newPre = pHead
		newPre?.pNext = preNode
		preNode = newPre

		pHead = temp

	}
	
	return preNode
}




//MARK:面试题25：合并两个排序的链表

///题目
func Merge(pHead1: inout ListNode<Int>?,pHead2: inout ListNode<Int>?) ->ListNode<Int>? {
	
	var newHead:ListNode<Int>?
	var pHead:ListNode<Int>?
	
	while pHead1 != nil && pHead2 != nil {
		
		if pHead1!.value! < pHead2!.value! {
			if newHead == nil {
				newHead = pHead1
				pHead = newHead
			}else {
				newHead?.pNext = pHead1
				newHead = newHead?.pNext
			}
			pHead1 = pHead1?.pNext
		}else {
			if newHead == nil {
				newHead = pHead2
				pHead = newHead
			}else {
				newHead?.pNext = pHead2
				newHead = newHead?.pNext
			}
			pHead2 = pHead2?.pNext
		}
	}
	
	while pHead1 != nil {
		if newHead == nil {
			newHead = pHead1
			pHead = newHead
		}else {
			newHead?.pNext = pHead1
			newHead = newHead?.pNext
		}
		pHead1 = pHead1?.pNext
	}
	
	while pHead2 != nil {
		if newHead == nil {
			newHead = pHead2
			pHead = newHead
		}else {
			newHead?.pNext = pHead2
			newHead = newHead?.pNext
		}
		pHead2 = pHead2?.pNext
	}
	
	return pHead
}



func Merge2(pHead1: inout ListNode<Int>?,pHead2: inout ListNode<Int>?) ->ListNode<Int>? {
	
	var newHead:ListNode<Int>?
	
	if pHead1 == nil && pHead2 == nil {
		return nil
	}
    
    if pHead1 == nil {
        return pHead2
    }
    
    if pHead2 == nil {
        return pHead1
    }
	
	if pHead1!.value! < pHead2!.value! {
        newHead = pHead1
        
        var newPhead1 = pHead1?.pNext
        newHead?.pNext = Merge2(pHead1: &newPhead1, pHead2: &pHead2)
//        if pHead1?.pNext == nil {
//            return pHead1
//        }
//        var newPhead1 = pHead1?.pNext
//        if newHead == nil {
//            newHead = Merge2(pHead1: &newPhead1, pHead2: &pHead2)
//        }else {
//            newHead?.pNext = Merge2(pHead1: &newPhead1, pHead2: &pHead2)
//        }
		
	}else{
        newHead = pHead2
        var newPhead2 = pHead2?.pNext
        newHead?.pNext = Merge2(pHead1: &pHead1, pHead2: &newPhead2)
//        if pHead2?.pNext == nil {
//            return pHead2
//        }
//        var newPhead2 = pHead2?.pNext
//        if newHead == nil {
//            newHead = Merge2(pHead1: &pHead1, pHead2: &newPhead2)
//        }else {
//            newHead?.pNext = Merge2(pHead1: &pHead1, pHead2: &newPhead2)
//        }
	}
	
	return newHead
	
}


//MARK:面试题26：输的子结构

///题目:
func HasSubTree(treeA:BinaryTreeNode<Int>? ,treeB:BinaryTreeNode<Int>?) -> Bool {
    
    var result:Bool = false
    
    if treeA != nil && treeB != nil {
        if treeA?.value == treeB?.value {
            result = CoreHadSubTree(treeA: treeA, treeB: treeB)
        }
        if !result == true {
            result = CoreHadSubTree(treeA: treeA?.pLeft, treeB: treeB)
        }
        if !result == true {
            result = CoreHadSubTree(treeA: treeA?.pRight, treeB: treeB)
        }
    }
    return result
    
}

func CoreHadSubTree(treeA:BinaryTreeNode<Int>? ,treeB:BinaryTreeNode<Int>?) -> Bool {
    if treeB == nil {
        return true
    }
    
    if treeA == nil {
        return false
    }
    
    return CoreHadSubTree(treeA: treeA?.pLeft, treeB: treeB?.pLeft) && CoreHadSubTree(treeA: treeA?.pRight, treeB: treeB?.pRight)
    
}


//MARK: 面试题27：二叉树的镜像
func MirrorRecursively(pNode:BinaryTreeNode<Int>?) -> BinaryTreeNode<Int>?{
    
    if pNode?.pLeft == nil && pNode?.pRight == nil {
        return pNode
    }
    

    
    
    pNode?.pLeft = MirrorRecursively(pNode: pNode?.pLeft)
    pNode?.pRight = MirrorRecursively(pNode: pNode?.pRight)
    
    let temp = pNode?.pLeft
    pNode?.pLeft = pNode?.pRight
    pNode?.pRight = temp
    
    return pNode
    
    
}

//MARK: 面试题28：对称二叉树
func IsSymmetrical(pRoot :BinaryTreeNode<Int>?) -> Bool {
    
    if (pRoot == nil) || (pRoot?.pLeft == nil && pRoot?.pRight == nil) {
        return true
    }
    
    if pRoot?.pLeft == nil || pRoot?.pRight == nil {
        return false
    }
    
    
    return IsSymmetrical(pRoot1: pRoot?.pLeft, pRoot2: pRoot?.pRight)
    
}

func IsSymmetrical(pRoot1:BinaryTreeNode<Int>?,pRoot2:BinaryTreeNode<Int>?) ->Bool{
    
    if pRoot1 == nil && pRoot2 == nil {
        return true
    }
    
    return (pRoot1?.value == pRoot2?.value) && IsSymmetrical(pRoot1: pRoot1?.pLeft, pRoot2: pRoot2?.pRight) && IsSymmetrical(pRoot1: pRoot1?.pRight, pRoot2: pRoot2?.pLeft)
}



//MARK:面试题29：顺时针打印矩阵
func spiralOrder(_ matrix: [[Int]]) -> [Int] {
    var Rs = 0
    var Cs = 0
    var Re = matrix.count-1
    if matrix.isEmpty || matrix[0].isEmpty{
        return []
    }
    var Ce = matrix[0].count-1
    
    var result:[Int] = []
    
    while true {
        //Column 左到右
        
        if (Re >= Rs && Ce >= Cs) == false {
            break
        }
        
        for column in Cs...Ce{
            result.append(matrix[Rs][column])
        }
        Rs += 1
        
        if (Re >= Rs && Ce >= Cs) == false {
            break
        }
        
        //Row 上到下
        for row in Rs...Re {
            result.append(matrix[row][Ce])
        }
        Ce -= 1
        if (Re >= Rs && Ce >= Cs) == false {
            break
        }
        
        //Column 右到左
        for column in (Cs...Ce).reversed(){
            result.append(matrix[Re][column])
        }
        Re -= 1
        
        if (Re >= Rs && Ce >= Cs) == false {
            break
        }
        
        //Row 下到上
        for row in (Rs...Re).reversed() {
            result.append(matrix[row][Cs])
        }
        Cs += 1
    }
    return result
}



//MARK: 面试题30：包含min函数的栈

//题目：
class MinStack {
    
    var helper:[Int] = []
    var stack:[Int] = []
    
    /** initialize your data structure here. */
    init() {
        
    }
    
    func push(_ x: Int) {
        stack.append(x)
        
        if helper.isEmpty {
            helper.append(x)
            return
        }
        
        if x < helper.last! {
            helper.append(x)
        }else{
            helper.append(helper.last!)
        }
    }
    
    func pop() {
        stack.removeLast()
        helper.removeLast()
    }
    
    func top() -> Int {
        if stack.last == nil {
            return 0
        }
        return stack.last!
    }
    
    func getMin() -> Int {
        if helper.last == nil {
            return 0
        }
        return helper.last!
    }
}




//MARK：面试题31：栈的压入，弹出序列

///题目

func validateStackSequences(_ pushed: [Int], _ popped: [Int]) -> Bool {
    var stack :Stack<Int> = Stack.init()
    
    var Push = pushed
    var Pop = popped
    
    while true  {
        if Push.isEmpty {
            if (Pop.first != stack.top()) {
                return false
            }
            if Pop.isEmpty && stack.top() == nil {
                return true
            }
        }
        
        if stack.top() == Pop.first {
            _ = stack.pop()
            Pop.remove(at: 0)
            continue
        }
        
        if !Push.isEmpty{
            stack.push(element: Push.first!)
            Push.remove(at: 0)
        }
    }

}


//MARK: 面试题32：从上到下打印二叉树

///题目一：不分行从上到下打印二叉树
func PrintFromTopToBottom(pTreeRoot:BinaryTreeNode<Int>) -> [Int]{
	
	var result:[Int] = []
	
	var queue = Queue<BinaryTreeNode<Int>>()
	
	queue.appendTail(element: pTreeRoot)
	
	while let delete = queue.deleteHead() {
		result.append(delete.value!)
		
		if delete.pLeft != nil {
			queue.appendTail(element: delete.pLeft!)
		}
		if delete.pRight != nil {
			queue.appendTail(element: delete.pRight!)
		}
	}
	
	return result
	
}

///题目二：分行从上到下打印二叉树
func levelOrder(_ root: BinaryTreeNode<Int>?) -> [[Int]] {
	
	guard let tree = root else {
		return []
	}
	
	var numOfRow = 0
	var numToDelete = 1
	
	
	var result:[[Int]] = []
	
	var row:[Int] = []
	
	var queue:[BinaryTreeNode<Int>] = []
	queue.append(tree)
	
	while queue.count > 0 {
		
		let delete = queue.remove(at: 0)
		numToDelete -= 1
		

		row.append(delete.value!)
		
		if delete.pLeft != nil {
			queue.append(delete.pLeft!)
			
			numOfRow += 1
		}
		
		if delete.pRight != nil {
			queue.append(delete.pRight!)
			
			numOfRow += 1
		}
		
		if numToDelete == 0 {
			
			result.append(row)
			row.removeAll()
			
			numToDelete = numOfRow
			numOfRow = 0
		}
		
	}
	
	return result
	

}


///题目三：之字形打印二叉树
func PrintTreeInZhi(pRoot:BinaryTreeNode<Int>?) -> [[Int]]{
	var result:[[Int]] = []
	if pRoot == nil {
		return result
	}
	
	var leftStack:Stack<BinaryTreeNode<Int>> = Stack()
	var rightStack:Stack<BinaryTreeNode<Int>> = Stack()
	
	leftStack.push(element: pRoot!)
	
	
	
	
	
	while leftStack.top() != nil || rightStack.top() != nil {
		
		var row:[Int] = []
		
		if leftStack.top() != nil {
			while leftStack.top() != nil {
				let top = leftStack.pop()!
				row.append(top.value!)
				if top.pLeft != nil {
					rightStack.push(element: top.pLeft!)
				}
				if top.pRight != nil {
					rightStack.push(element: top.pRight!)
				}
				
				
			}
			result.append(row)
		}else{
			while rightStack.top() != nil {
				let top = rightStack.pop()!
				row.append(top.value!)
				
				if top.pRight != nil {
					leftStack.push(element: top.pRight!)
				}
				if top.pLeft != nil {
					leftStack.push(element: top.pLeft!)
				}
			
			}
			result.append(row)
		}

		
		
	}
	
	return result
	
	
}



//MARK:面试题33：二叉搜索树的后序遍历序列

///题目：
func VerifySquenceOfBST(sequence:[Int]) -> Bool {
	
	if sequence.count <= 0 {
		return true
	}
	
	let root = sequence.last
	
	
    //寻找比root大的值，然后左侧都是左子树
    var leftCount = 0
    
    for i in 0..<sequence.count {
        if sequence[i] > root! {
            leftCount = i
            break
        }
    }

    
    var rightStart = leftCount
    while rightStart < sequence.count {
        if sequence[rightStart] < root! {
            return false
        }
        rightStart += 1
    }
    
    var leftVerify = true

    if leftCount > 0 {
        leftVerify = VerifySquenceOfBST(sequence: Array(sequence[0..<leftCount]))
    }
   
    var rightVerify = true
    if leftCount < sequence.count - 1 {
        rightVerify = VerifySquenceOfBST(sequence: Array(sequence[leftCount..<sequence.count-1]))
    }
    
    return leftVerify && rightVerify
    

	
}



//MARK:面试题34：二叉树中和为某一值的路径


//题目
class Solution {

	var currentValue = 0
	var stack:Stack<BinaryTreeNode<Int>> = Stack()
	var result:[[Int]] = []

	func pathSum(_ root: BinaryTreeNode<Int>?, _ sum: Int) -> [[Int]] {

		if root == nil {
			return result
		}

		pathSumCore(root: root, sum: sum)

		return result
	}

	func pathSumCore(root:BinaryTreeNode<Int>?,sum:Int) {

		currentValue += root!.value!
		stack.push(element: root!)

		if root?.pLeft == nil && root?.pRight == nil && currentValue == sum {

			//将栈中所有内容放入结果
			var row:[Int] = []
			for tree in stack.sequence {
				row.append(tree.value!)
			}
			result.append(row)

		}

		
		if root?.pLeft != nil {
			pathSumCore(root: root?.pLeft, sum: sum)
		}
//		if left == false {
//			//如果左侧为假，将栈中节点恢复成原来
			while stack.top() != root {
				let tree = stack.pop()
				currentValue -= tree!.value!
			}
//		}

		
		if root?.pRight != nil {
			pathSumCore(root: root?.pRight, sum: sum)
		}
//		if right == false {
//			//如果左侧为假，将栈中节点恢复成原来
			while stack.top() != root {
				let tree = stack.pop()
				currentValue -= tree!.value!
			}
//		}

		let tree = stack.pop()
		currentValue -= tree!.value!
		


	}
}

//class Solution {
//
//	var currentValue = 0
//	var stack:Stack<TreeNode> = Stack()
//	var result:[[Int]] = []
//
//	func pathSum(_ root: TreeNode?, _ sum: Int) -> [[Int]] {
//		if root == nil {
//			return result
//		}
//
//		_ = pathSumCore(root: root, sum: sum)
//
//		return result
//	}
//
//	func pathSumCore(root:TreeNode?,sum:Int)  {
//
//		currentValue += root!.val
//		stack.push(element: root!)
//
//		if root?.left == nil && root?.right == nil && currentValue == sum {
//
//			//将栈中所有内容放入结果
//			var row:[Int] = []
//			for tree in stack.sequence {
//				row.append(tree.val)
//			}
//			result.append(row)
//
//
//		}
//
//
//		if root?.left != nil {
//			pathSumCore(root: root?.left, sum: sum)
//		}
//
//
//
//		if root?.right != nil {
//			pathSumCore(root: root?.right, sum: sum)
//		}
//
//		let tree = stack.pop()
//		currentValue -= tree!.val
//
//
//
//
//	}
//}



//MARK:面试题35：复杂链表的复制

///题目

class ComplexListNode<T> {
	var value:T
	var pNext:ComplexListNode<T>?
	var pSibling:ComplexListNode<T>?

	init(value:T,pNext:ComplexListNode<T>?,pSibling:ComplexListNode<T>?) {
		self.value = value
		self.pNext = pNext
		self.pSibling = pSibling
	}
}


func CopyComplexListNode(pHead:ComplexListNode<Int>?) -> ComplexListNode<Int>? {
	if pHead == nil {
		return nil
	}
	
	var copyPHead = pHead
	
	while copyPHead != nil {
		let copy:ComplexListNode = ComplexListNode.init(value: copyPHead!.value, pNext: copyPHead?.pNext, pSibling: nil)
			
		copyPHead?.pNext = copy
		
		copyPHead = copy.pNext
		
	}
	
	
	var sPHead = pHead
	while sPHead != nil {
		if sPHead?.pSibling != nil {
			//获取复制
			let copy = sPHead?.pNext
			//将复制指针的任意指针，指向原来任意指针的下一个值
			copy?.pSibling = sPHead?.pSibling?.pNext
		}
		sPHead = sPHead?.pNext?.pNext
	}
	
	let rPhead = pHead?.pNext
	var head = pHead?.pNext
	while head != nil  {
		head?.pNext = head?.pNext?.pNext
		head = head?.pNext
	}
	
	
	
	
	return rPhead
	
	
}

//MARK:面试题36：二叉搜索树与双向链表

///题目：
func Convert(pRootOfTree:BinaryTreeNode<Int>?) -> BinaryTreeNode<Int>?{
    if pRootOfTree == nil {
        return pRootOfTree
    }
    
    
    

    var new:BinaryTreeNode<Int>? = ConvertCore(pRootOfTree: pRootOfTree)
    
    
    while new?.pLeft != nil {
        if new?.pLeft == nil {
            break
        }
        
        new = new?.pLeft
    }
    
    return new
}


func ConvertCore(pRootOfTree:BinaryTreeNode<Int>?) -> BinaryTreeNode<Int>?{
    
    if pRootOfTree == nil {
        return nil
    }
    
    if pRootOfTree?.pLeft == nil && pRootOfTree?.pRight == nil{
        return pRootOfTree
    }
    
    var leftRoot = ConvertCore(pRootOfTree: pRootOfTree?.pLeft)
    
    //寻找leftRoot的最右
    while leftRoot != nil {
        if leftRoot?.pRight == nil {
            break
        }
        leftRoot = leftRoot?.pRight
    }
    
    
    
    if leftRoot != nil {
        leftRoot?.pRight = pRootOfTree
        pRootOfTree?.pLeft = leftRoot
    }
    
    

    var rightRoot = ConvertCore(pRootOfTree: pRootOfTree?.pRight)
    
    //寻找rightRoot的最左
    while rightRoot != nil {
        if rightRoot?.pLeft == nil {
            break
        }
        rightRoot = rightRoot?.pLeft
    }
    
    if rightRoot != nil {
        rightRoot?.pLeft = pRootOfTree
        pRootOfTree?.pRight = rightRoot
    }
    return pRootOfTree
    
    
}

//MARK:面试题37：序列化二叉树



//MARK:面试题38：字符串的排序


///题目一：全排列
func permute(_ nums: [Int]) -> [[Int]] {
	
	if nums.count == 0 || nums.count == 1 {
		return [nums]
	}
	
	return permuteCore(nums)
}

func permuteCore(_ nums: [Int]) -> [[Int]] {
	
	if nums.count <= 1 {
		return [nums]
	}
	
	let afterPermute = permuteCore(Array(nums[1..<nums.count]))
	
	var newAfterResult:[[Int]] = []
	
	for eachPermute in afterPermute {
		let arr  = [nums[0]] + eachPermute
		newAfterResult.append(arr)
	}
	
	var result:[[Int]] = []
	for eachPermute in newAfterResult {
		var permute = eachPermute
		
		if permute.count <= 1 {
			break
		}
		
		for index in 0..<permute.count {
			var temp = permute[0]
			permute[0] = permute[index]
			permute[index] = temp
			
			result.append(permute)
			
			temp = permute[0]
			permute[0] = permute[index]
			permute[index] = temp
			
		}
		
	}
	
	return result
}



var resultArray:[[Int]] = []
///题目二：组合
func subsets(_ nums: [Int]) -> [[Int]] {
	if nums.count == 0 {
		return [nums]
	}
	if nums.count == 1 {
		return [nums,[]]
	}
	var pre:[Int] = []
	
	subsetsCore1(nums, 0, &pre)
	
	return resultArray;

}



/// 递归将begin后面的剩余数字的组合逐次加进来,例如：[1,2,3]，传入begin为1，则会返回2，23，3
/// - Parameter nums: 完整数字
/// - Parameter begin: 当前指定开始组合的位置
/// - Parameter pre: 组合前头的内容
func subsetsCore1(_ nums: [Int],_ begin:Int,_ pre:inout [Int]) {
	
	resultArray.append(pre)
	
	
	for i in begin..<nums.count {
		
		pre.append(nums[i])
		
		
		subsetsCore1(nums, i+1, &pre)
		
		pre.removeLast()
		
	}
	
}


///题目三：给定一个可能包含重复元素的整数数组 nums，返回该数组所有可能的子集（幂集）。
//一样先搞顺序，有重复就跳过，并且都是从下标序号开始用后面的b排序
func subsetsWithDup(_ nums: [Int]) -> [[Int]] {
	
	let newNums = nums.sorted()
	
	var stack:Stack<Int> = Stack()
	
	subsetsWithDup(newNums, &stack, 0)
	return resultArray
}

func subsetsWithDup(_ nums:[Int],_ useArray:inout Stack<Int>,_ current:Int){
	
	resultArray.append(useArray.sequence)
	
	for index in current..<nums.count {
		
		if index > current && nums[index] == nums[index-1] {
			continue
		}
		
		
		useArray.push(element: nums[index])
		
		subsetsWithDup(nums, &useArray, index+1)
		
		useArray.pop()
		
		
	}
}




///题目四：给定一个可包含重复数字的序列，返回所有不重复的全排列（回溯+去支）  这里用了的妙处，就是先把数组排列了，就方便找重复，上一次用完，如果连续相等，那么这次相当于同一层平行，就不会再用了
func permuteUnique(_ nums: [Int]) -> [[Int]] {
	
	if nums.count == 0 || nums.count == 1{
		return [nums]
	}
	
	var useArray:[Int] = []
	
	
	for _ in 0..<nums.count {
		useArray.append(0)
	}
	
	var preArray:[Int] = []
	
	let newNums = nums.sorted()
	
	permuteUniqueCore(newNums,&preArray, &useArray, 0)
	
	return resultArray
}


func permuteUniqueCore(_ nums:[Int],_ preArray:inout [Int] ,_ useArray:inout [Int],_ currntRow:Int) {
	
	if currntRow == nums.count {
		resultArray.append(preArray)
		

		return
	}
	
	for index in 0..<nums.count {
		
		
		
		if useArray[index] == 0 {
			
			if index > 0 &&  nums[index - 1] == nums[index] && useArray[index-1] == 0{
				continue
			}
			
			
			useArray[index] = 1
			
	
			preArray.append(nums[index])
			
			permuteUniqueCore(nums, &preArray, &useArray, currntRow+1)
			
			
			useArray[index] = 0
			
//			row.removeLast()
//
//			rowArray[currntRow] = row
			
			
			preArray.removeLast()
			
		}
		
	}
	
}


///题目五：给定一个数组和一个目标数，找出数组中的不重复使用数字的和为目标值的组合  上题一样，先排序就好了,如何使用不重复，就是每次遍历的数字都从当前序号看是
func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
	if candidates.count == 0 {
		return []
	}
	if candidates.count == 1  {
		if candidates[0] == target {
			return [candidates]
		}else{
			return []
		}
	}
	
	let newArray = candidates.sorted()
	
	var stack:Stack<Int> = Stack()
	
	
	
	combinationSum2Core(newArray, &stack, target,0)
	
	
	return resultArray
}


func combinationSum2Core(_ candidates: [Int],_ useArray:inout Stack<Int> , _ target: Int,_ current:Int) {
	
	
	if target < 0  {
		return
	}
	
	if  target == 0 {
		resultArray.append(useArray.sequence)
		return
	}
	
	for index in current..<candidates.count {
			
		if candidates[index] > target {
			continue
		}
			
		if index > current && candidates[index]  == candidates[index-1]{
			continue
		}
		
		useArray.push(element: candidates[index])
		
		combinationSum2Core(candidates, &useArray, target-candidates[index], index+1)
		
		useArray.pop()
			
		
		
	}
}


///题目六  给定一个无重复元素的数组 candidates 和一个目标数 target ，找出 candidates 中所有可以使数字和为 target 的组合 candidates 中的数字可以无限制重复被选取。
func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
	//不用排序了   每次都重新遍历数组就好了， 从当前数字开始！
	
	if candidates.count == 0 {
		return []
	}

	
	var stack:Stack<Int> = Stack()
	combinationSum(candidates, &stack, target, 0)
	return resultArray
}


func combinationSum(_ candidates: [Int],_ useArray:inout Stack<Int>,_ target: Int,_ current: Int) {
	
	if target == 0 {
		resultArray.append(useArray.sequence)
		return
	}
	
	if target < 0 {
		return
	}
	
	for index in current..<candidates.count {
		
		useArray.push(element: candidates[index])
		
		combinationSum(candidates, &useArray, target-candidates[index], index)
		
		useArray.pop()
	}
	
}







//MARK:测试用例


/* 			--------------------------------------------------------------------------------------------------------------------			*/

//let a = [2,3,1,0,2,5,3]
//let b = [2,3,5,4,3,2,6,7]
//let c:[Int] = []
//var d = Array("We are happy.")

//var l1: ListNode<Int>? = ListNode(value: 1, next: nil)
//let l2 = ListNode(value: 1, next: nil)
//let l3 = ListNode(value: 1, next: nil)
//let l4 = ListNode(value: 2, next: nil)
//let l5 = ListNode(value: 3, next: nil)
//let l6 = ListNode(value: 11, next: nil)
//let l7 = ListNode(value: 13, next: nil)
////
//l1!.pNext = l2
//l2.pNext = l3
//l3.pNext = l4
//l4.pNext = l5
//l5.pNext = l6
//l6.pNext = l7
//
//
//var n1: ListNode<Int>? = ListNode(value: 2, next: nil)
//let n2 = ListNode(value: 4, next: nil)
//let n3 = ListNode(value: 6, next: nil)
//let n4 = ListNode(value: 8, next: nil)
//let n5 = ListNode(value: 10, next: nil)
//let n6 = ListNode(value: 12, next: nil)
//let n7 = ListNode(value: 14, next: nil)
//
//n1!.pNext = n2
//n2.pNext = n3
//n3.pNext = n4
//n4.pNext = n5
//n5.pNext = n6
//n6.pNext = n7


//
//PrintListReversingly_Recursively(pHead: l1)

//let preorder = [1,2,4,7,3,5,6,8]
//let inorder = [4,7,2,1,5,3,8,6]
//
//
//
//let z = Contruct(preorder: preorder, inorder: inorder)
//
//print(z)

var a:[Int] = [2,4,5,8,9]//[17,14,13,23,22,10,5,4,3,2,1,100]
////BubbleSort(list: &a)
//InsertSort(list: &a)
//InsertSort1(list: &a)
////ShellSort(list: &a)
//ShellSort1(list: &a)
////let z = MergeSort(list: a)
////print(z)
//QuickSort(list: &a)
//HeapSort(list: &a)
HeapAdjust(list: &a, s: 0, m: 4)
//HeapSort1(list: &a, n: 9)
//AdjustHeap(list: &a, index: 0, length: 6)
//BuildMaxHeap(list: &a)
//print(a)
//let z = Min(list: a, start: 0, end: 4)
//print(z)

//let a:[Character] = ["a","b","t","g","c","f","c","s","j","d","e","h"]
//
//let z = HasPath(list: a, rows: 3, columns: 4, matchStr: ["b","f","c","e"])

//let z1 = MaxProductAfterCutting_Solution1(length: 8)
//let z2 = MaxProductAfterCutting_Solution2(length: 10)
//print("\(z1),\(z2)")
//let z = NumberOf1(n:0b00000111)
//let z1 = NumberOf1_1(n:0b00000111)
//print(z1)
//print(MyPower(base: 3, exponent: 4))

//Print1ToMaxOfNDigits(n: 3)



//DeleteDuplication(pHead: &l1)
//let z = Match(str: ["a","a","a"], pattern: ["a","b","*","a","c","*","a"])
//print(z)

//let a:[Character] = ["1","2","E","+","1",".","1"]
//let b:[Character] = ["1","0"]
//let c:[Character] = ["5","e","2"]
//let d:[Character] = ["1",".","1",".","3"]
//let e:[Character] = ["1","a","3",".","1","6"]

//let z = IsNumberic(str: a)
//print(z)
//var a = [1,2,3,4,5]
//
//ReorderOddEvent(pdata: &a)

//let z = FindKthToTail(pListHead: l1!, k: 0)
//let z = EntryNodeOfLoop(pHead: l1!)
//print(z)

//var l8:ListNode<Int>? = ListNode(value: 8, next: nil)
//
//let z = ReverseList(pHead: &l8)
//print(z)

//var l8:ListNode<Int>? = nil//ListNode(value: 8, next: nil)
//var n8:ListNode<Int>? = nil//ListNode(value: 8, next: nil)
//
//let z = Merge2(pHead1: &l1, pHead2: &n1)
//print(z)

//let a = BinaryTreeNode(value: 1, left: nil, right: nil)
//let b = BinaryTreeNode(value: 2, left: nil, right: nil)
//let c = BinaryTreeNode(value: 3, left: nil, right: nil)
//let d = BinaryTreeNode(value: 4, left: nil, right: nil)
//let e = BinaryTreeNode(value: 5, left: nil, right: nil)
//let f = BinaryTreeNode(value: 6, left: nil, right: nil)
//let g = BinaryTreeNode(value: 7, left: nil, right: nil)
//let h = BinaryTreeNode(value: 8, left: nil, right: nil)
//let i = BinaryTreeNode(value: 9, left: nil, right: nil)
//let j = BinaryTreeNode(value: 10, left: nil, right: nil)
//let k = BinaryTreeNode(value: 11, left: nil, right: nil)
//let l = BinaryTreeNode(value: 12, left: nil, right: nil)
//let m = BinaryTreeNode(value: 13, left: nil, right: nil)
//let n = BinaryTreeNode(value: 14, left: nil, right: nil)
//let o = BinaryTreeNode(value: 15, left: nil, right: nil)
//
//let a = BinaryTreeNode(value: 10, left: nil, right: nil)
//
//let b = BinaryTreeNode(value: 6, left: nil, right: nil)
//let c = BinaryTreeNode(value: 14, left: nil, right: nil)
//
//let d = BinaryTreeNode(value: 4, left: nil, right: nil)
//let e = BinaryTreeNode(value: 8, left: nil, right: nil)
//
//let f = BinaryTreeNode(value: 12, left: nil, right: nil)
//let g = BinaryTreeNode(value: 16, left: nil, right: nil)

//a.pLeft = b
//a.pRight = c
//
//b.pLeft = d
//b.pRight = e
//
//c.pLeft = f
//c.pRight = g

//let a = ComplexListNode(value: 1, pNext: nil, pSibling: nil)
//let b = ComplexListNode(value: 2, pNext: nil, pSibling: nil)
//let c = ComplexListNode(value: 3, pNext: nil, pSibling: nil)
//let d = ComplexListNode(value: 4, pNext: nil, pSibling: nil)
//let e = ComplexListNode(value: 5, pNext: nil, pSibling: nil)
//
//a.pNext = b
//b.pNext = c
//c.pNext = d
//d.pNext = e
//
//a.pSibling = c
//b.pSibling = e
//e.pSibling = b
//
//print(CopyComplexListNode(pHead: a) as Any)
//
//a.pLeft = b
//a.pRight = c
//
//b.pLeft = d
//b.pRight = e
//
//c.pLeft = f
//c.pRight = g
//
//
//d.pLeft = h
//d.pRight = i
//
//e.pLeft = j
//e.pRight = k
//
//f.pLeft = l
//f.pRight = m
//
//g.pLeft = n
//g.pRight = o

//
//
//x.pLeft = y
//x.pRight = z
//
//let result = HasSubTree(treeA: a, treeB: x)
//
//print(result)


//let a:[[Int]] = []
//
//
//let result = spiralOrder(a)
//print(result)

//let a = [2,1,0]
//let b = [1,2,0]
//
//print(validateStackSequences(a, b))

//print(levelOrder(a))
//print(PrintTreeInZhi(pRoot: a))
//print(VerifySquenceOfBST(sequence: [5,7,6,9,11,10,8]))
//
//let s = Solution()
//
//print(s.pathSum(a, 22))

//print(Convert(pRootOfTree: a))

//var a:[Character] = ["a","b","c"]
//
//Permutation(pStr: &a)


//let a = [1,2,2]

//print(permuteUnique(a))

//print(subsetsWithDup(a))
