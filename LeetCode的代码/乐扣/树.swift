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
        test.isSymmetric(a_1)
        
        
        
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
}
