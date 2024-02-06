//
//  搜索.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2024/1/17.
//  Copyright © 2024 蔡浩铭. All rights reserved.
//

import Foundation


class 搜索: Do {
    
    static func doSomething() {
        

        
            
        let test =  搜索()
//        let r = test.shortestPathBinaryMatrix([
////            [0,0,0],
////            [1,1,0],
////            [1,1,0]
//        ])
//        let r = test.numSquares(12)
//        let r = test.ladderLength("hot", "dog", ["hot","dog","cog","pot","dot"])
        
//        let r = test.maxAreaOfIsland([[0,0,1,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,1,1,1,0,0,0],[0,1,1,0,1,0,0,0,0,0,0,0,0],[0,1,0,0,1,1,0,0,1,0,1,0,0],[0,1,0,0,1,1,0,0,1,1,1,0,0],[0,0,0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1,1,1,0,0,0],[0,0,0,0,0,0,0,1,1,0,0,0,0]])
        
//        let r = test.numIslands(  [  ["1","1","0","0","0"],
//                                     ["1","1","0","0","0"],
//                                     ["0","0","1","0","0"],
//                                     ["0","0","0","1","1"]])
        
//        let r = test.findCircleNum([[1,0,0],[0,1,0],[0,0,1]])

//        let r = test.letterCombinations("23")
        
//        let r = test.restoreIpAddresses("101023")
//        let r = test.findCircleNum([[1,0,0],[0,1,0],[0,0,1]])
//        let r = test.findCircleNum([[1,1,0],[1,1,0],[0,0,1]])
        
//        let r = test.exist([["a"]], "a")
//        let r = test.permute([1,2,3])
        
//        let r = test.permuteUnique([1,1,2])
//        let r = test.permuteUnique2([1,1,2])
        
//        let r = test.combine(4, 2)
        
//        let r = test.combinationSum([2,3,5], 8)
        
//        let r = test.combinationSum2([2,5,2,1,2], 5)
//        let r = test.combinationSum2([10,1,2,7,6,1,5], 8)
        
//        print("r = \(r)")
    }
    
    //MARK: 1091. 二进制矩阵中的最短路径
    /*
     0是能移动，1是不能移动。
     
     [
     [0,0,0],
     [1,1,0],
     [1,1,0]
     ]
     
     单层循环，已经访问过的无法进行二次访问。
     
     问题出在为什么需要两层循环。  从原理上的意思，应该是将每层扫描的内容，在第二个循环用尽。
     
     需要理解，元素加入的队列后，只是表示，需要后面可能访问的内容，
     即 0 扫描8个方向后，加入了A ；当前队列【A】
     那么下次就是拿出A，扫描A的8个方向，可能加入B，C；当前队列【B，C】
     拿出B，扫描8个方向，可能加入C；当前队列【C，C】
     拿出C，扫描8个方向，可能加入B，D由于B已经扫描，因此加入D，当前队列[C,D]
     C扫描过，最后扫描D。得出结果。
     */
    func shortestPathBinaryMatrix(_ grid: [[Int]]) -> Int {
        if grid.isEmpty || grid[0].isEmpty {
            return -1
        }
        var tmpCount = 0
        var tmpGrid = grid
        let width = tmpGrid[0].count
        let height = tmpGrid.count
        let direction = [
//            [1,1],[1,0],[1,-1],
//            [0,1],[0,-1],
//            [-1,1],[-1,0],[-1,-1]
            [-1,-1],[0,-1],[1,-1],
            [-1,0],[0,0],[1,0],
            [-1,1],[0,1],[1,1]
        ]
        var queue:[[Int]] = []
        queue.append([0,0])
        while !queue.isEmpty {
            tmpCount += 1
            var size = queue.count
            while size > 0 {
                size -= 1
                let cur = queue.removeFirst()
                let x = cur[0]
                let y = cur[1]
                // 访问过
                if tmpGrid[x][y] == 1 {
                    continue
                }
                if x == width-1,
                   y == height-1 {
                    return tmpCount
                }

                tmpGrid[x][y] = 1
                print("x = \(x) ,y = \(y) did go")
                for dir in direction {
                    let dx = x+dir[0]
                    let dy = y+dir[1]
                    if dx < 0 || dy < 0 || dx >= width || dy >= height{
                        continue
                    }
                    if tmpGrid[dx][dy] == 0 {
                        queue.append([dx,dy])
                        print("x = \(dx) ,y = \(dx) next to go")
                    }
                    
                }
            }
        }
        return -1
    }
    /*
     力扣官方解法，只需要一层循环。加8个方向的查找。
     只需要在每一步记录下当前走下几步，然后在是否走下这一步的时候，判断当前步数+1是否大于那步记录下的需要步数，决定是否舍弃。
     */
    
    
    //MARK: 279 完全平方数
    
