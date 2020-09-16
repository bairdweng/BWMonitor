//
//  ViewController.swift
//  BWMonitor
//
//  Created by bairdweng on 09/11/2020.
//  Copyright (c) 2020 bairdweng. All rights reserved.
//

import UIKit
import BWMonitor

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //  开始监听
        BWMonitor.manage.startMonitor()
        let label = BWFpsLabel()
        self.view.addSubview(label)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickOntheSlowRun(_ sender: Any) {
        
        for i in 0...100 {
            Thread.sleep(forTimeInterval: 0.01)
            print(i)
        }
//        NSLog("开始阻塞主线程 \(Date().timeIntervalSince1970)")
//        Thread.sleep(forTimeInterval: 1)
//        NSLog("结束阻塞主线程 \(Date().timeIntervalSince1970)")
    }
    
    @IBAction func clickOntheCrash(_ sender: Any) {
//        let list = [1,2]
//        _ = list[3]
        /// OC 数据越界可正常捕获。swift不行
//        OCExample.hello()
        
        let exception = NSException(name: NSExceptionName(rawValue: "arbitrary"), reason: "arbitrary reason", userInfo: nil)
        exception.raise()
    }
}

