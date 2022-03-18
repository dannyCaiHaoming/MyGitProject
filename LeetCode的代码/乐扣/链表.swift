//
//  链表.swift
//  乐扣
//
//  Created by 蔡浩铭 on 2021/8/30.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

import Foundation

class 链表: Do {
    static func doSomething() {
        let test = 链表()
        

        let l1 = ListNode.init(1)
        let l2 = ListNode.init(2)
        let l3 = ListNode.init(4)
        
        let l4 = ListNode.init(1)
        let l5 = ListNode.init(3)
        let l6 = ListNode.init(4)
    
        
        l1.next = l2
        l2.next = l3
        
        
        l4.next = l5
        l5.next = l6
        
        test.mergeTwoLists(l1, l4)
        
        
//        print(test.detectCycle(l1)?.val)
    }
    
    
    //MARK: 2. 两数相加
    /*
     两个指针，分别指向两个链表的开头，同时进行遍历。知道有一方为空。
     增加进一计算的临时变量。当p1，p2的和大于10，就把进一标志位+1，同时将p1，p2的和减10，存储到新的链表结构中。用完把标志位-1；
     当结束遍历的时候，将继续遍历不为空的一个链表和判断是否增加一个标志位的一个链表。，
     */
    

    /*
     给你两个 非空 的链表，表示两个非负的整数。它们每位数字都是按照 逆序 的方式存储的，并且每个节点只能存储 一位 数字。

     请你将两个数相加，并以相同形式返回一个表示和的链表。

     你可以假设除了数字 0 之外，这两个数都不会以 0 开头。

     输入：l1 = [2,4,3], l2 = [5,6,4]
     输出：[7,0,8]
     解释：342 + 465 = 807.
     */