    /* 

     
     */
    func numSquares(_ n: Int) -> Int {
        if n == 1 {
            return 1
        }
        let nums = squareNums(n)
        var queue: [Int] = [n]
        var mark:[Int:Bool] = [:]
        var r = 0

        while !queue.isEmpty {
            r += 1
            var size = queue.count
            while size > 0 {
                size -= 1
                let cur = queue.removeFirst()
                for i in nums {
                    if i > cur {
                        continue
                    }
                    let next = cur - i
                    if mark[next] == true {
                        continue
                    }
                    if next == 0 {
                        return r
                    }
                    mark[next] = true
                    queue.append(next)
                }
            }
        }
        return -1
    }
    
    func squareNums(_ n: Int) -> [Int] {
        var r:[Int] = []
        var square = 1
        var diff = 3
        while square <= n {
            r.append(square)
            square += diff
            diff += 2
        }
        return r
    }
    
    
    
    //MARK: 127 单词接龙
    /*
     每个需要寻找的方向，就是wordlist，但是这里的判别条件是比较每个字符串，只有一个char不一样。
     
     优化建图：
     1. 对每个遍历的word，每个char，替换成*，即word，能达到*ord，w*rd，wo*d，wor*，建立映射关系。
     2. 因此，每个word，需要对比查询的路径，是这个映射字典，而不需要是整个wordList的每一个word。
     3. 剩下的 就是对每一个word遍历，每次就是把这个word的 映射字典放入queue。
     */
    var wordId:[String: Int] = [:]
    var edge:[[Int]] = []
    var nodeNum = 0
    func ladderLength(_ beginWord: String, _ endWord: String, _ wordList: [String]) -> Int {
        for w in wordList {
            addEdge(word: w)
        }
        addEdge(word: beginWord)
        if !wordId.keys.contains(endWord) {
            return 0
        }
        // 默认状态，标识未访问过。
        var dis:[Int] = .init(repeating: Int.max, count: nodeNum)
        let beginId = wordId[beginWord]
        let endId = wordId[endWord]
        dis[beginId!] = 0
        
        var queue: [Int] = []
        queue.append(beginId!)
        
        while !queue.isEmpty {
            let x = queue.removeFirst()
            if x == endId! {
                // 因为多走了一步，例如从a->b 会需要先走去a->*->b
                return dis[endId!] / 2 + 1
            }
            for it in edge[x] {
                if dis[it] == Int.max {
                    dis[it] = dis[x] + 1
                    queue.append(it)
                }
            }
        }
        
        return 0
    }
    
    
    func addEdge(word: String) {
        addWord(word: word)
        let id1 = wordId[word]
        let count = word.count
        for i in 0..<count {
            var tmpWord = word
            let tmp = tmpWord.index(word.startIndex, offsetBy: i)
            tmpWord.replaceSubrange(.init(NSRange(location: i, length: 1), in: tmpWord)!, with: "*")
            addWord(word: tmpWord)
            let id2 = wordId[tmpWord]
            edge[id1!].append(id2!)
            edge[id2!].append(id1!)
        }
    }
    
