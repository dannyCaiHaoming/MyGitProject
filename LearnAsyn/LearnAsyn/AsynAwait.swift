//
//  AsynAwait.swift
//  LearnAsyn
//
//  Created by 蔡浩铭 on 2025/6/23.
//

import Foundation

@MainActor
class AsynAwait: ObservableObject {
    
    @Published var isWake = false
    
    func asyn_timer() async {
        try? await Task.sleep(nanoseconds: 1000)
    }
    
    
    func wakeup() async {
        await asyn_timer()
        self.isWake = true
        
        await test()
        
        GCD.QueueNest()
    }
    
    
    func old_completion(completion: (()->())? = nil) {
        
    }
    
    
    func trans_old_completion() async {
        await withCheckedContinuation { continuation in
            self.old_completion {
                continuation.resume(returning: ())
            }
        }
    }
    
    func test() async {
        await test_asyn1()
        await test_asyn2()
        await test_asyn3()
        
    }
    
    
    func test_asyn1() async {
        print("test_asyn1 - before")
        try? await Task.sleep(nanoseconds: 2000)
        print("test_asyn1 - after")
    }
    
    func test_asyn2() async {
        print("test_asyn2 - before")
        try? await Task.sleep(nanoseconds: 2000)
        print("test_asyn2 - after")
    }
    
    func test_asyn3() async {
        print("test_asyn3 - before")
        try? await Task.sleep(nanoseconds: 2000)
        print("test_asyn3 - after")
    }
    
}
