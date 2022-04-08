//
//  动态规划.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2021/8/24.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

import Foundation

/*
 基本：
 1143.最长公共子序列
 53.最大子序和， 面试题42，连续子数组的最大和
 322.零钱兑换  面试题08.11硬币
 300.最长上升子序列
 70.爬楼梯
 198.打家劫舍  213.打家劫舍II
 674.最长连续递增序列
 63.不同路径II
 122.买卖股票最佳时机II
 123.买卖股票的最佳时机III
 188.买卖股票的最佳时机
 714.
 72.编辑距离
 难的：
 673.最长递增子序列的个数
 1235.规划兼职工作
 943.最短超级串
 516.最长回文子序列
 376.摆动序列
 */

class 动态规划: Do {
    
    /*
     动态规划： 核心思想是将一个大问题，分解为可以重叠的子问题，还有最优子结构性质的问题。动态规划通常能分解成很多相似的子问题，然后只需要记下每次计算的子结果，然后再后续计算中，只要重复出现的子结果都能直接查表获取，提高计算效率。
     
     解题步骤：
     1.确定状态
     2.根据状态列转移方程，确定该状态上可以执行的操作，然后是该状态和前一个状态或者前多个状态的关联，
     通常该状态下可执行的操作必定关联我们之前的几个状态
     
     
     
     <1> 什么时候，dp数组需要+1：
    - 题目：1143
     1. 可能是[0][0]行列可以初始化，就不需要额外一行一列。或者考虑第1行，第2列的内容需要怎么扩展
     
     
     */
    
    static func doSomething() {
        
//        print(minimumTotal([[2],[3,4],[6,5,7],[4,1,8,3]]))
        
//        print(backPack(packTotal: 15, itemsQuality: [1,7,7,10]))
        
//        print(canPartition([23,13,11,7,6,5,5]))
//        print(canPartition1([9,5]))
//        print(canPartition2([1,2,5]))
        
//        print(lastStoneWeightII([2,7,4,1,8,1]))
        
        
    }
    
    
    //MARK: 5.最大回文子串
    /*
     给你一个字符串 s，找到 s 中最长的回文子串。
     输入：s = "babad"
     输出："bab"
     解释："aba" 同样是符合题意的答案。
     */
    
    /*
     动态规划：
      规则是，一个i<->j为回文串，那么i+1 <-> j-1
      此外有一个要注意的点事，可以从0开始每次找2个数字找2长度的回文，一直到整个输入字符串长度进行寻找
     
     分析：
     1.回文串，即由最小的两个回文，在左右加相等的字符
     2.所以用单向滑动窗口，[i,j]为边界递增来计算
     3.单个[i,j]如果相等，那么[i,j]是否是回文是由[i+1,j-1]来得出结果
     4.当j-i之间只有两个或者一个字符的时候，且相等的时候，必为回文
     
     */
    func longestPalindrome_2(_ s: String) -> String {
        if s.count < 2 {
            return s
        }
    //    if s.count == 2 {
    //        if s[s.index(s.startIndex, offsetBy: 0)] == s[s.index(s.startIndex, offsetBy: 1)] {
    //            return s
    //        }else {
    //            return String(s[s.index(s.startIndex, offsetBy: 0)])
    //        }
    //    }
        let length = s.count
        var dp:[[Bool]] = .init(repeating: .init(repeating: false, count: length), count: length)
        var maxLen = 0
        var begin = 0
        for i in 0..<length {
            dp[i][i] = true
        }
        for L in 2...length {
            for i in 0..<length {
                let j = L + i - 1
                if j >= length {
                    break
                }
                
                if s[s.index(s.startIndex, offsetBy: i)] != s[s.index(s.startIndex, offsetBy: j)] {
                    dp[i][j] = false
                }else {
                    if j-i < 3 {
                        dp[i][j] = true
                    }else {
                        // 由于遍历的内容宽度是由小到大的，所以右边内容少于左边的，肯定值是提前存在的。
                        dp[i][j] = dp[i+1][j-1]
                    }
                }
                
                if dp[i][j] && j-i+1 > maxLen {
                    maxLen = j-i+1
                    begin = i
                }
            }
        }
        if maxLen > 0 {
            maxLen -= 1
        }
        let beginIndex = s.index(s.startIndex, offsetBy: begin)
        let endIndex = s.index(beginIndex, offsetBy: maxLen)
        return String(s[beginIndex...endIndex])
        
    }

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
    
    
    