    func addWord(word: String) {
        if !wordId.keys.contains(word) {
            wordId[word] = nodeNum
            nodeNum += 1
            edge.append([])
        }
    }
    
    
    // MARK: 695 岛屿的最大面积
    func maxAreaOfIsland(_ grid: [[Int]]) -> Int {
        let height = grid.count
        let width = grid[0].count
        
        var mark: [[Int]] = .init(repeating: .init(repeating: 0, count: width), count: height)
        var stack: [(Int,Int)] = []
                
        let dir:[(Int,Int)] = [
            (0,1),(0,-1),(-1,0),(1,0)
        ]
        
        var max = 0
        
        for i in 0..<height {
            for j in 0..<width {
                let z = grid[i][j]
                if z == 0 || mark[i][j] != 0 {
                    continue
                }
                stack.append((i,j))
                while !stack.isEmpty {
                    var size = stack.count
                    while size > 0 {
                        size -= 1
                        let idx = stack.removeLast()
                        let cur = grid[idx.0][idx.1]
                        if cur == 0 {
                            continue
                        }
                        if mark[idx.0][idx.1] == 1 {
                            continue
                        }
                        mark[i][j] = mark[i][j] + 1
                        mark[idx.0][idx.1] = 1
                        if mark[i][j]  > max {
                            max = mark[i][j]
                        }
                        for d in dir {
                            let new = (idx.0 + d.0,idx.1 + d.1)
                            if new.0 < 0 || new.0 >= height || new.1 < 0 || new.1 >= width {
                                continue
                            }
                            if grid[new.0][new.1] == 0 {
                                continue
                            }
                            if mark[new.0][new.1] != 0 {
                                continue
                            }
                            stack.append(new)
                        }
                    }
                }
            }
        }
        return max
    }
    
    
    // MARK: 200 岛屿数量
    /*
     每一个数字遍历，然后将这个数字能走的路径，push进栈。
     对于能走的路径，mark上开始路径的的表示。这样子类似给每一个块岛屿上的点都打上一样颜色。
     最终记录有几个岛屿。
     1. 找到需要遍历的点，就是二维数组的所有元素
     2. 每次需要的方向，上下左右。
     */
    func numIslands(_ grid: [[Character]]) -> Int {
        let height = grid.count
        let width = grid[0].count
        let dir:[(Int,Int)] = [
            (0,1),(0,-1),(-1,0),(1,0)
        ]
        // 将每次深度遍历到的，都赋予最开始的那个坑的值
        var mark: [[String]] = .init(repeating: .init(repeating: "", count: width), count: height)
        var islands:[String] = []
        
        var stack: [(Int,Int)] = []
        
        for h in 0..<height {
            for w in 0..<width {
                let word = grid[h][w]
                if word == "0" {
                    continue
                }
                if mark[h][w] != "" {
                    continue
                }
                stack.append((h,w))
                mark[h][w] = UUID().uuidString
                islands.append(mark[h][w])
                while !stack.isEmpty {
                    var size = stack.count
                    while size > 0 {
                        size -= 1
                        let curIdx = stack.removeLast()
                        for d in dir {
                            let x = curIdx.1 + d.1
                            let y = curIdx.0 + d.0
                            if x < 0 || y < 0 || x >= width || y >= height {
                                continue
                            }
                            let nextWord = String(grid[y][x])
                            if nextWord == "0" {
                                continue
                            }
                            if mark[y][x] != "" {
                                continue
                            }
                            mark[y][x] = mark[h][w]
                            stack.append((y,x))
                        }
                    }
                }

            }
        }
        return islands.count
    }
    
    
    
