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
