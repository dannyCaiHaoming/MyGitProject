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
        
        let r = test.restoreIpAddresses("101023")
        print("r = \(r)")
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
        var stack: [Int] = []
        var mark:[Bool] = .init(repeating: false, count: width)
        for w in 0..<width {
            if mark[w] == true {
                continue
            }
            count += 1
            
            stack.append(w)
            
            while !stack.isEmpty {
                var size = stack.count
                while size > 0 {
                    size -= 1
                    let cur = stack.removeLast()
                    mark[cur] = true
                    for h in w..<height {
                        if mark[h] == false,
                           isConnected[h][cur] == 1 {
                            stack.append(h)
                        }
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
}
