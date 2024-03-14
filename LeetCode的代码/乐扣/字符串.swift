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

        let r = t.longestPalindrome("babad")
        print(r)
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

    // 动态规划
    /*
     我想用一个一维数组，记录每个字符串，已经到下一位字符串的最大回文。
     但是遇到“ccc” ，“cccc”，奇偶问题时，到底是加一个还是加两个。
     但是，即使增加了前面是要一个还是两个判断。
     对于"bananas" 还是无能为力。因为这类动态规划，是记录每一步，能走多少，而不是每一步最优。  // 132个测试用例

     */
    
//    1.回文串，即由最小的两个回文，在左右加相等的字符
//    2.所以用单向滑动窗口，[i,j]为边界递增来计算
//    3.单个[i,j]如果相等，那么[i,j]是否是回文是由[i+1,j-1]来得出结果
//    4.当j-i之间只有两个或者一个字符的时候，且相等的时候，必为回文
    
    /*
     正确动态规划思路：
     dp[i][j] 记录i到j是否回文。
     当i-j <= 2 或者 i-1，j+是回文
     */
    
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

//    func longestPalindrome(_ s: String) -> String {
//        if s.count == 1 {
//            return s
//        }
//        let sArr = Array(s)
//        let count = s.count
//        // 第二个值，代表是所有值是否一致
//        var result:[(Int,Bool)] = .init(repeating: (1,true), count: count)
//        for i in 1..<s.count {
//            if sArr[i] == sArr[i-1] {
//                let last = result[i-1]
//                if last.1 {
//                    result[i] = (result[i-1].0 + 1,true)
//                    continue
//                }
//            }
//            let last = result[i-1]
//            let count = result[i-1].0
//            if i - count - 1 >= 0 {
//                if sArr[i - count - 1] == sArr[i] {
//                    result[i] = (result[i-1].0 + 2,false)
//                }
//            }
//            // 再往前一个
//            if i-2 >= 0 {
//                let last2 = result[i-1]
//            }
//            
//            
//        }
//        var max = 1
//        var end = 1
//        for i in 0..<result.count {
//            if result[i].0 > max {
//                max = result[i].0
//                end = i
//            }
//        }
//        let tmp = sArr[end-max+1...end]
//        //
//        return  String(tmp)
//    }


