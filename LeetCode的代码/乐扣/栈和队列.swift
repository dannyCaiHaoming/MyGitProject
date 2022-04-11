//
//  栈和队列.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2022/3/24.
//  Copyright © 2022 蔡浩铭. All rights reserved.
//

import Foundation

/*
 栈：
 只能在一端进行操作，一般栈顶。先进后出，一般可以用来处理对称的问题。
 */


/*
 队列
 特殊线性表，能在头尾两端进行操作。
 先进先出。
 
 双端队列
 可以在头尾两端都可以进行添加和删除
 */

class 栈和队列: Do {
    static func doSomething() {
        
    }
    
    
    //MARK: 20. 有效的括号
    /*
     给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串 s ，判断字符串是否有效。
     有效字符串需满足：
     左括号必须用相同类型的右括号闭合。
     左括号必须以正确的顺序闭合。
     
     "({{{{}}}))"
     
     
     ( {
     
     */
    func isValid(_ s: String) -> Bool {
        var stackArr:[String] = []
        for c in s {
            stackArr.append(String(c))
        }
        var tmp:[String] = []
        while !stackArr.isEmpty {
            let last = stackArr.popLast()!
            if let tmpL = tmp.last {
                if tmpL == "}" && last == "{" {
                    tmp.popLast()
                }else if tmpL == "]" && last == "[" {
                    tmp.popLast()
                }else if tmpL == ")" && last == "(" {
                    tmp.popLast()
                }else {
                    tmp.append(last)
                }
            }else {
                tmp.append(last)
                continue
            }
        }
        return tmp.isEmpty && stackArr.isEmpty
    }
    
    
    //MARK: 155. 最小栈
    /*设计一个支持 push ，pop ，top 操作，并能在常数时间内检索到最小元素的栈。
     实现 MinStack 类:
     MinStack() 初始化堆栈对象。
     void push(int val) 将元素val推入堆栈。
     void pop() 删除堆栈顶部的元素。
     int top() 获取堆栈顶部的元素。
     int getMin() 获取堆栈中的最小元素。

     
     思路:
     两个栈，一个栈正常存储数据，另一个栈存储每次的最小值。
     */
    
    
    //MAR: 232. 用栈实现队列
    /*
     请你仅使用两个栈实现先入先出队列。队列应当支持一般队列支持的所有操作（push、pop、peek、empty）：

     实现 MyQueue 类：

     void push(int x) 将元素 x 推到队列的末尾
     int pop() 从队列的开头移除并返回元素
     int peek() 返回队列开头的元素
     boolean empty() 如果队列为空，返回 true ；否则，返回 false
     */
    class MyQueue {
        //队列 先进先出
        var left:[Int] = []
        var right:[Int] = []

        init() {

        }
        
        func push(_ x: Int) {
            self.right.append(x)
        }
        
        func pop() -> Int {
            if self.left.isEmpty {
                while !self.right.isEmpty {
                    self.left.append(self.right.popLast()!)
                }
            }
            return self.left.popLast()!
        }
        
        func peek() -> Int {
            if self.left.isEmpty {
                while !self.right.isEmpty {
                    self.left.append(self.right.popLast()!)
                }
            }
            return self.left.last!
        }
        
        func empty() -> Bool {
            return self.left.isEmpty && self.right.isEmpty
        }
    }
    
    
    //MARK:  239. 滑动窗口最大值
    /*
     给你一个整数数组 nums，有一个大小为 k 的滑动窗口从数组的最左侧移动到数组的最右侧。你只可以看到在滑动窗口内的 k 个数字。滑动窗口每次只向右移动一位。
     返回 滑动窗口中的最大值 。
     
     输入：nums = [1,3,-1,-3,5,3,6,7], k = 3
     输出：[3,3,5,5,6,7]
     解释：
     滑动窗口的位置                最大值
     ---------------               -----
     [1  3  -1] -3  5  3  6  7       3
      1 [3  -1  -3] 5  3  6  7       3
      1  3 [-1  -3  5] 3  6  7       5
      1  3  -1 [-3  5  3] 6  7       5
      1  3  -1  -3 [5  3  6] 7       6
      1  3  -1  -3  5 [3  6  7]      7
     
     
     1. 暴力法。遍历nums长度，每次查找k个数，找出最大值，找出length-k+1个数。
     2. 双端队列。队尾到队头，构造一个小到大的队列，并且保证移动过程中，队列中的node，还是在滑动窗口中。
     滑动到一个数，需要将队列中比这个数要小的数，都从队列移除，直到队尾大于这个数，或者队尾为空。
     3. 还是暴力法基础上，每次记录下最大值的下标，然后滑动，判断最大值下标是否还在滑动窗口内，在的话直接用。
     不在的话，从滑动窗口找到最大值。 
     */
    
    
    
    
    //MARK:  最大二叉树题目变种，找出每个节点的父节点
    /*
     
     第一步：
    找出左右第一个比它大的数。
    利用栈找出左右第一个比它大的数。
     第二步，比较左右两边哪个大。
     
    将栈底到栈顶，是单调递减。
     */
//    int *parentIndexes(int *nums,int size) {
//        int *lis = (int *)malloc(sizeof(int) * size);
//        int *ris = (int *)malloc(sizeof(int) * size);
//
//        struct Stack *stack = (struct Stack *)malloc(sizeof(struct Stack));
//        for (int i = 0 ; i < size; i++) {
//            while (!isEmpty(stack) && nums[i] > peek(stack)) {
//                ris[pop(stack)] = i;
//            }
//            lis[i] = isEmpty(stack) ? -1 : nums[peek(stack)];
//            push(stack, nums[i]);
//        }
//        return NULL;
//    }
    
    
    //MAR: 739. 每日温度
    /*
     给定一个整数数组 temperatures ，表示每天的温度，返回一个数组 answer ，其中 answer[i] 是指在第 i 天之后，才会有更高的温度。如果气温在这之后都不会升高，请在该位置用 0 来代替。

     输入: temperatures = [73,74,75,71,69,72,76,73]
     输出: [1,1,4,2,1,1,0,0]
     
     
     使用上面最大二叉树变形，就能找到左边或者右边比我大的树。
     实际只需要用到右边比我大的数的下标值，减去自身的下标值
     */
//    int* dailyTemperatures(int* temperatures, int temperaturesSize, int* returnSize){
//        if (temperatures == NULL || temperaturesSize == 0) {
//            *returnSize = 0;
//            return NULL;
//        }
//        int *result = (int *)malloc(sizeof(int) * temperaturesSize);
//        struct Stack *stack = (struct Stack *)malloc(sizeof(struct Stack));
//        stack->Data = (int *)malloc(sizeof(int) * 100);
//        stack->topIdx = 0;
//        for (int i = 0; i < temperaturesSize; i++) {
//            while (!isEmpty(stack) && temperatures[peek(stack) < temperatures[i]]) {
//                result[peek(stack)] = i - peek(stack);
//                pop(stack);
//            }
//            push(stack, i);
//        }
//        return result;
//    }
}
