//
//  BWMonitor.swift
//  BWMonitor
//
//  Created by bairdweng on 2020/9/16.
//

import UIKit

open class BWMonitor: NSObject {
    var semaphore: DispatchSemaphore?
    var observer: CFRunLoopObserver?
    var runLoopActivity: CFRunLoopActivity?
    var start: Bool?
    
    @objc public static let manage = BWMonitor()
    
    @objc public func startMonitor() {
        if self.observer == nil {
            self.start = true
            self.semaphore = DispatchSemaphore.init(value: 1)
            //启动一条子线程来监听卡顿
            Thread.detachNewThreadSelector(#selector(subThread), toTarget: self, with: nil)
            var context = CFRunLoopObserverContext.init(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
            self.observer = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0, {(observer, activity, pointer) in
                BWMonitor.manage.runLoopActivity = activity
                // 发送信号
                BWMonitor.manage.semaphore?.signal()
//                BWMonitor.manage.printActivity(active: activity)
            }, &context)
            CFRunLoopAddObserver(CFRunLoopGetMain(), self.observer, CFRunLoopMode.commonModes)
        }
    }
    @objc func subThread() {
        while self.start! {
            //这里设置的阈值为500毫秒。阈值不宜设置的太小，太小会检测到一些用户无感的卡顿。也不宜设置的太大，太大了也会错过一些明显的卡顿
            let wait = self.semaphore?.wait(timeout: .now() + 0.5)
            if wait == DispatchTimeoutResult.timedOut {
                if self.observer != nil {
                    if (self.runLoopActivity == CFRunLoopActivity.beforeSources || self.runLoopActivity == CFRunLoopActivity.afterWaiting) && self.start == true {
                        /*
                         这里检测到卡顿，可以打印堆栈信息查看是在调用哪些方法的时候导致了卡顿。也可以利用PLCrashReporter这个第三方库来协助我们打印堆栈信息。我们需要把堆栈信息发送到服务器以便分析问题
                         */
                        print("卡顿了")
                        for symbol: String in Thread.callStackSymbols {
                            print(symbol)
                        }
                    }
                }
            }
        }
        print("子线程销毁了")
    }
    @objc public  func stopMonitor() {
        if self.observer != nil {
            self.start = false
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer!, CFRunLoopMode.commonModes)
            self.observer = nil
        }
    }
    
    func printActivity(active:CFRunLoopActivity) {
        switch active {
        // 即将进入Loop
        case .entry:
            print("即将进入Loop")
            break
        // 即将处理 Timer
        case .beforeTimers:
            print("即将处理 Timer")
            break
        // 即将处理 Source
        case .beforeSources:
            print("即将处理 Source")
            break
        // 即将进入休眠
        case .beforeWaiting:
            print("即将进入休眠")
            break
        // 刚从休眠中唤醒
        case .afterWaiting:
            print("刚从休眠中唤醒")
            break
        // 退出Loop
        case .exit:
            print("Loop")
            break
        default:
            print("other")
            break
        }
    }
}
