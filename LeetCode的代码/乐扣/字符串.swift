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
        
//        print(t.reverseParentheses("(u(love)i)"))
    }
    
    func reverseString(str:String) -> String {
           
           var arr = Array(str)

           let count:Int = arr.count
           
           for i in 0..<count / 2 {
            arr.swapAt(i, count - i - 1)
           }
           
           return String(arr)
       }
    
    // MARK: 3.无重复字符的最长字符
    func lengthOfLongestSubstring(_ s: String) -> Int {

        
        return 0
    }
    
    //MARK: 5.最大回文子串
    /*
     给你一个字符串 s，找到 s 中最长的回文子串。
     输入：s = "babad"
     输出："bab"
     解释："aba" 同样是符合题意的答案。
     */

    /*
     回文串的规律：
     1. 从中心向两边扩充，即只要有一个中心i，然后分别向i-1,i+1判断是否相等
     2. 一段长的回文串，减去一头一尾，得到的仍然是回文串,即s[i+1]==s[j-1]
     
     因此衍生出两种解法：
     1. 暴力
     2. 动态规划
     
     */

    /*
     自己写的暴力解法，会超出时间限制。
     这个方法的问题在：
     (1)其实判断分为三种，是有点多余的，其实只需要从i,i+1开始中心扩展即可
     (2)使用了系统函数，每一步记录的是字符串，且用字符串获取长度的方法，在超长字符串的时候，会超出时间。
     
     吐了：还是超时
     */
    func longestPalindrome1(_ s: String) -> String {
        var largets = String(s[s.index(s.startIndex, offsetBy: 0)])
        if s.count < 2 {
            return s
        } else if s.count == 2 {
            return s[s.index(s.startIndex, offsetBy: 0)] == s[s.index(s.startIndex, offsetBy: 1)] ? s : largets
        }
        
        for i in 1..<s.count {
            // 先判断i,i-1 相等
            // 再判断i-1,i+1相等
            // 最后判断 1,i+1相等
            var left = i-1
            var right = i
            while left >= 0,
                  right < s.count,
                  s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)] {
                left -= 1
                right += 1
            }
            right -= 1
            left += 1
            if left <= right,
               s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)],
               right - left + 1 > largets.count {
                largets = String(s[s.index(s.startIndex, offsetBy: left)...s.index(s.startIndex, offsetBy: right)])
            }
            
            left = i-1
            right = i+1
            while left >= 0,
                  right < s.count,
                  s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)] {
                left -= 1
                right += 1
            }
            right -= 1
            left += 1
            if left <= right,
               s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)],
               right - left + 1 > largets.count {
                largets = String(s[s.index(s.startIndex, offsetBy: left)...s.index(s.startIndex, offsetBy: right)])
            }
            
            left = i
            right = i+1
            while left >= 0,
                  right < s.count,
                  s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)] {
                left -= 1
                right += 1
            }
            right -= 1
            left += 1
            if left <= right,
               s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)],
               right - left + 1 > largets.count {
                largets = String(s[s.index(s.startIndex, offsetBy: left)...s.index(s.startIndex, offsetBy: right)])
            }
        }
        return largets
    }

    func longestPalindrome1_1(_ s: String) -> String {
        
        if s.count < 2 {
            return s
        }
        
    //    func expandCenter(s:String,left: Int,right: Int) -> String {
    //        var t_left = left
    //        var t_right = right
    //        while t_left >= 0,
    //              t_right < s.count,
    //              t_left <= t_right,
    //              s[s.index(s.startIndex, offsetBy: t_left)] == s[s.index(s.startIndex, offsetBy: t_right)]{
    //            t_left -= 1
    //            t_right += 1
    //        }
    //        t_left += 1
    //        t_right -= 1
    //        if t_left >= 0,
    //           t_right < s.count,
    //           t_left <= t_right,
    //           s[s.index(s.startIndex, offsetBy: t_left)] == s[s.index(s.startIndex, offsetBy: t_right)] {
    //            return String(s[s.index(s.startIndex, offsetBy: t_left)...s.index(s.startIndex, offsetBy: t_right)])
    //        }
    //        return ""
    //    }
        func expandCenterLength(s:String,left: Int,right: Int) -> Int {
            var t_left = left
            var t_right = right
            while t_left >= 0,
                  t_right < s.count,
                  t_left <= t_right,
                  s[s.index(s.startIndex, offsetBy: t_left)] == s[s.index(s.startIndex, offsetBy: t_right)]{
                t_left -= 1
                t_right += 1
            }
            return t_right - t_left - 1;
        }
        
        
        var start = 0
        var end = 0
        
        for i in 0..<s.count {
            // 奇数
            let a = expandCenterLength(s: s, left: i, right: i)
            // 偶数
            let b = expandCenterLength(s: s, left: i, right: i+1)
                
            let maxValue = max(a, b)
            
            if maxValue > end - start {
                start = i - (maxValue-1)/2
                end = i + maxValue/2
            }

        }
        
        return String(s[s.index(s.startIndex, offsetBy: start)...s.index(s.startIndex, offsetBy: end)])
        
    }
    
    
    //MARK: 242. 有效的字母异位词
    /*
     给定两个字符串 s 和 t ，编写一个函数来判断 t 是否是 s 的字母异位词。
     注意：若 s 和 t 中每个字符出现的次数都相同，则称 s 和 t 互为字母异位词。

     思路完全可以和383一样
     */
