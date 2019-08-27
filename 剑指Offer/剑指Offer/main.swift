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
print(FragJump(n: 3))