    //MARK: 22. 括号生成
    
    /*
     数字 n 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 有效的 括号组合
     
     '''
     动态规划：
     dp[i]表示i组括号的所有有效组合
     dp[i] = "(dp[p]的所有有效组合)+【dp[q]的组合】"，其中 1 + p + q = i , p从0遍历到i-1, q则相应从i-1到0

     从两个括号的内容开始：
     () + ""  在 ( str[i]  ) + str[j]的前提下进行两轮遍历，即
     
     将括号分配的问题转化为，两组数量的括号，拆成3组，dp[p] + dp[q] + 1，进行排列组合
     如果两个的话：即dp[p] = 1,dp[q] = 0, + 1
     
     
     for (int i = 2; i <= n; i++) {
         for (int j = 0; j < i; j++) {
             List<String> str1 = result.get(j);
             List<String> str2 = result.get(i - 1 - j);
        }
     }
     这两层遍历，能实现str1,str2，是交替遍历前到后，和后到前,所以然后依次将这两个内容插入到需要的两个位置。
     */
    func generateParenthesis(_ n: Int) -> [String] {
        return []
    }
    
    
    
    //MARK: 53. 最大子数组和
    /*
     给你一个整数数组 nums ，请你找出一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。

     子数组 是数组中的一个连续部分。

     p[i],0<->i数字的最大数字和，拆解为0<->i-1 + i;
     如果p[i-1] < 0，p[i] = i
     否则p[i] = p[i-1] + i
     */

    
    
    //MARK: 70. 爬楼梯
    /*
     总是可以把i的问题，拆解
     p[i] = (p[i-1] + 1) + (P[i-2] + 2)
     */
    
    
    
    
    //MARK: 121. 买卖股票的最佳时机
    /*
     
     dp[i][0] 下标为 i 这天结束的时候，不持股，手上拥有的现金数
     dp[i][1] 下标为 i 这天结束的时候，持股，手上拥有的现金数
     
     初始化：不持股显然为 0，持股就需要减去第 1 天（下标为 0）的股价
     dp[0][0] = 0;
     dp[0][1] = -prices[0];
     
     从第 2 天开始遍历
     for (int i = 1; i < len; i++) {
     dp[i][0] = Math.max(dp[i - 1][0], dp[i - 1][1] + prices[i]);
     dp[i][1] = Math.max(dp[i - 1][1], -prices[i]);
     }
     
     */
    func maxProfit(_ prices: [Int]) -> Int {
        guard !prices.isEmpty else {
            return 0
        }
        var maxI: Int = 0
        var dp:[[Int]] = []
        dp.append([0,-prices[0]])
        for i in 1..<prices.count {
            dp.append(
                
                [max(dp[i-1][0], dp[i-1][1] + prices[i]),
                 max(dp[i-1][1], -prices[i])]
            )
            
            maxI = max(maxI,max(dp[i-1][0], dp[i-1][1] + prices[i]));
            
        }
        return maxI
    }
    
    
    
    
    
    
    //MARK: 198. 打家劫舍
    /*
     你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金，影响你偷窃的唯一制约因素就是相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警。

     输入：[1,2,3,1]
     输出：4
     解释：偷窃 1 号房屋 (金额 = 1) ，然后偷窃 3 号房屋 (金额 = 3)。
          偷窃到的最高金额 = 1 + 3 = 4 。
    
     定义一维数组dp[count+1]，dp[0]=0
     状态转移方程dp[i] = max(dp[i-1],num[i]+num[i-2])
     */
//    int rob(int* nums, int numsSize){
//        if (numsSize == 1) {
//            return nums[0];
//        }
//        if (numsSize == 2) {
//            return int_max(nums[0], nums[1]);
//        }
//        int dp[numsSize+1];
//        dp[0] = 0;
//        dp[1] = nums[0];
//        dp[2] = int_max(nums[0], nums[1]);
//        for (int i = 3; i <= numsSize; i++) {
//            /// 用的是连续间隔的和，因此是dp[i-2]+nums[i]
//            dp[i] = int_max(dp[i-1], dp[i-2]+nums[i-1]);
//        }
//        return dp[numsSize];
//    }
    
    
    
