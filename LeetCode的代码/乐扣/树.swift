//
//  树.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2022/3/25.
//  Copyright © 2022 蔡浩铭. All rights reserved.
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


class 树: Do {
    /*
     最大二叉树：
     根节点是树的最大值
     */
    
    static func doSomething() {
        
        let a_1 = TreeNode.init(1)
        let a_2 = TreeNode.init(2)
        let a_3 = TreeNode.init(2)
        let a_4 = TreeNode.init(3)
        let a_5 = TreeNode.init(3)
        a_1.left = a_2
        a_1.right = a_3
        a_2.right = a_4
        a_3.right = a_5
        
            
        let test =  树()
//        test.isSymmetric(a_1)
        
        let r = test.deserialize("1,null,2")
        
        let r1 = test.serialize(r)
        print(r)
        print(r1)
        
        
    }
    
    //MARK: 94. 二叉树的中序遍历
    /*
     给定一个二叉树的根节点 root ，返回 它的 中序 遍历 。
     */
    func inorderTraversal(_ root: TreeNode?) -> [Int] {
        guard let root = root else {
            return []
        }
        var res:[Int] = []
        res.append(contentsOf: inorderTraversal(root.left))
        res.append(root.val)
        res.append(contentsOf: inorderTraversal(root.right))
        return res
    }
    
    //MARK: 98. 验证二叉搜索树
    /*
     给你一个二叉树的根节点 root ，判断其是否是一个有效的二叉搜索树。
     有效 二叉搜索树定义如下：
     节点的左子树只包含 小于 当前节点的数。
     节点的右子树只包含 大于 当前节点的数。
     所有左子树和右子树自身必须也是二叉搜索树。
     
     依据二叉搜索树特性，设置一个上下界限，
     左子树的时候，需要用到上界。
     右子树的时候，需要用到下界
     */
    func isValidBST(_ root: TreeNode?) -> Bool {
        return isValidBSTLoop(root, lower: Int.min, upper: Int.max)
    }
    
    func isValidBSTLoop(_ root: TreeNode?,
                        lower: Int,
                        upper: Int) -> Bool {
        guard let root = root else {
            return true
        }
        if root.val <= lower || root.val >= upper {
            return false
        }
    
        return isValidBSTLoop(root.left, lower: lower, upper: root.val) &&
        isValidBSTLoop(root.right, lower: root.val, upper: upper)
    }
    
    //MARK: 101. 对称二叉树
    /*
     给你一个二叉树的根节点 root ， 检查它是否轴对称。\
     
     也是要层序遍历，可以层序遍历出[[Int]]，然后逐层判断是否对称
     */
    func isSymmetric(_ root: TreeNode?) -> Bool {
        guard let root = root else {
            return true
        }
        if root.left == nil && root.right == nil {
            return true
        }
        if root.left == nil || root.right == nil {
            return false
        }
        guard let left = root.left,
              let right = root.right,
              left.val == right.val else {
            return false
        }
        var rowQueue:[TreeNode] = []
        rowQueue.append(contentsOf: [left,right])
        while !rowQueue.isEmpty {
            if rowQueue.count % 2 != 0 {
                return false
            }
            var left = rowQueue.count / 2 - 1
            var right = rowQueue.count / 2
            while left >= 0 && right < rowQueue.count {
                if rowQueue[left].val == rowQueue[right].val &&
                    rowQueue[left].left?.val == rowQueue[right].right?.val &&
                    rowQueue[left].right?.val == rowQueue[right].left?.val  {
                    left -= 1
                    right += 1
                    continue
                }else {
                    return false
                }
            }
            var tmp:[TreeNode] = []
            for tree in rowQueue {
                if let left = tree.left {
                    tmp.append(left)
                }
                if let right = tree.right {
                    tmp.append(right)
                }
            }
            rowQueue.removeAll()
            rowQueue.append(contentsOf: tmp)
        }
        return true
    }
    