    /*
     1. 没想好就下手，很多情况没想到
     2. 链表的循环条件，  可以为next不为空，也可以是当下不为空
     */
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        
        // 这个方法还是要构建一个链表。。我自己也知道可以，但是我想用原来的链表直接拼接起来。当下刷题还是快为主吧，不然一小时只有一题
        var r1 = l1
        var r2 = l2
        var head :ListNode?
        var result :ListNode?
        var carry = 0
        while r1 != nil || r2 != nil {
            
            let t1 = r1?.val ?? 0
            let t2 = r2?.val ?? 0
            let t = t1 + t2 + carry
            if result == nil {
                result = .init(0)
                head = result
            }else {
                result?.next = .init(0)
                result = result?.next
            }
            result?.val = t >= 10 ? t-10 : t
            carry = t/10
            
            if r1 != nil {
                r1 = r1?.next
            }
            if r2 != nil {
                r2 = r2?.next
            }
        }
        if carry > 0 {
            result?.next = .init(carry)
        }
        return head

    }
    
    
    //MARK: 146. LRU 缓存机制
    /*
     运用你所掌握的数据结构，设计和实现一个  LRU (最近最少使用) 缓存机制 。
     实现 LRUCache 类：

     LRUCache(int capacity) 以正整数作为容量 capacity 初始化 LRU 缓存
     int get(int key) 如果关键字 key 存在于缓存中，则返回关键字的值，否则返回 -1 。
     void put(int key, int value) 如果关键字已经存在，则变更其数据值；如果关键字不存在，则插入该组「关键字-值」。当缓存容量达到上限时，它应该在写入新数据之前删除最久未使用的数据值，从而为新的数据值留出空间。
      
     进阶：你是否可以在 O(1) 时间复杂度内完成这两种操作？
     */
    /*
     思路：
     利用的特性
     1. 好像就是利用链表特性，能O（1）将链表元素移动到指定位置
     */
    class LRUCache {
        
        var dict:[Int: DulNode] = [:]
        var node: DulNode? = nil
        
        var head: DulNode?
        var tail: DulNode?
        
        var capacity: Int = 0
        var size: Int = 0

        init(_ capacity: Int) {
            self.capacity = capacity
            head = .init(-1, -1)
            tail = .init(-1, -1)
            head?.next = tail
            tail?.prior = head
        }
        
        func get(_ key: Int) -> Int {
            guard let node = dict[key] else {
                return -1
            }
            moveToHead(node)
            return node.val
        }
        
        func put(_ key: Int, _ value: Int) {
            let node = dict[key]
            if node == nil {
                let new = DulNode.init(value, key)
                dict[key] = new
                addToHead(new)
                size += 1
                if size > capacity {
                    if let tail = removeTail() {
                        
                        dict.removeValue(forKey: tail.key)
                        size -= 1
                    }
                }
            } else {
                node?.val = value
                moveToHead(node!)
            }
        }
        
        func addToHead(_ node: DulNode) {
            node.prior = head
            node.next = head?.next
            head?.next?.prior = node
            head?.next = node
        }
        
        func removeNode(_ node: DulNode) {
            node.prior?.next = node.next
            node.next?.prior = node.prior
        }
        
        func moveToHead(_ node: DulNode) {
            removeNode(node)
            addToHead(node)
        }
        
        func removeTail() -> DulNode? {
            if let res = tail?.prior {
                removeNode(res)
                return res
            }
            return nil
        }
    }
    
    // MARK: 206. 反转链表
    /*
     思路：
     一开始用太多变量，思路分散容易乱。
     先从开头的两个开始交换，想想nil->header 怎么能连上下一个，
     然后header怎么怎么反转，然后移到下一个就是从header的下一个开始继续重复就可以了
     */
    func reverseList(_ head: ListNode?) -> ListNode? {
        var pNext: ListNode? = nil
        var right: ListNode? = head
        while right?.next != nil {
            let temp = right?.next
            right?.next = pNext
            pNext = right
            right = temp
        }
        if right != nil {
            right?.next = pNext
        }
        return right
    }
    
    //MARK: 143. 重排链表
    /*
     给定一个单链表 L 的头节点 head ，单链表 L 表示为：
      L0 → L1 → … → Ln-1 → Ln
     请将其重新排列后变为：
     L0 → Ln → L1 → Ln-1 → L2 → Ln-2 → …
     不能只是单纯的改变节点内部的值，而是需要实际的进行节点交换。
     */
    /*
     思路：
     先找到末尾指针，同时从开头和末尾开始，用两个临时指针获取头尾的下一个，然后依次将
     头的下一个指向末尾，末尾的下一个指向头指针下一个临时，头指针下一个临时指向末尾下一个临时。
     */
    /*
     傻逼了，尾指针的下一个需要重复遍历的。
     */
    /*
     答案：  链表也能使用数组存储，然后用数组下标快速寻找
     */
    
    func reorderList(_ head: ListNode?) {
        guard let h = head else {
            return
        }
        var temp:ListNode? = h
        var arr:[ListNode] = []
        while temp != nil {
            arr.append(temp!)
            temp = temp!.next
        }
        var i = 0
        var j = arr.count - 1
        while i < j {
            arr[i].next = arr[j]
            i += 1
            if i == j {
                break
            }
            arr[j].next = arr[i]
            j -= 1
        }
        arr[i].next = nil
    }
    
    //MAKR: 142. 环形链表 II
    /*
     给定一个链表，返回链表开始入环的第一个节点。 如果链表无环，则返回 null。
     为了表示给定链表中的环，我们使用整数 pos 来表示链表尾连接到链表中的位置（索引从 0 开始）。 如果 pos 是 -1，则在该链表中没有环。注意，pos 仅仅是用于标识环的情况，并不会作为参数传递到函数中。
     说明：不允许修改给定的链表。
     */
    /*
     遇事不解，即哈希
     */
    
    func detectCycle(_ head: ListNode?) -> ListNode? {
        var dict:[ListNode:Bool] = [:]
        var temp = head
        while temp != nil {
            if dict[temp!] == true {
                return temp
            }else {
                dict[temp!] = true
            }
            temp = temp?.next
        }
        return temp
    }

    
    //MAKR: 剑指 Offer 52. 两个链表的第一个公共节点
    /*
     输入两个链表，找出它们的第一个公共节点。
     */
    /*
     例如：
     1，2，3，4，5   ；  8，9，3，4，5
     */
    /*
     思路:
     最简单还是哈希
     其次，只要找到前后开始距离差，然后同时遍历，就能有机会找到同一个相等的链表。
     即a，b两个链表同时遍历，哪个到末尾了，就切换到另一个上去，这样就能得到二者的距离差，然后继续遍历。
     */
    func getIntersectionNode(_ head1: ListNode?,_ head2: ListNode?) -> ListNode? {
        
        if head1 == nil || head2 == nil {
            return nil
        }
        
        var p1 = head1
        var p2 = head2
        
        while p1 != p2 {
            
            p1 =  p1 == nil ? head2 : p1?.next
            p2 =  p2 == nil ? head1 : p2?.next
            
        }
        
        return p1
    }
    
    
    //MARK: 剑指 Offer 25. 合并两个排序的链表
    /*
     输入两个递增排序的链表，合并这两个链表并使新链表中的节点仍然是递增排序的。

     示例1：

     输入：1->2->4, 1->3->4
     输出：1->1->2->3->4->4
     */
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        
        var t1 = l1
        var t2 = l2
        guard t1 != nil ,
              t2 != nil
        else {
            return l1 ?? l2
        }
        
        
        var h: ListNode? = ListNode.init(-1)
        let r = h
        
        while t1 != nil,t2 != nil {
            if t1!.val < t2!.val {
                h?.next = t1
                h = t1
                t1 = t1!.next
//                h = t1
            }else {
                h?.next = t2
                h = t2
                t2 = t2!.next
                
            }
        }
        var notNil = t1 ?? t2
        while notNil != nil {
            h?.next = notNil
            h = notNil
            notNil = notNil!.next
        }
        
        
        return r?.next
    }
    
    
    
}

extension ListNode: Hashable {
    
    
    public func hash(into hasher: inout Hasher) {
//        hasher.combine(val)
//        hasher.combine(self.next?.hashValue)
        hasher.combine(ObjectIdentifier(self))
    }
    
    public static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.val == rhs.val && lhs.next?.hashValue == rhs.next?.hashValue
    }
    
    
}