    //MARK: 213. 打家劫舍 II
    /*
     你是一个专业的小偷，计划偷窃沿街的房屋，每间房内都藏有一定的现金。这个地方所有的房屋都 围成一圈 ，这意味着第一个房屋和最后一个房屋是紧挨着的。同时，相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警 。

     输入：nums = [2,3,2]
     输出：3
     解释：你不能先偷窃 1 号房屋（金额 = 2），然后偷窃 3 号房屋（金额 = 2）, 因为他们是相邻的。
     
     和普通打家劫舍一样，只不过最后判断和是否由奇数项得到，是的话用dp[numSize-1]的结果
     
     答案：
     注意到当房屋数量不超过两间时，最多只能偷窃一间房屋，因此不需要考虑首尾相连的问题。如果房屋数量大于两间，就必须考虑首尾相连的问题，第一间房屋和最后一间房屋不能同时偷窃。

     如何才能保证第一间房屋和最后一间房屋不同时偷窃呢？如果偷窃了第一间房屋，则不能偷窃最后一间房屋，因此偷窃房屋的范围是第一间房屋到最后第二间房屋；如果偷窃了最后一间房屋，则不能偷窃第一间房屋，因此偷窃房屋的范围是第二间房屋到最后一间房屋。

     */
    
    
//    int robRange(int* nums, int start, int end) {
//        int first = nums[start], second = fmax(nums[start], nums[start + 1]);
//        for (int i = start + 2; i <= end; i++) {
//            int temp = second;
//            second = fmax(first + nums[i], second);
//            first = temp;
//        }
//        return second;
//    }
//
//    int rob(int* nums, int numsSize) {
//        if (numsSize == 1) {
//            return nums[0];
//        } else if (numsSize == 2) {
//            return fmax(nums[0], nums[1]);
//        }
//        return fmax(robRange(nums, 0, numsSize - 2), robRange(nums, 1, numsSize - 1));
//    }

    
    
    
    
