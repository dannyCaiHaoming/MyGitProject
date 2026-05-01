//
//  GCD.swift
//  LearnAsyn
//
//  Created by 蔡浩铭 on 2025/7/6.
//

import Foundation


class GCD {
    static func QueueAndSync() {
        
        
        // 1. 并发队列
        let conrruent_quue = DispatchQueue.global()
        
        // 1.1 并发队列 - 同步任务
        print("并发队列 - 同步任务 - before")
        conrruent_quue.sync {
            print("并发队列 - 同步任务 - doing - \(Thread.current)")
        }
        print("并发队列 - 同步任务 - after")
        
        sleep(1)
        
        // 1.2 并发队列 - 异步任务
        print("并发队列 - 异步任务 - before")
        conrruent_quue.async {
            print("并发队列 - 异步任务 - doing 1- \(Thread.current)")
        }
        conrruent_quue.async {
            print("并发队列 - 异步任务 - doing 2- \(Thread.current)")
        }
        conrruent_quue.async {
            print("并发队列 - 异步任务 - doing 3- \(Thread.current)")
        }
        conrruent_quue.async {
            print("并发队列 - 异步任务 - doing 4- \(Thread.current)")
        }
        print("并发队列 - 异步任务 - after")
        
        sleep(1)
        
        // 2. 串行队列
        let serial_queue = DispatchQueue.init(label: "serial_queue")
        
        // 2.1 串行队列 - 同步任务
        print("串行队列 - 同步任务 - before")
        serial_queue.sync {
            print("串行队列 - 同步任务 - doing - \(Thread.current)")
        }
        print("串行队列 - 同步任务 - after")
        
        sleep(1)
        
        // 2.2 串行队列 - 异步任务
        print("串行队列 - 异步任务 - before")
        serial_queue.async {
            print("串行队列 - 异步任务 - doing 1- \(Thread.current)")
        }
        serial_queue.async {
            print("串行队列 - 异步任务 - doing 2- \(Thread.current)")
        }
        serial_queue.async {
            print("串行队列 - 异步任务 - doing 3- \(Thread.current)")
        }
        serial_queue.async {
            print("串行队列 - 异步任务 - doing 4- \(Thread.current)")
        }

        print("串行队列 - 同步任务 - after")
        
        sleep(1)
        
        
        // 3. 主队列
        let main_queue = DispatchQueue.main
        
        print("主队列 - 异步任务 - before")
        main_queue.async {
            print("主队列 - 同步任务 - doing - \(Thread.current)")
        }
        print("主队列 - 同步任务 - after")
        
        sleep(1)
        
    }
    
    
    static func QueueNest() {
        
        
        // 1. 并发队列 - 异步执行
        let queue = DispatchQueue.global()
        
        // 1.1 嵌套同步
        print("并发队列 - 异步执行 - 开始")
        queue.async {
            print("并发队列 - 异步执行 - 同步执行 - 开始 - \(Thread.current)")
            queue.sync {
                print("并发队列 - 异步执行 - 同步执行 - doing - \(Thread.current)")
            }
            print("并发队列 - 异步执行 - 同步执行 - 结束 - \(Thread.current)")
        }
        print("并发队列 - 异步执行  - 结束")
        
        print("sleep ---- ")
        sleep(5)
        
        // 1.1 嵌套异步
        
        print("并发队列 - 异步执行 - 开始")
        queue.async {
            print("并发队列 - 异步执行 -  异步执行 - 开始 - \(Thread.current)")
            queue.async {
                print("并发队列 - 异步执行 - 异步执行 - doing - \(Thread.current)")
            }
            print("并发队列 - 异步执行 -  异步执行 - 结束 - \(Thread.current)")
        }
        print("并发队列 - 异步执行  - 结束")
        
        print("sleep ---- ")
        sleep(5)
        
        // 2. 并发队列。- 同步执行
        
        
        // 2.1 嵌套同步
        print("并发队列 - 同步执行 - 开始")
        queue.sync {
            print("并发队列 - 同步执行-  同步执行 - 开始 - \(Thread.current)")
            queue.sync {
                print("并发队列 - 同步执行 - 同步执行 - doing - \(Thread.current)")
            }
            print("并发队列 - 同步执行 -  同步执行 - 结束 - \(Thread.current)")
        }
        print("并发队列 - 同步执行  - 结束")
        
        print("sleep ---- ")
        sleep(5)
        
        
        print("并发队列 - 同步执行 - 开始")
        queue.sync {
            print("并发队列 - 同步执行-  异步执行 - 开始 - \(Thread.current)")
            queue.async {
                print("并发队列 - 同步执行 - 异步执行 - doing - \(Thread.current)")
            }
            print("并发队列 - 同步执行 -  异步执行 - 结束 - \(Thread.current)")
        }
        print("并发队列 - 同步执行  - 结束")
        
        print("sleep ---- ")
        sleep(5)
        
        
        // 2.2 嵌套异步
        
    }

}