    /*
     递归：
     因此，该问题可以转化为：两个树在什么情况下互为镜像？

     如果同时满足下面的条件，两个树互为镜像：

     它们的两个根结点具有相同的值
     每个树的右子树都与另一个树的左子树镜像对称
     */
    func checkIsSymmetric(_ left: TreeNode?,_ right: TreeNode?) -> Bool {
        if left == nil && right == nil {
            return true
        }
        guard let left = left,
              let right = right else {
            return false
        }
        return left.val == right.val &&
        checkIsSymmetric(left.right, right.left) &&
            checkIsSymmetric(left.left, right.right)
    }
    func isSymmetric1(_ root: TreeNode?) -> Bool {
        return checkIsSymmetric(root, root)
    }
    
    
    //MARK: 102. 二叉树的层序遍历
    /*
     给你二叉树的根节点 root ，返回其节点值的 层序遍历 。 （即逐层地，从左到右访问所有节点）。
     
     队列方式。每次去队头加入列表，然后将子树加入到队尾
     */
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let tmpRoot = root else {
            return []
        }
        var TreeQueue:[TreeNode] = []
        var valQueue:[[Int]] = []
        TreeQueue.append(tmpRoot)
        while !TreeQueue.isEmpty {
            var rowQueue:[Int] = []
            var nextRowTree:[TreeNode] = []
            while !TreeQueue.isEmpty {
                let lead = TreeQueue.remove(at: 0)
                rowQueue.append(lead.val)
                if let left = lead.left {
                    nextRowTree.append(left)
                }
                if let right = lead.right {
                    nextRowTree.append(right)
                }
            }
            TreeQueue.append(contentsOf: nextRowTree)
            valQueue.append(rowQueue)
        }
        return valQueue
    }
     
    
    //MARK: 104. 二叉树的最大深度
    /*
     给定一个二叉树，找出其最大深度。
     二叉树的深度为根节点到最远叶子节点的最长路径上的节点数。
     说明: 叶子节点是指没有子节点的节点。
     */
    func maxDepth(_ root: TreeNode?) -> Int {
//        guard let root = root else {
//            return 0
//        }
//        return max(maxDepth(root.left), maxDepth(root.right)) + 1
        guard let tmpRoot = root else {
            return 0
        }
        var TreeQueue:[TreeNode] = []
        var count = 0
        TreeQueue.append(tmpRoot)
        while !TreeQueue.isEmpty {
            var nextRowTree:[TreeNode] = []
            while !TreeQueue.isEmpty {
                let lead = TreeQueue.remove(at: 0)
                if let left = lead.left {
                    nextRowTree.append(left)
                }
                if let right = lead.right {
                    nextRowTree.append(right)
                }
            }
            TreeQueue.append(contentsOf: nextRowTree)
            count += 1
        }
        return count
    }
    
    func maxDepth1(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        let left = maxDepth(root.left)
        let right = maxDepth(root.right)
        if left > right {
            return left + 1
        } else {
            return right + 1
        }
        
    }
    
    
    // MARK: 105. 从前序与中序遍历序列构造二叉树
    
    /*
     从知识点知道，前序中第一位，是根节点，然后拿着根节点去中序，进行拆分。
     分成左子树和右子树。
     所以，每次从前序中，取出一位，然后到中序查找，然后将中序分成左子树，和右子树。
     那么构造一个root，那他的左子树，也能用同样的算法，计算，右子树，也是能用同样的算法计算。
     只是要规划好，根据前序得到根节点后，需要用中序，遍历出根节点位置，然后划分好左右子树，然后进行递归。
     */
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        guard !preorder.isEmpty,
              !inorder.isEmpty,
              let rootV = preorder.first else {
            return nil
        }
        let count = preorder.count
        let root = TreeNode.init(rootV)
        var mid = 0
        while inorder[mid] != rootV {
            mid += 1
        }
        let leftCount = mid
        let rightCount = count - leftCount - 1
        
        let left = buildTree(Array(preorder[1..<leftCount+1]), Array(inorder[0..<leftCount]))
        let right = buildTree(Array(preorder[leftCount+1..<count]), Array(inorder[leftCount+1..<count]))
        root.left = left
        root.right = right
        return root
    }
    
    
    //MAKR:  112. 路径总和
    /*
     给你二叉树的根节点 root 和一个表示目标和的整数 targetSum 。判断该树中是否存在 根节点到叶子节点 的路径，这条路径上所有节点值相加等于目标和 targetSum 。如果存在，返回 true ；否则，返回 false 。
     */
    func hasPathSum(_ root: TreeNode?, _ targetSum: Int) -> Bool {
        guard let root = root else {
            return false
        }
        if root.val == targetSum && root.left == nil && root.right == nil {
            return true
        }
        return hasPathSum(root.left, targetSum - root.val) ||
        hasPathSum(root.right, targetSum - root.val)

    }
    
    
    //MARK: 114. 二叉树展开为链表
    /*
     看成了中序遍历。
     是先序遍历的顺序。
     
    貌似迭代方法的时候，先入根节点，然后再左右，根再右左，就是不一样的遍历方式。
     
     ** 官方题解，类似双指针，也是链表常用，一个指向上一个节点，用栈存储下一个将要访问的节点。 **
     */
    
    func flatten(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        var array:[TreeNode] = preFlatten(root: root)
        
        for j in 0..<array.count {
            if j+1 < array.count {
                array[j].left = nil
                array[j].right = array[j+1]
            }
        }
    }
    
    func preFlatten(root: TreeNode?) -> [TreeNode] {
        guard let root = root else {
            return []
        }
        let left = preFlatten(root: root.left)
        let right = preFlatten(root: root.right)
        return [root] + left + right
    }
    
    func flatten2(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        var pre: TreeNode? = nil
        var stack: [TreeNode] = []
        stack.append(root)
        while !stack.isEmpty  {
            let cur = stack.removeLast()
            if let r = cur.right {
                stack.append(r)
            }
            if let l = cur.left {
                stack.append(l)
            }
            if pre != nil {
                pre?.left = nil
                pre?.right = cur
                pre = cur
            } else {
                pre?.left = nil
                pre = cur
            }
        }
    }

    
    // MARK: 124. 二叉树中的最大路径和
    /*
     想复杂了。
     */
    var maxPathSumResult = Int.min
    func maxPathSum(_ root: TreeNode?) -> Int {
        _ = maxPathSumTrace(root: root)
        return maxPathSumResult
    }
    
    func maxPathSumTrace(root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        var left = 0
        let l = maxPathSumTrace(root: root.left)
        if l > left {
            left = l
        }
        var right = 0
        let r = maxPathSumTrace(root: root.right)
        if r > right {
            right = r
        }
        // 根节点的总值，是左到右。但是最后到用左还是右的时候需要判断
        let cur = root.val + left + right
        if cur > maxPathSumResult {
            maxPathSumResult = cur
        }
        // 判断用左边还是右边。
        return root.val + left > root.val + right ? root.val + left : root.val + right
        
    }
    
    //MARK: 144. 二叉树的前序遍历
    /*
     给你二叉树的根节点 root ，返回它节点值的 前序 遍历。
     前序遍历，先遍历所有根节点，然后返回左右子树节点
     */
    func preorderTraversal(_ root: TreeNode?) -> [Int] {
        guard let root = root else {
            return []
        }
        var res:[Int] = []
        res.append(root.val)
        res.append(contentsOf: preorderTraversal(root.left))
        res.append(contentsOf: preorderTraversal(root.right))
        return res
    }
    
    //MARK: 145. 二叉树的后序遍历
    func postorderTraversal(_ root: TreeNode?) -> [Int] {
        guard let root = root else {
            return []
        }
        var res:[Int] = []
        res.append(contentsOf: postorderTraversal(root.left))
        res.append(contentsOf: postorderTraversal(root.right))
        res.append(root.val)
        return res
    }

    
    //MARK: 226. 翻转二叉树
    /*
     给你一棵二叉树的根节点 root ，翻转这棵二叉树，并返回其根节点。
     */
    func invertTree(_ root: TreeNode?) -> TreeNode? {
        guard let root = root else {
            return nil
        }
        let left = invertTree(root.left)
        let right = invertTree(root.right)
        root.left = right
        root.right = left
        return root

    }
    
    
    //MARK: 236. 二叉搜索树的最近公共祖先
    /*
     给定一个二叉搜索树, 找到该树中两个指定节点的最近公共祖先。

     百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

     例如，给定如下二叉搜索树:  root = [6,2,8,0,4,7,9,null,null,3,5]
     */
    var ancestor: TreeNode?
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        _ = lowestCommonAncestorTrace(root, p, q)
        return ancestor
    }
    
    func lowestCommonAncestorTrace(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> Bool {
        /*
         如果根节点等于p或q，并且左子树存在，或者右子树存在pq
         或者左子树右子树存在pq
         */
        if root == nil {
            return false
        }
        let rootSame = root?.val == p?.val || root?.val == q?.val
        let sameLeft = lowestCommonAncestorTrace(root?.left, p, q)
        let sameRight = lowestCommonAncestorTrace(root?.right, p, q)
        if (rootSame && (sameLeft || sameRight)) || (sameLeft && sameRight) {
            ancestor = root
        }
        return rootSame || sameLeft || sameRight
    }
    
    
    // MARK: 297 二叉树的序列化和反序列化
    func serialize(_ root: TreeNode?) -> String {
        var stack: [TreeNode?] = []
        guard let root = root else {
            return ""
        }
        stack.append(root)
        var result = ""
        while !stack.isEmpty  {
            let cur = stack.removeFirst()
            if cur != nil {
                if result.isEmpty {
                    result = "\(cur!.val)"
                } else {
                    result = result + "," + "\(cur!.val)"
                }
                var hasNext = true
                if stack.last??.left == nil && stack.last??.right == nil && cur?.right == nil {
                    hasNext = false
                }
                if let l = cur?.left {
                    stack.append(l)
                } else {
                    if hasNext {
                        stack.append(nil)
                    }
                }
                if let r = cur?.right {
                    stack.append(r)
                } else {
                    if hasNext {
                        stack.append(nil)
                    }
                }
            } else {
                result = result + "," + "null"
            }

            /*
             有个问题，4,5的子节点，怎么判断不需要加。
             */
        }
        return result
    }
    
    func deserialize(_ data: String) -> TreeNode? {
        if data.isEmpty {
            return nil
        }
        let arr = data.components(separatedBy: ",")
        /*
         递归。扔下一个n+1，返回根节点
         */
        return deserializeTrace(arr, n: 0)
    }
    
    func deserializeTrace(_ datas: [String],n: Int) -> TreeNode? {
        if datas.isEmpty {
            return nil
        }
        if n >= datas.count {
            return nil
        }
        let word = datas[n]
        if word == "null" {
            return nil
        }
        let cur = TreeNode(Int(word)!)
        let left = deserializeTrace(datas, n: 2*n+1)
        let right = deserializeTrace(datas, n: 2*n+2)
        cur.left = left
        cur.right = right
        return cur
    }
    
    // MARK: 337 打家劫舍iii
    /*
     需要间隔。每一层递归，跳两层或者三层
     
     cur = nil，可以走一步或2步
     cur != nil，可以走2步或者3步
     */
    func rob(_ root: TreeNode?) -> Int {
        let step0 = robTrace(root: root)
        let step1 = robTrace(root: root?.left) + robTrace(root: root?.right)
        return step0 > step1 ? step0 : step1
    }
    
    func robTrace(root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        // 跳2
        let l1 = robTrace(root: root.left?.left)
        let l2 = robTrace(root: root.left?.right)
        let r1 = robTrace(root: root.right?.left)
        let r2 = robTrace(root: root.right?.right)
        // 跳3
        let l3 = robTrace(root: root.left?.left)
        let l4 = robTrace(root: root.left?.right)
        let r5 = robTrace(root: root.right?.left)
        let r6 = robTrace(root: root.right?.right)
        return 0
    }
    
    //MARK: 653. 两数之和 IV - 输入 BST
    /*
     给定一个二叉搜索树 root 和一个目标结果 k，如果 BST 中存在两个元素且它们的和等于给定的目标结果，则返回 true。
     
     层次遍历，然后遍历每个数字，看看是否存在剩余的数字
     */
    var findTargetArray:[Int] = []
    func findTarget(_ root: TreeNode?, _ k: Int) -> Bool {
        guard let root = root else {
            return false
        }
        if findTargetArray.contains(k - root.val) {
            return true
        }
        findTargetArray.append(root.val)
        return findTarget(root.left, k) ||
        findTarget(root.right, k)
    }
    
    
    //MARK: 654. 最大二叉树
    /*
     给定一个不重复的整数数组 nums 。 最大二叉树 可以用下面的算法从 nums 递归地构建:

     创建一个根节点，其值为 nums 中的最大值。
     递归地在最大值 左边 的 子数组前缀上 构建左子树。
     递归地在最大值 右边 的 子数组后缀上 构建右子树。
     返回 nums 构建的 最大二叉树
     */

//    struct TreeNode *findRoot(int *nums,int l,int r) {
//        if (l == r) {
//            return NULL;
//        }
//        int max = l;
//        for (int i = l; i < r; i++) {
//            if (nums[max] < nums[i]) {
//                max = i;
//            }
//        }
//        struct TreeNode *root = (struct TreeNode *)malloc(sizeof(struct TreeNode));
//        root->val = nums[max];
//        root->left = findRoot(nums, l, max);
//        root->right = findRoot(nums, max + 1, r);
//        return root;
//    }
//
//
//    struct TreeNode* constructMaximumBinaryTree(int* nums, int numsSize){
//        return findRoot(nums, 0, numsSize);
//    }
    
    
    // 最大二叉树题目变种，找出每个节点的父节点
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
    
    
    //MARK: 700. 二叉搜索树中的搜索
    /*
     给定二叉搜索树（BST）的根节点 root 和一个整数值 val。
     你需要在 BST 中找到节点值等于 val 的节点。 返回以该节点为根的子树。 如果节点不存在，则返回 null 。
     */
    func searchBST(_ root: TreeNode?, _ val: Int) -> TreeNode? {
        guard let root = root else {
            return nil
        }
        if val == root.val {
            return root
        }
        else if val > root.val {
            return searchBST(root.right, val)
        }else {
            return searchBST(root.left, val)
        }
    }
    
    
    //MARK: 701. 二叉搜索树中的插入操作
    /*
     给定二叉搜索树（BST）的根节点 root 和要插入树中的值 value ，将值插入二叉搜索树。 返回插入后二叉搜索树的根节点。 输入数据 保证 ，新值和原始二叉搜索树中的任意节点值都不同。
     注意，可能存在多种有效的插入方式，只要树在插入后仍保持为二叉搜索树即可。 你可以返回 任意有效的结果 。
     
     依据二叉搜索树特性，比root值小的在左边，比root大的在右边，但是注意的是，如果子树为空，则需要构造一个节点。
     */
    func insertIntoBST(_ root: TreeNode?, _ val: Int) -> TreeNode? {
        guard let root = root else {
            return .init(val)
        }
        var pos: TreeNode? = root

        while pos != nil {
            if val < (pos?.val ?? 0) {
                if pos?.left == nil {
                    pos?.left = .init(val)
                    break
                }else {
                    pos = pos?.left
                }
            }else {
                if pos?.right == nil {
                    pos?.right = .init(val)
                    break
                }else {
                    pos = pos?.right
                }
            }
        }
        return root
    }
}