    //MARK: 300. 最长递增子序列
    /*
     给你一个整数数组 nums ，找到其中最长严格递增子序列的长度。

     子序列 是由数组派生而来的序列，删除（或不删除）数组中的元素而不改变其余元素的顺序。例如，[3,6,2,7] 是数组 [0,3,1,6,2,2,7] 的子序列。

     
     发现答案的状态dp，只是一个一维数组。
     思考：什么时候是一维数组，什么时候是多维数组。
     有一个很重要的思考过程，就是以dp[i]最后一个开始思考，最后一个是唯一直接依赖dp[i-1]，
     这道题dp[i] = dp[i-1]+1(nums[i] > nums[i-1]),这时候，就能用一维数组
     
     
     思路：
     二维状态数组dp[i][j],表示从i到j的最长递增子序列.
     状态转移.只需要左下半内容即可，因为要i<j
     
     for i in 0..count
     int currentmin =  nums[0]
     for j in 1..i
        if nums[j] > currentmin {
        dp[i][j] = dp[i][j-1] + 1
        currentmin = nums[j]
     } else {
        dp[i][j] = dp[i][j-1]
     }
     
     */
    
//    int lengthOfLIS(int* nums, int numsSize){
//        if (nums == NULL || numsSize == 0) {
//            return 0;
//        }
//        int dp[numsSize];
//        dp[0] = 1;
//        int max = 1;
//        for (int i = 1; i < numsSize; i++) {
//            dp[i] = 1;
//            for (int j = 0; j < i; j++) {
//                if (nums[i] > nums[j]) {
//                    // 因为前面dp[j]以及计算了j之前的升序
//                    dp[i] = int_max(dp[i],dp[j] + 1);
//                }
//            }
//            max = int_max(max,dp[i]);
//        }
//        return max;
//    }

    
    
    
    //MARK: 322. 零钱兑换
    /*
     给你一个整数数组 coins ，表示不同面额的硬币；以及一个整数 amount ，表示总金额。

     计算并返回可以凑成总金额所需的 最少的硬币个数 。如果没有任何一种硬币组合能组成总金额，返回 -1 。

     你可以认为每种硬币的数量是无限的。

     
     假设：coins = [1, 2, 3], amount = 6
     
     分解为最优解的时候，即是求解F(6)=min(F(6−1),F(6−2),F(6−3))+1=3
     
     因此可以将amount分解为由0开始，每次需要最小步数是多少，例如1~6
     amount = 1可以遍历coins得出是1
     amount = 2可以遍历coins计算dp[2-1]+1 还是dp[2-2]+1小
    
     这套题就类似于爬楼梯，楼梯的步数是amount,每次可以选择的步数是coins数组。
     
     */
    
//    int coinChange(int* coins, int coinsSize, int amount){
//        int dp[amount+1];
//        dp[0] = 0;
//        for (int i = 1; i <= amount; i++) {
//            // 因为赋值了一个比要计算的值大一，因此下面计算最小值的时候，可能还是得到比amount要大的
//            dp[i] = amount + 1;
//        }
//
//        for (int j = 1; j <= amount; j++) {
//            for (int i = 0; i < coinsSize; i++) {
//                if (coins[i] <= j ) {
//                    //
//                    dp[j] = int_min(dp[j], dp[j - coins[i]] + 1);
//                }
//            }
//        }
//        return dp[amount] > amount ? -1 : dp[amount];
//    }
    
    
    
    
    //MARK: 338. 比特位计数
    /*
     给你一个整数 n ，对于 0 <= i <= n 中的每个 i ，计算其二进制表示中 1 的个数 ，返回一个长度为 n + 1 的数组 ans 作为答案。
     
     
     */
    
    
    
    
    //MARK: 数字三角形
    
    /*
     问题描述
     给定一个数字三角形，找到从顶部到底部的最小路径和。每一步可以移动到下面一行的相邻数字上。
     每一步只能移动到下一行中相邻的结点上。相邻的结点 在这里指的是 下标 与 上一层结点下标 相同或者等于 上一层结点下标 + 1 的两个结点。也就是说，如果正位于当前行的下标 i ，那么下一步可以移动到下一行的下标 i 或 i + 1 。

     [2],
     [3,4],
     [6,5,7],
     [4,1,8,3]

     从顶到底部的最小路径和为11 ( 2 + 3 + 5 + 1 = 11)。
     */
    
    /*
     思路：
     （1）由于有个要点，就是每一步只能移动到下一行，或者下一行的下一个，因此，当前所在T[i][j]的最小值，是由上一行，
     或者上一行的前一个最小值决定，因此可以将问题拆分成T[i][j] + min(T[i-1][j],T[i-1][j-1])
     */
    
    static func minimumTotal(_ triangle: [[Int]]) -> Int {
        if triangle.isEmpty {
            return 0
        }
        let row = triangle.count
        var status:[[Int]] = .init(repeating: .init(repeating: 0, count: row), count: row)
        
        status[0][0] = triangle[0][0]
        for i in 1..<row {
            for j in 0...i {
                
                var uppon = Int.max
                // 要判断上一行元素是否存在，然后取出到上一行元素的最小值
                // 或者判断上一行左移元素是否存在，然后取出到上一行左移元素的最小值
                if j != i {
                    uppon = status[i-1][j]
                }
                if j-1 >= 0 {
                    uppon = min(uppon, status[i-1][j-1])
                }

                status[i][j] = uppon + triangle[i][j]
            }
        }
        
        var result = Int.max
        for k in 0..<row {
            result = min(result, status[row-1][k])
        }
        return result
    }
    
