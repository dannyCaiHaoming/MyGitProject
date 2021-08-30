//
//  字符串.swift
//  乐扣
//
//  Created by Danny on 2021/8/24.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

import Foundation

protocol Do {
   static func doSomething()
}

class 字符串: Do {
    static func doSomething() {
        
        let t = 字符串()
        
        print(t.reverseParentheses("(u(love)i)"))
    }
    
    func reverseString(str:String) -> String {
           
           var arr = Array(str)

           let count:Int = arr.count
           
           for i in 0..<count / 2 {
            arr.swapAt(i, count - i - 1)
           }
           
           return String(arr)
       }
    
    
    //MARK: 3. 无重复字符的最长子串
    /*
         给定一个字符串 s ，请你找出其中不含有重复字符的 最长子串 的长度。
         
         输入: s = "abcabcbb"
         输出: 3
         解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
    */
    
    
    
    //MARK: 1190. 反转每对括号间的子串
    /*
     给出一个字符串 s（仅含有小写英文字母和括号）。
     请你按照从括号内到外的顺序，逐层反转每对匹配括号中的字符串，并返回最终的结果。
     注意，您的结果中 不应 包含任何括号。
     */
    /*
     输入：s = "(abcd)"
     输出："dcba"
     */
    /*
     思路：
     递归，拆解为，每一次将括号内的内容反转，然后返回上级使用
     遇到问题：
     当我递归回去之后，下标的位置无法恢复，存在重复添加和递归元素已经算入的内容，
     答案增加了一个全局变量，用户记录每次递归算到的位置，漂亮
     */
    var i = 0
    func reverseParentheses(_ s: String) -> String {
        var r: String = ""
        
        while i < s.count {
            let c = s[s.index(s.startIndex, offsetBy: i)]
            if c == "(" {
                i += 1
                let next = reverseParentheses(s)
                r.append(next)
            }else if c == ")"{
                i += 1
                return reverseString(str: r)
            }else {
                r.append(c)
                i += 1
            }
        }
        return r
    }
    
    
    
    
    
    
    
}