    //MARK: 547 省份数量
    /*
     wtk.
     要把isCOnnected展开，才懂是啥意思。
     [
     [1,1,0],
     [1,1,0],
     [0,0,1]
     ]
     
     [
     [1,0,0],
     [0,1,1],
     [0,0,1]
     ]
     
     [1,0,0,1],
     [0,1,1,0],
     [0,1,1,1],
     [1,0,1,1]
     
     
     1. 难点，读懂题目，这个数组，有x，y，但是从哪个方向遍历都可以。即不像之前那么直白，需要二维数组所有的去遍历。
     2. 实际这道题可以类比小岛数量。但是这里所有的路径，假设取定了X方向，那么每个元素可以走的方向，就是沿着Y方向。
     3. 标记，当X-Y联通，那么都可以用一个唯一值进行标识~
     
     */
    func findCircleNum(_ isConnected: [[Int]]) -> Int {
        
        var count = 0
        let height = isConnected.count
        let width = isConnected[0].count
        
        var stack: [[Int]] = []
        var mark: [[Int]] = .init(repeating: .init(repeating: -1, count: width), count: height)
        
        for w in 0..<width {
            for h in 0..<height {
                if mark[h][w] != -1 {
                    continue
                }
                count += 1
                mark[h][w] = 1
                stack.append([h,w])
                while !stack.isEmpty {
                    var size = stack.count
                    while size > 0 {
                        size -= 1
                        let curIdx = stack.removeLast()
                        let x = curIdx[1]
                        let y = curIdx[0]
                        let cur = isConnected[y][x]
                        if cur == 0 {
                            continue
                        }
                        if mark[y][x] == 1 {
                            continue
                        }
                        
                        
                        //                    for h in cur+1..<height {
                        //                        if mark[h] == -1,
                        //                           isConnected[h][cur] == 1 {
                        ////                            mark[h] = 1
                        //                            stack.append(h)
                        //                        }
                        //                    }
                        
                    }
                }
            }
        }
        
        return count
    }
    
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
    
    
    
    // MARK: 93. 复原 IP 地址
    var ipResult: [String] = []
    var ipMark: [Bool] = []
    func restoreIpAddresses(_ s: String) -> [String] {
        
        ipMark = .init(repeating: false, count: s.count)
        
        var words: [String] = []
        for word in s {
            words.append(String(word))
        }
        
        restoreIpDiGui(last: 0, count: 3, words: words, thisRound: "",result:[])
        
        return ipResult
    }
    
    /*
     
    以last为起始， 每次遍历下三个。，合适继续遍历， 当count 4次，并且最终落点为最后一个字母后，且最后一个数字合适，才能当加入
     
     */
    func restoreIpDiGui(last: Int ,count: Int,words:[String],thisRound: String,result:[String]) {
        
        if count < 0 {
            if last == words.count {
                let r = result.joined(separator: ".")
                ipResult.append(r)
            }
            
            return
        }

        for i in last..<words.count {
            for j in 0...2 {
                if ipMark[last] == true {
                    continue
                }
                if i+j < words.count {
                    let str = words[i...i+j].joined()
                    ipMark[i+j] = true
                    if str.count >= 2,
                       str.hasPrefix("0") {
                        let p = words[i...i+j-1].joined()
                        restoreIpDiGui(last: i+j, count: count-1, words: words, thisRound: p, result: result + [p])
                    }
                    else if Int(str)! > 255 {
                        let p = words[i...i+j-1].joined()
                        restoreIpDiGui(last: i+j, count: count-1, words: words, thisRound: p, result: result + [p])
                    } else {
                        restoreIpDiGui(last: i+j, count: count-1, words: words, thisRound: str, result: result + [str])
                    }
                    
                    ipMark[i+j] = false
//                    if Int(str)! > 255 ||
//                        (str.count > 1 && str.hasPrefix("0") ){
//                        break
//                    }
      
                }
                
            }
            
        }
        

        
    }
    
    
    
    // MARK: 79 单词搜索
    var existMark: [[Bool]] = []
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        let height = board.count
        let width = board[0].count
        
        existMark = .init(repeating: .init(repeating: false, count: width), count: height)
        