    //MARK: 背包问题
    
     /*
     背包问题1 --- 01背包问题，要么放要么不放
     问题描述
     在n个物品中挑选若干物品装入背包，最多能装多满？假设背包的大小为m，每个物品的大小为A[i]
     */
    
    /*
     思路：  要找出固定背包大小能放最多的物品，其实就是分解成从若当前背包仍有空间，剩余空间能放多大物品。
     (1)首先需要对物品列表按小到大重量排序，为了方便后面寻找可用空间能放入哪个物品装的更多
     (2)状态转换有两种情况：
        a. 剩余空间能放的下当前的物品，所以status[c][q] = current + status[c-1][q]
        b. 剩余空间不足放下物品status[c][q] = status[c-1][q]
     */
    
    /*
     测试用例：
     （1）total = 0  (2)items = [] (3) total = 15,[1,2,3,4,5,6]
     (4) total = 15,[1,1,2,3,4,4,5]  (4) total = 15, [4,5,8,13]
     */
    static func backPack(packTotal: Int,itemsQuality:[Int]) -> Int {
        if packTotal <= 0 || itemsQuality.isEmpty {
            return 0
        }
        let count = itemsQuality.count
        // 先按质量排序
        let sortQuality = itemsQuality.sorted(by: { $0 < $1 })
        // 构建空白记录   质量为X轴， 个数为Y轴， 质量需要从1开始才有效，第一列都会为0，第一行也会为0
        var status: [[Int]] = .init(repeating: .init(repeating: 0, count: packTotal+1), count: count+1)
        
        for c in 1...count {
            for q in 1...packTotal {
                let current = sortQuality[c-1]
                
                if current > q {
                    // 当前物品大于可用，因此最大还是保留前一个个数最多时的质量
                    status[c][q] = status[c-1][q]
                } else {
                    /*
                     WARN: 注意这里需要考虑
                     只想到如果空间能放下后，即用前q-current的空间加上current的质量，
                     status[c][q] = status[c-1][q-current] + current
                     但是没考虑到：
                     ~~~~~~~~~~~~~~~~~~~~~~~~
                     例如总空间只有15， [1,7,7,10]，即当最大元素空间占用之后，能放下的内容不够最大空间物品之前之和的大。
                     所以除了判断这个物品能不能放下，还要判断这个物品放下之后有没有贡献
                     用了占体积的，剩下的填不上比较占体积的。
                     ~~~~~~~~~~~~~~~~~~~~~~~~
                     */
                    status[c][q] = max(status[c-1][q-current] + current, status[c-1][q])
                }
            }
        }
        var maxV = Int.min
        for i in 0...packTotal {
            maxV = max(maxV, status[count][i])
        }
        
        
        return maxV
        
    }
    
    
    /*
     背包问题2
     问题描述
     给出n个物品的体积A[i]和其价值V[i]，将他们装入一个大小为m的背包，最多能装入的总价值有多大？
     */

    
    
    //MARK: 416.选择子集和等于所有元素值和的一半
    
    /*
     给你一个 只包含正整数 的 非空 数组 nums 。请你判断是否可以将这个数组分割成两个子集，使得两个子集的元素和相等。
     */
    
    /*
     思路： 跟01背包类似，只需要将背包容量设置为所有元素值和的一半，然后跑一遍01背包算法即可
     */
    
    /*
     优化：  即将状态数组记录成，status[i][j]，使用i个数值的时候，是否存在一个值等于j，最终返回status[i][target]即可，target为数组和的一半。
     WARN:
     ~~~~~~~~~~~~~~~~~~~~~~~~
     且需要注意的是第二层的循环我们需要从大到小计算，因为如果从小到大，即
     ~~~~~~~~~~~~~~~~~~~~~~~~
     
     优化2：  背包问题都是使用二位数组保存状态，并且由于每次需要的结果，其实只是需要上一次结果中对应的上一行，以及上一行的左侧数据，
     因此完全可以二维数组缩减为一维数组。
     WARN:
     ~~~~~~~~~~~~~~~~~~~~~~~~
     注意是，因为我们使用的状态会取自上一行及上一行左侧的数据，如果我们复写这一行数据的时候，从左到右，则会把数据抹掉，造成不对。
     这里只要把数据怎么填写的过程过一遍，就知道为什么需要从后往前。因为我们用到的数据是从上一行及左侧拿的，如果我们从这行的左侧开始复写，
     等于一边复写上一行的数据，一边用上一行的数据
     ~~~~~~~~~~~~~~~~~~~~~~~~

     */
    
