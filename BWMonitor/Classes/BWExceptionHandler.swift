//
//  BWExceptionHandler.swift
//  BWMonitor
//
//  Created by bairdweng on 2020/9/16.
//

import UIKit

open class BWExceptionHandler: NSObject {
    @objc public static let manage = BWExceptionHandler()
    public func exceptionLogWithData() {
        setDefaultHandler()
        let path = getdataPath()
        //        print(path)
        let data = NSData.init(contentsOfFile: path)
        if data != nil {
            //            let crushStr = String.init(data: data! as Data, encoding: String.Encoding.utf8)
            //            print(crushStr!)
            //上传数据
            sendExceptionLogWithData(data: data! as Data, path: path)
            
        }
    }
    func getdataPath() -> String{
        let str = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let urlPath = str.appending("/Exception.txt")
        return urlPath
    }
    ///异常回调
    fileprivate func setDefaultHandler() {
        NSSetUncaughtExceptionHandler { (exception) in
            let arr:NSArray = exception.callStackSymbols as NSArray
            let reason:String = exception.reason!
            let name:String = exception.name.rawValue
            let date:NSDate = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "YYYY/MM/dd hh:mm:ss SS"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            let url:String = String.init(format: "========异常错误报告========\ntime:%@\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",strNowTime,name,reason,arr.componentsJoined(by: "\n"))
            let documentpath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            let path = documentpath.appending("/Exception.txt")
            do{
                try
                    url.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            }catch{}
        }
//        Crittercism.logHandledException（exception）
    }
    // 异常处理啦
    fileprivate func sendExceptionLogWithData(data:Data,path:String){
        print("data=======",data)
    }
    
}