//    "rat"
//    "car"
    func isAnagram(_ s: String, _ t: String) -> Bool {
        if s.count != t.count {
            return false
        }
        var table:[Int] = .init(repeating: 0, count: 26)
        for i in 0..<s.count {
            let str = (s as NSString).substring(with: .init(location: i, length: 1))
            table[Int(UnicodeScalar(str)?.value ?? 0) - (Int(UnicodeScalar("a").value) )] += 1
        }
        for i in 0..<t.count {
            let str = (t as NSString).substring(with: .init(location: i, length: 1))
            table[Int(UnicodeScalar(str)?.value ?? 0) - (Int(UnicodeScalar("a").value) )] -= 1
            if table[Int(UnicodeScalar(str)?.value ?? 0) - (Int(UnicodeScalar("a").value) )] < 0 {
                return false
            }
        }
        return true
    }
    
    //MARK: 383. 赎金信
    /*
     给你两个字符串：ransomNote 和 magazine ，判断 ransomNote 能不能由 magazine 里面的字符构成。
     如果可以，返回 true ；否则返回 false 。
     magazine 中的每个字符只能在 ransomNote 中使用一次。

     最快的方式，因为都是字母，因此可以用一个能容纳所有字母长度的数组，然后遍历magazine的内容，遇到就在数组对应的字母增加1，表示能用的次数。
     然后在ransomNote里面遍历，遇到能使用数组的内容为0，则表示不能遍历出来。
     */
    func canConstruct(_ ransomNote: String, _ magazine: String) -> Bool {
        var arr: [String] = []
        for c in magazine {
            arr.append(String(c))
        }
        for c in ransomNote {
            if let index = arr.firstIndex(where: { $0 == String(c) }){
                arr.remove(at: index)
            }else {
                return false
            }
        }
        return true
    }
    
    //MARK: 387. 字符串中的第一个唯一字符
    /*
     给定一个字符串 s ，找到 它的第一个不重复的字符，并返回它的索引 。如果不存在，则返回 -1 。
     */
    func firstUniqChar(_ s: String) -> Int {
        var dict:[String: Int] = [:]
        for c in s {
            let str = String(c)
            if let count = dict[str] {
                dict[str] = count + 1
            }else {
                dict[str] = 1
            }
        }
        for i in 0..<s.count{
            let str = (s as NSString).substring(with: .init(location: i, length: 1))
            if dict[str] == 1 {
                return i
            }
        }
        return -1
    }
    
    
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
    
    
    
    
    //MARK: 面试题 01.09. 字符串轮转
    func isFlipedString(_ s1: String, _ s2: String) -> Bool {
        if s1.isEmpty && s2.isEmpty {
            return true
        }
        if s1.count != s2.count {
            return false
        }
        let tmp = s1 + s1
        return tmp.contains(s2)
    }
    
    
    
}