    /*
     被忽略的细节：
     
     解释设置 dp[0][0] = true 的合理性（重点）
     修改状态数组初始化的定义：dp[0][0] = true。考虑容量为 00 的时候，即 dp[i][0]。按照本意来说，应该设置为 false ，但是注意到状态转移方程（代码中）：


     dp[i][j] = dp[i - 1][j] || dp[i - 1][j - nums[i]];
     当 j - nums[i] == 0 成立的时候，根据上面分析，就说明单独的 nums[i] 这个数就恰好能够在被分割为单独的一组，其余的数分割成为另外一组。因此，我们把初始化的 dp[i][0] 设置成为 true 是没有问题的。
     */
    static func canPartition(_ nums: [Int]) -> Bool {
        let sum = nums.reduce(0) { r, v in
            return r+v
        }
        if sum%2 != 0 {
            return false
        }
        let half = sum/2
        return backPack(packTotal: half, itemsQuality: nums) == half
    }
    
    
    static func canPartition1(_ nums: [Int]) -> Bool {
        var maxX = Int.min
        let sum = nums.reduce(0) { r, v in
            maxX = max(v, maxX)
            return r+v
        }
        guard !nums.isEmpty,
              nums.count >= 2,
              sum%2 == 0 else {
            return false
        }
        let temp = nums.sorted(by: {$0<$1})
        let half = sum/2
        if maxX > half {
            return false
        }
        let count = temp.count
        var status: [[Bool]] = .init(repeating: .init(repeating: false, count: half+1), count: count)
        for i in 0..<count {
            status[i][0] = true
        }
        status[0][nums[0]] = true
        for c in 1..<count {
            let current = temp[c]
            for T in 1...half {
                if T >= current {
                    status[c][T] = status[c-1][T] || status[c-1][T-current]
                }else {
                    status[c][T] = status[c-1][T]
                }
                // 增加提前找到half这个值的判断，叫做剪枝操作
                if status[c][half] {
                    return true
                }
                
            }
        }
        return status[count-1][half]
    }
    
    
    static func canPartition2(_ nums: [Int]) -> Bool {
        let count = nums.count
        let sum = nums.reduce(0) { r, v in
            return r + v
        }
        guard sum&1 == 0 else {
            return false
        }
        let half = sum/2
        var status:[Bool] = .init(repeating: false, count: half+1)
        if nums[0] <= half {
            status[0] = true
        }
        for c in 1..<count {
            //WARN: 这里取值等于是上一行找T或者是上一行找剔除T的值
            if nums[c] > half {
                continue
            }
            for T in (nums[c]...half).reversed() {
                if status[half] {
                    return true
                }
//                status[T] = status[half-T] || status[nums[c]]
                //WARN: 这里取值等于是上一行找T或者是上一行找剔除T的值
                status[T] = status[T] || status[T-nums[c]]
            }
        }
        return status[half]
    }
    
    
    //MARK: 1049. 最后一块石头的重量 II
    /*
     有一堆石头，用整数数组 stones 表示。其中 stones[i] 表示第 i 块石头的重量。

     每一回合，从中选出任意两块石头，然后将它们一起粉碎。假设石头的重量分别为 x 和 y，且 x <= y。那么粉碎的可能结果如下：

     如果 x == y，那么两块石头都会被完全粉碎；
     如果 x != y，那么重量为 x 的石头将会完全粉碎，而重量为 y 的石头新重量为 y-x。
     最后，最多只会剩下一块 石头。返回此石头 最小的可能重量 。如果没有石头剩下，就返回 0。

     示例：
     输入：stones = [2,7,4,1,8,1]
     输出：1
     解释：
     组合 2 和 4，得到 2，所以数组转化为 [2,7,1,8,1]，
     组合 7 和 8，得到 1，所以数组转化为 [2,1,1,1]，
     组合 2 和 1，得到 1，所以数组转化为 [1,1,1]，
     组合 1 和 1，得到 0，所以数组转化为 [1]，这就是最优值。

     */
    