        for h in 0..<height {
            for w in 0..<width {
                if exitBackTrace(curH: h, curW: w, board: board, words: word) {
                    return true
                }
            }
        }
        return false
    }
    
    let dir:[(Int,Int)] = [
        (-1,0),
        (1,0),
        (0,-1),
        (0,1)
    ]
    func exitBackTrace(curH: Int,curW: Int,board: [[Character]], words: String) -> Bool {
        let height = board.count
        let width = board[0].count
        if words.isEmpty {
            return true
        }
        if curH < 0 || curW < 0 || curH >= height || curW >= width || existMark[curH][curW] == true {
            return false
        }

        var tmpWords = words
        let fir = tmpWords.removeFirst()
        if board[curH][curW] == fir {
            existMark[curH][curW] = true
            for d in dir {
                if exitBackTrace(curH: curH+d.0, curW: curW+d.1, board: board, words: tmpWords) {
                    return true
                }
            }
            existMark[curH][curW] = false
        }
        
        
        return false
    }
    
    // MARK: 257  二叉树的所有路径
    func binaryTreePaths(_ root: TreeNode?) -> [String] {
        let all = binaryTreeBackTrace(cur: root)
        
        return all

    }
    
    func binaryTreeBackTrace(cur: TreeNode?) -> [String] {
        guard let cur = cur else {
            return []
        }
        var tmp: [String] = []
        let curStr = cur.val
        if let left = cur.left {
            let leftStr = binaryTreeBackTrace(cur: left)
            if !leftStr.isEmpty {
                let new =  leftStr.map({ "\(curStr)->" + $0 })
                tmp.append(contentsOf: new)
            }
        }
        if let right  = cur.right {
            let rightStr = binaryTreeBackTrace(cur: right)
            if !rightStr.isEmpty {
                let new =  rightStr.map({ "\(curStr)->" + $0 })
                tmp.append(contentsOf: new)
            }
        }
        if tmp.isEmpty {
            tmp.append("\(curStr)")
        }
        return tmp
    }
    
    // MARK: 46  全排列
    var permuteMark: [Bool] = []
    func permute(_ nums: [Int]) -> [[Int]] {
        let count = nums.count
        permuteMark = .init(repeating: false, count: count)
        var res:[[Int]] = []
        var list:[Int] = []
        
        permuteBackTrack(nums, cur: 0, count: count,res: &res,list: &list)

        return res
        
    }
    
    /*
     写的时候，卡在一个二维数组。因为以1,2,3；为例子，1，之后可能会是【2,3】，【3,2】，因此需要将每次回溯加入到上一次的数组。
     但是我用的一个二维数组来记录结果。导致最后在一些已经访问过的元素，又或者确实访问完了，步数为总长的时候，无法筛选出怎么加。
     
     这里题解都使用一个临时数据，记录一轮，然后当一轮长度足够了，就加入到结果！
     */
    func permuteBackTrack(_ nums: [Int],cur: Int,count: Int, res: inout [[Int]],list: inout [Int]) {
        
        if list.count == count {
            res.append(list)
        }
        for i in 0..<count {
            if permuteMark[i] {
                continue
            }
            permuteMark[i] = true
            
            list.append(nums[i])
            permuteBackTrack(nums, cur: cur+1, count: count, res: &res,list: &list)
            list.removeAll(where: { $0 == nums[i] })
            permuteMark[i] = false
        }
    }
    
    
    //MARK: 47. 全排列 II
    var permuteUniqueMark: [Bool] = []
    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        let count = nums.count
        permuteUniqueMark = .init(repeating: false, count: count)
        
        var res:[[Int]] = []
        var list:[Int] = []
        
        var sort = nums.sorted()
        
        permuteUniqueBackTrack(sort, cur: 0, count: count,res: &res,list: &list)
        
        return res
    }
    
    /*
     和普通全排列区别在于，之前【1,1】是两组。这个是当1组，所以后面的值等于前面的时候，需要剪掉
     */
    func permuteUniqueBackTrack(_ nums: [Int],cur: Int,count: Int, res: inout [[Int]],list: inout [Int]) {
        
  
        if list.count == count {
            res.append(list)
        }

        for i in 0..<count {
            /*
             要解决重复问题，我们只要设定一个规则，保证在填第 idx\textit{idx}idx 个数的时候重复数字只会被填入一次即可。而在本题解中，我们选择对原数组排序，保证相同的数字都相邻，然后每次填入的数一定是这个数所在重复数集合中「从左往右第一个未被填过的数字」，即如下的判断条件：

             自己就是漏了先排序，这样就是在后一个等于前一个的时候，忽略掉。
             */
            if permuteUniqueMark[i] || (i>0 && nums[i] == nums[i-1] && !permuteUniqueMark[i-1]){
                continue
            }
            permuteUniqueMark[i] = true
            
            list.append(nums[i])
            permuteUniqueBackTrack(nums, cur: cur+1, count: count, res: &res,list: &list)
            list.removeLast()
            permuteUniqueMark[i] = false
        }
    }
    
    
    // 还有个有趣的交换方法  //所有数字其实就是一个序列结果。因此只需要摆来摆去，就可以。
    var permuteList:[Int] = []
    var permuteRes:[[Int]] = []
    func permuteUnique2(_ nums: [Int]) -> [[Int]] {
        permuteList = nums
        permuteUnique2Dfs(idx: 0)
        return permuteRes
    }
    
    func permuteUnique2Dfs(idx: Int) {
        
        if idx == permuteList.count - 1 {
            permuteRes.append(permuteList)
            return
        }
        
        func swap(i:Int,j:Int) {
            let tmp = permuteList[j]
            permuteList[j] = permuteList[i]
            permuteList[i] = tmp
        }
        
        var numsSet:Set<Int> = []
        for i in idx..<permuteList.count {
            if numsSet.contains(permuteList[i]) {
                continue
            }
            numsSet.insert(permuteList[i])
            swap(i: idx, j: i)
            permuteUnique2Dfs(idx: idx+1)
            swap(i: idx, j: i)
        }
        
        
    }
    
    
    //MAKR: 77. 组合
    /*
     上面的事，多少个数，就有多少个坑位，现在是，n个数不对应k个坑位，而且不算重复
     [1,n]
     那就递归每个数，
     */
    var combineList: [Int] = []
    var combineRes: [[Int]] = []
    var combineMark: [Bool] = []
    func combine(_ n: Int, _ k: Int) -> [[Int]] {
        combineMark = .init(repeating: false, count: n+1)
        combineBacktrace(cur: 1, end: n, k: k)
        return combineRes
    }
    
    func combineBacktrace(cur: Int,end:Int,k: Int) {
        if combineList.count == k {
            combineRes.append(combineList)
            return
        }
        for i in cur...end {
            if combineMark[i] {
                continue
            }
            combineList.append(i)
            combineMark[i] = true
            combineBacktrace(cur: i, end: end, k: k)
            combineMark[i] = false
            combineList.removeLast()
        }
    }
    
    
    // MARK: 39.组合求和
    /*
     
     自己写的，递归，每次都从0元素开始递归。不知道怎么去重
     */
    var combinationList: [Int] = []
    var combinationRes: [[Int]] = []
    func chmBacktrace(cur: Int,can: [Int],tar: Int) {
        if tar == 0 {
            combinationRes.append(combinationList)
            // 只能查询res的list是否有重复。。
            return
        } else if tar < 0 {
            return
        }
        if cur >= can.count {
            return
        }
        for i in 0..<can.count {
            // 保证当次遍历的，要在当次加入，并且扣除后进入下一轮。
            combinationList.append(can[i])
            if tar - can[cur] < 0 {
                combinationList.removeLast()
                return
            }
            chmBacktrace(cur: i,can: can,tar: tar - can[i])
            combinationList.removeLast()
        }
    }
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        let sort = candidates.sorted()
        chmBacktrace(cur: 0,can: sort, tar: target)
        return combinationRes
    }
    
    /*
     官方题解，
     （1）当前数，直接跳过继续递归，
     （2）使用当前数，继续递归，
     
     递归，等于套了一层循环。因而不用再套一层循环。
     */
    
    func combinationSum_guanfang(_ candidates: [Int], _ target: Int) -> [[Int]] {
        let sort = candidates.sorted()
        var combinationList: [Int] = []
        var combinationRes: [[Int]] = []
        chmBacktrace2(cur: 0,can: sort, tar: target,list: &combinationList,res: &combinationRes)
        return combinationRes
    }
    
    func chmBacktrace2(cur: Int,can: [Int],tar: Int,list: inout [Int],res: inout [[Int]]) {
        if tar == 0 {
            res.append(list)
            return
        }
        if cur >= can.count {
            return
        }
        // 跳过
        chmBacktrace2(cur: cur+1, can: can, tar: tar,list: &list,res: &res)
//        for i in 0..<can.count {
            
            if tar - can[cur] >= 0 {
                list.append(can[cur])
                chmBacktrace2(cur: cur,can: can,tar: tar - can[cur],list: &list,res: &res)
                list.removeLast()
            }
//        }
    }
    
    
    //MARK: 40 组合求和II
    
    /*
     上题是可用同一个字符，这题不可重复使用，那就更好做了把。
     也不是字符不能重复是组合不能重复。
     那就不用进入自身的递归，进入下一个的递归，并且如果下一个等于自身，那就跳过下一个的递归。
     
     candidates = [10,1,2,7,6,1,5], target = 8,
     1,1,2,5,6,7,10
     
     1,2,5,6,7,10
     
     candidates = [2,5,2,1,2] target = 5
     1,2,2,2,5
     
      
      问题1： 进下一个递归的时候  是target-cur ，但是加入cur的时机却放在下一轮？？
      
      因此，我们需要改进上述算法，在求出组合的过程中就进行去重的操作。我们可以考虑将相同的数放在一起进行处理，也就是说，如果数 x 出现了 y 次，那么在递归时一次性地处理它们，即分别调用选择 0...y 次 x 的递归函数。这样我们就不会得到重复的组合。具体地：

      
      牛的，这样子遍历的时候，遇到2，就计算2里面有几个次数，够了就递归下一个数字

      */
    var combinationSum2List:[Int] = []
    var combinationSum2Res:[[Int]] = []
    var combinationSum2Dict: [Int:Int] = [:]
    func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
        let sort = candidates.sorted()
        
        var keys:[Int] = []
        for i in sort {
            let v = combinationSum2Dict[i] ?? 0
            combinationSum2Dict[i] = v + 1
            if v == 0 {
                keys.append(i)
            }
        }
        for i in 0..<combinationSum2Dict.keys.count {
            combinationSum2Backtrace(cur: i, target: target,keys: keys)
        }
        
        return combinationSum2Res
    }
    /*
     1 2, 5,6,7 ,10
     
     2
     */

    func combinationSum2Backtrace(cur: Int, target: Int,keys: [Int]) {
        
        if target == 0 {
            combinationSum2Res.append(combinationSum2List)
            return
        }
        
        if cur == keys.count || target < keys[cur] {
            return
        }
        let num = keys[cur]
        
        
        var tmp = combinationSum2Dict[num] ?? -1
//
        if tmp < 0 {
            return
        }
        

        combinationSum2Backtrace(cur: cur+1, target: target, keys: keys)
        
        for i in 1...tmp {
            combinationSum2Dict[num] = tmp - i
            combinationSum2List.append(num)
            combinationSum2Backtrace(cur: cur+1, target: target-i*num, keys: keys)
            combinationSum2Dict[num] = tmp + i
        }
        for i in 1...tmp {
            combinationSum2List.removeLast()
        }
//        if tmp > 0 {
//            combinationSum2Backtrace(cur: cur, target: target-keys[cur], keys: keys)
//        } else {
//            for i in cur..<keys.count {
//                
//
//                combinationSum2Backtrace(cur: i, target: target-keys[cur], keys: keys)
//    //            if i+1 < keys.count {
//    //                combinationSum2Backtrace(cur: i+1, target: target-keys[cur], keys: keys)
//    //            }
//            }
//        }
//
//        combinationSum2List.removeLast()
        tmp += 1
        combinationSum2Dict[num] = tmp
        
//        candidates = [2,5,2,1,2] target = 5
//        1,2,2,2,5
/*
 1 , 2  ,5   8
 */
        
        
        
    }
    

    
    
}
