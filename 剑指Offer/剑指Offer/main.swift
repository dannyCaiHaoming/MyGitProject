//
//  main.swift
//  剑指Offer
//
//  Created by Danny on 2019/8/24.
//  Copyright © 2019 Danny. All rights reserved.
//

import Foundation


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
class ListNode<T> {
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
    

    let index = Partition(list: &list, start: 0, end: list.count - 1)
    
    var left = Array(list[0..<index])
    var right = Array(list[index..<list.count])
    QuickSort(list: &left)
    QuickSort(list: &right)
    
    list = left + right
    
    print(list)
    
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
    
    
    return index
    
}


///堆排序

///构建大顶堆
func BuildMaxHeap(list:inout [Int]){
    if list.count/2-1 < 0 {
        return
    }
    for i in (0...list.count/2-1).reversed() {
        AdjustHeap(list: &list, index: i)
    }
}


func AdjustHeap(list:inout [Int],index:Int){
    
    var maxIndex = index
    
    let left = 2*index+1
    let right = 2*index+2
    
    //存在左子节点
    if left < list.count && list[left] > list[maxIndex] {
        maxIndex = left
    }
    
    //存在右子节点
    if right < list.count && list[right] > list[maxIndex] {
        maxIndex = right
    }
    
    if maxIndex != index {
        list.swapAt(maxIndex, index)
        AdjustHeap(list: &list, index: maxIndex)
    }
}


func HeapSort(list: inout [Int]) {
    BuildMaxHeap(list: &list)
    
    var i = list.count - 1
    
    while i > 0 {
        list.swapAt(i, 0)
        var l = Array(list[0..<i])
        let r = Array(list[i..<list.count])
        BuildMaxHeap(list: &l)
        list = l + r
        i -= 1
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



//let a = [2,3,1,0,2,5,3]
//let b = [2,3,5,4,3,2,6,7]
//let c:[Int] = []
//var d = Array("We are happy.")

//let l1 = ListNode(value: 1, next: nil)
//let l2 = ListNode(value: 2, next: nil)
//let l3 = ListNode(value: 3, next: nil)
//let l4 = ListNode(value: 4, next: nil)
//let l5 = ListNode(value: 5, next: nil)
//
//l1.pNext = l2
//l2.pNext = l3
//l3.pNext = l4
//l4.pNext = l5
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

//var a:[Int] = [1,0,1,1,1]
////BubbleSort(list: &a)
////InsertSort(list: &a)
////ShellSort(list: &a)
////let z = MergeSort(list: a)
////print(z)
////QuickSort(list: &a)
////BuildMaxHeap(list: &a)
//let z = Min(list: a, start: 0, end: 4)
//print(z)

let a:[Character] = ["a","b","t","g","c","f","c","s","j","d","e","h"]

let z = HasPath(list: a, rows: 3, columns: 4, matchStr: ["b","f","c","e"])