    /*
     规则分析：  先用三个石头距离，由于需要找到x,y,z相互做差后值最小，因此可以列式(z-(y-x))尽可能小，所以得到是(z+x-y)尽可能小。
     因此全局来看，就是划分成两堆，看看是否存在一堆的和，能尽量靠近和的一半。用总和减去尽可能大的值。 所以这个规则就是将一堆石头，
     划成左右两堆，使得左边每个减去右边每个之后的和，为最小值，因此可知，左边和最靠近sum的一半，这个值会尽可能小。
     
     */
    static func lastStoneWeightII(_ stones: [Int]) -> Int {
        if stones.isEmpty {
            return 0
        }
        if stones.count == 1 {
            return stones[0]
        }
        let temp = stones.sorted()
        let sum = temp.reduce(0, { $0 + $1})
        let half = sum/2
        var status:[Int] = .init(repeating: 0, count: half+1)
        for c in 0..<temp.count {
            if temp[c] > half {
                continue
            }

            for T in (1...half).reversed() {
                if status[T] >= half {
                    continue
                }
                let current = temp[c]
                
                if current > half {
                    continue
                }
                // 这里的条件 每次都需要画图让自己加深。
                if current + status[T] > T {
                    if T-current >= 0 {
                        status[T] = max(status[T-current]+current, status[T])
                    }
                    continue
                }
                status[T] = max(status[T-current]+current, status[T])
            }
        }
        
        return abs(sum - 2*status[half])
    }
    
    
    //MARK: 474. 一和零
    /*
     给你一个二进制字符串数组 strs 和两个整数 m 和 n 。

     请你找出并返回 strs 的最大子集的大小，该子集中 最多 有 m 个 0 和 n 个 1 。

     如果 x 的所有元素也是 y 的元素，集合 x 是集合 y 的 子集 。

     输入：strs = ["10", "0001", "111001", "1", "0"], m = 5, n = 3
     输出：4
     解释：最多有 5 个 0 和 3 个 1 的最大子集是 {"10","0001","1","0"} ，因此答案是 4 。
     其他满足题意但较小的子集包括 {"0001","1"} 和 {"10","1","0"} 。{"111001"} 不满足题意，因为它含 4 个 1 ，大于 n 的值 3 。
     */
    static func findMaxForm(_ strs: [String], _ m: Int, _ n: Int) -> Int {

        return 0
    }
    
    
    
    //MARK: 1143. 最长公共子序列
    /*
     
     */
    
//    int longestCommonSubsequence(char * text1, char * text2){
//        if (text1 == NULL || text2 == NULL) {
//            return 0;
//        }
//        int rows = (int)strlen(text1) + 1;
//        int cols = (int)strlen(text2) + 1;
//
//        int **nums = (int **)malloc(sizeof(int *) *rows);
//        for (int r = 0 ;r < rows; r++) {
//            nums[r] = (int *)malloc(sizeof(int) * cols);
//        }
//        for (int r = 0; r < rows; r++) {
//            nums[r][0] = 0;
//        }
//        for (int c = 0; c < cols; c++) {
//            nums[0][c] = 0;
//        }
//
//        for (int i = 1; i < rows; i++) {
//            char c1 = text1[i-1];
//            for (int j = 1; j < cols; j++) {
//                char c2 = text2[j-1];
//                if ( c1 == c2) {
//                    nums[i][j] = 1 + nums[i-1][j-1];
//                }else {
//                    nums[i][j] =  max_Int(nums[i][j-1], nums[i-1][j]);
//                }
//            }
//        }
//        return nums[rows-1][cols-1];
//    }
}
