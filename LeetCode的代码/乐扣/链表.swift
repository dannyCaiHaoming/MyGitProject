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



}