//     怎么样都是对每一个字符，想两边进行扩张。
//     1. 对选中字符，以自身，和下一个为回文开始
//     2. 对选中字符，以自身为回文。  // 顶多去到113个
//
//     超时。。无语，比我自己第一版的得分还少。
//     */
//    func longestPalindrome(_ s: String) -> String {
//        if s.count == 1 {
//            return s
//        }
//        if Array(s) == Array(s.reversed()) {
//            return s
//        }
//        var start = 0
//        var end = 0
//        for i in 0..<s.count {
//            let l1 = expandAroundCenter(s: s, left: i, right: i)
//            let l2 = expandAroundCenter(s: s, left: i, right: i+1)
//            var len = l1
//            if l2 > l1 {
//                len = l2
//            }
//            if len-1 > end - start {
//                start = i - (len-1)/2
//                end = i + len / 2
//            }
//        }
//        // babad
//        // i = 1
//        // max = 3
//        let sArray = Array(s)
//        let result = sArray[start...end]
//        return String(result)
//    }
//
//    func expandAroundCenter(s:String,left: Int,right: Int) -> Int {
//        let sArray = Array(s)
//        var tl = left
//        var tr = right
//        while tl >= 0,
//              tr < s.count,
//              sArray[tl] == sArray[tr] {
//            tl -= 1
//            tr += 1
//        }
//
//        return tr - tl - 1
//    }
//    func longestPalindrome1(_ s: String) -> String {
//        var largets = String(s[s.index(s.startIndex, offsetBy: 0)])
//        if s.count < 2 {
//            return s
//        } else if s.count == 2 {
//            return s[s.index(s.startIndex, offsetBy: 0)] == s[s.index(s.startIndex, offsetBy: 1)] ? s : largets
//        }
//
//        for i in 1..<s.count {
//            // 先判断i,i-1 相等
//            // 再判断i-1,i+1相等
//            // 最后判断 1,i+1相等
//            var left = i-1
//            var right = i
//            while left >= 0,
//                  right < s.count,
//                  s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)] {
//                left -= 1
//                right += 1
//            }
//            right -= 1
//            left += 1
//            if left <= right,
//               s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)],
//               right - left + 1 > largets.count {
//                largets = String(s[s.index(s.startIndex, offsetBy: left)...s.index(s.startIndex, offsetBy: right)])
//            }
//
//            left = i-1
//            right = i+1
//            while left >= 0,
//                  right < s.count,
//                  s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)] {
//                left -= 1
//                right += 1
//            }
//            right -= 1
//            left += 1
//            if left <= right,
//               s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)],
//               right - left + 1 > largets.count {
//                largets = String(s[s.index(s.startIndex, offsetBy: left)...s.index(s.startIndex, offsetBy: right)])
//            }
//
//            left = i
//            right = i+1
//            while left >= 0,
//                  right < s.count,
//                  s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)] {
//                left -= 1
//                right += 1
//            }
//            right -= 1
//            left += 1
//            if left <= right,
//               s[s.index(s.startIndex, offsetBy: left)] == s[s.index(s.startIndex, offsetBy: right)],
//               right - left + 1 > largets.count {
//                largets = String(s[s.index(s.startIndex, offsetBy: left)...s.index(s.startIndex, offsetBy: right)])
//            }
//        }
//        return largets
//    }
//
//    func longestPalindrome1_1(_ s: String) -> String {
//
//        if s.count < 2 {
//            return s
//        }
//
//    //    func expandCenter(s:String,left: Int,right: Int) -> String {
//    //        var t_left = left
//    //        var t_right = right
//    //        while t_left >= 0,
//    //              t_right < s.count,
//    //              t_left <= t_right,
//    //              s[s.index(s.startIndex, offsetBy: t_left)] == s[s.index(s.startIndex, offsetBy: t_right)]{
//    //            t_left -= 1
//    //            t_right += 1
//    //        }
//    //        t_left += 1
//    //        t_right -= 1
//    //        if t_left >= 0,
//    //           t_right < s.count,
//    //           t_left <= t_right,
//    //           s[s.index(s.startIndex, offsetBy: t_left)] == s[s.index(s.startIndex, offsetBy: t_right)] {
//    //            return String(s[s.index(s.startIndex, offsetBy: t_left)...s.index(s.startIndex, offsetBy: t_right)])
//    //        }
//    //        return ""
//    //    }
//        func expandCenterLength(s:String,left: Int,right: Int) -> Int {
//            var t_left = left
//            var t_right = right
//            while t_left >= 0,
//                  t_right < s.count,
//                  t_left <= t_right,
//                  s[s.index(s.startIndex, offsetBy: t_left)] == s[s.index(s.startIndex, offsetBy: t_right)]{
//                t_left -= 1
//                t_right += 1
//            }
//            return t_right - t_left - 1;
//        }
//
//
//        var start = 0
//        var end = 0
//
//        for i in 0..<s.count {
//            // 奇数
//            let a = expandCenterLength(s: s, left: i, right: i)
//            // 偶数
//            let b = expandCenterLength(s: s, left: i, right: i+1)
//
//            let maxValue = max(a, b)
//
//            if maxValue > end - start {
//                start = i - (maxValue-1)/2
//                end = i + maxValue/2
//            }
//
//        }
//
//        return String(s[s.index(s.startIndex, offsetBy: start)...s.index(s.startIndex, offsetBy: end)])
//
//    }

    //MARK: 17. 电话号码的字母组合
    var result:[String] = []
    var mark:[Bool] = []
    func letterCombinations(_ digits: String) -> [String] {
        let words: [[String]] = [
            [""],["a","b","c"],["d","e","f"],
            ["g","h","i"],["j","k","l"],["m","n","o"],
            ["p","q","r","s"],["t","u","v"],["w","x","y","z"]
        ]
        var total: [String] = []
        for chr in digits {
            let idx = Int(String(chr))! - 1
            total.append(contentsOf: words[idx])
        }
        mark = .init(repeating: false, count: total.count)
        letterDiGui(start: 0,length: digits.count, digits: digits,words: words,thisRound: "")
        return result
    }

    func letterDiGui(start: Int,
                     length: Int,
                     digits:String,
                     words: [[String]] ,
                     thisRound: String) {
        if length == 0,
           !thisRound.isEmpty {
            result.append(thisRound)
            return
        }
        for i in start..<digits.count {
            if mark[i] {
                continue
            }
            mark[i] = true
            let chr = (digits as NSString).substring(with: .init(location: i, length: 1))
            let idx = Int(chr)!-1
            for word in words[idx] {
                let new = thisRound + word
                letterDiGui(start: start + 1, length: length-1, digits: digits, words: words, thisRound: new)
            }
            mark[i] = false
        }
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


    //MARK: 22. 括号生成
    /*
     n*2 代表步长，然后（，）需要用一个池子放着，递归看每次能用左，还是右
     难度在剪枝，因为有可能"）"出现在第一位或者"（"出现在最后一位，也有可能"())"这种不匹配的情况
     */

    var generateParenthesisResult: [String] = []
    var generateParenthesisCurrent: String = ""
     func generateParenthesis(_ n: Int) -> [String] {

        generateParenthesisBacktrace(cur: 0, left: n, right: n,total: n*2)
        return generateParenthesisResult
    }


    func generateParenthesisBacktrace(cur: Int,left: Int,right: Int,total: Int) {
        // 一位可以是左，可以是右

        if left == 0,
           right == 0 {
            generateParenthesisResult.append(generateParenthesisCurrent)
        } else if left < 0 || right < 0 {
            return
        }

        if cur != total-1 {
            // 左
            generateParenthesisCurrent += "("
            generateParenthesisBacktrace(cur: cur + 1, left: left-1, right: right,total: total)
            generateParenthesisCurrent.removeLast()
        }
        if cur != 0 && left != right {
            generateParenthesisCurrent += ")"
            generateParenthesisBacktrace(cur: cur + 1, left: left, right: right-1,total: total)
            generateParenthesisCurrent.removeLast()
        }


    }

    //MARK: 72. 编辑距离

    /*
     一个很难的动态规划，以至于根本不知道应该用什么方式。---后面不知道用什么方式的时候，可以先瞎想动态规划。
     这类题目，重点关注
     1. 对于题目给出操作分类，怎么依照情况细化。
        如，这题，可对字符进行增删改，那对于两个字符串，就有6种情况。分别对着6种情况进行分析。
        对A增，等于对B减；对A减，等于对B增。对A修改，等于对B修改。
        即可划分为三大类，对A增，对B增，对A修改。
     2. 细分后，思考如何寻找每步最值。
        1.这里，对A增的情况，可以为A时“”，B是“ABC”，则当知道A经过N次修改，得到A为“AB”后，只需要N+1，则得到结果
        2.同理，当A为“ABC”，B为“”时，当B知道经历N次修改后，得到B为”AB“后，只需要N+1则知道结果
        3.当A为”ABC“，B为”ACB”时，当知道A经过N次修改，得到“ACC”后，只需要N+1则知道结果
        特殊，当A为“ABB”，B为“ACB”时，当A经历N次修改，则只需要N次则知道结果。


     */

    func minDistance(_ word1: String, _ word2: String) -> Int {
        let row = word1.count
        let column = word2.count
        var result:[[Int]] = .init(repeating: .init(repeating: 0, count: column+1), count: row+1)

        for i in 0..<row+1 {
            result[i][0] = i
        }
        for j in 0..<column+1 {
            result[0][j] = j
        }

        for i in 1..<row+1 {
            for j in 1..<column+1 {
                let add = result[i-1][j] + 1
                let add2 = result[i][j-1] + 1
                var match = result[i-1][j-1] + 1
                /*
                 因为这里需要记录的是从下标0--i,0---j个元素 因此，dp数组长度是i+1,j+1，下标就是0...i,0...j
                  但是，取字符串的长度，还是0--i-1,0--j-1个。
                 所以i，j对应的结果，是dp[i][j],但是字符串对应的是i-1和j-1
                 */
                if
                    (word1 as NSString).substring(with: .init(location: i-1, length: 1)) == (word2 as NSString).substring(with: .init(location: j-1, length: 1)) {
                    match -= 1
                }
                var min = add
                if add2 < add {
                    min = add2
                }
                if match < min {
                    min = match
                }
                result[i][j] = min
            }
        }
        return result[row][column]
    }

    //MARK: 79. 单词搜索
    /*
     我草。偶尔超时。
     */
    var existMark: [[Bool]] = []
    var res = false
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        let row = board.count
        let column = board[0].count

        existMark = .init(repeating: .init(repeating: false, count: column), count: row)

        for r in 0..<row {
            for c in 0..<column {
                existBacktrace(board: board, word: word,wordIdx: 0,row: r, column: c, totalR: row, totalC: column)
            }
        }

        return res
    }
    let direction_4:[[Int]] = [
        [-1,0],[1,0],
        [0,1],[0,-1]
    ]
    func existBacktrace(board:[[Character]],word: String,wordIdx: Int,row: Int,column: Int,totalR: Int,totalC: Int)  {
        guard row >= 0 ,
              row < totalR,
              column >= 0,
              column < totalC,
              existMark[row][column] == false,
              wordIdx < word.count,
              word[word.index(word.startIndex, offsetBy: wordIdx)] ==  board[row][column] else {
            return
        }
        if wordIdx == word.count - 1 {
            res = true
            return
        }
        existMark[row][column] = true
        for d in direction_4 {
            let newR = row + d[0]
            let newC = column + d[1]
            existBacktrace(board: board, word: word,wordIdx:wordIdx+1, row: newR, column: newC, totalR: totalR, totalC: totalC)
        }
        existMark[row][column] = false
    }

    //MARK:  139. 单词拆分

    /*
     动态规划

     s，每次查看dict里面是否还存在能够去掉的。

     超时。

     动态规划，最重要是一个状态记录。dp数组
     官方题解： 每个字符，就是看当前字典单词批匹配，和减去单词后，之前的状态数组状态。
     */
    func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
        let arr = Array(s)
        var dp:[Bool] = .init(repeating: false, count: s.count + 1)

        dp[0] = true

        for i in 1...s.count {
            for word in wordDict {
                if word.count <= i {
                    dp[i] = dp[i] || (dp[i-word.count] && String(arr[i-word.count..<i]) == word)
                }
            }
        }
        return dp[s.count]
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

    // MARK: 438.找到字符串中所有字母异位词
    /*
     超时。。
     */
    func findAnagrams(_ s: String, _ p: String) -> [Int] {
        let count = p.count
        if count > s.count {
            return []
        }
        let comP = p.sorted()
        let sArr = Array(s)
        var result:[Int] = []
        for i in 0..<sArr.count {
            if i+count <= sArr.count {
                let tmp = sArr[i..<i+count].sorted()
                if comP == tmp {
                    result.append(i)
                }
            }
        }
        return result
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
