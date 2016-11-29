//
//  CommonFunction.swift
//  McipNews
//
//  Created by MAC on 16/4/24.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreData

class CommonFunction: NSObject {
    class func getMacAddress() -> (success:Bool,ssid:String,mac:String){
        
        if let cfa:NSArray = CNCopySupportedInterfaces() {
            for x in cfa {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                    let ssid = dict["SSID"]!
                    let mac  = dict["BSSID"]!
                    return (true,ssid as! String,mac as! String)
                }
            }
        }
        return (false,"","")
    }
    
    class func getNowTime() -> NSDateComponents{
        let calender=NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let comps=calender!.components([.Year,.Month,.Day,.Hour,.Minute,.Second,.Weekday], fromDate: NSDate())
        return comps;
    }
    
    class func formatTime(time:String)->NSDateComponents{
        let formatter=NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        var timeTemp=(time as NSString).substringToIndex(19)
        //print("time:\(time)+timeTemp:\(timeTemp)")
        timeTemp=timeTemp.stringByReplacingOccurrencesOfString("T", withString: " ")
        //print("time:\(time)+timeTemp:\(timeTemp)")
        let date=formatter.dateFromString(timeTemp)
        let calender=NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        //print(date)
        let comps=calender!.components([.Year,.Month,.Day,.Hour,.Minute,.Second], fromDate: date!)
        return comps;
    }
    
    class func getNowTimeString() -> String{
        let formatter=NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "Asia/Shanghai")
        return formatter.stringFromDate(NSDate())
    }
    
    class func exit(){
        let appDelegate:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let entity:NSEntityDescription? = NSEntityDescription.entityForName("Users", inManagedObjectContext: managedObjectContext)
        let request:NSFetchRequest = NSFetchRequest()
        request.fetchOffset = 0
        request.fetchLimit = 10
        request.entity = entity
        let predicate = NSPredicate(format: "exitTime== %@","")
        request.predicate = predicate
        do{
            let results:[AnyObject]? = try managedObjectContext.executeFetchRequest(request)
            for user:Users in results as! [Users] {
                user.exitTime = CommonFunction.getNowTimeString()
            }
            try managedObjectContext.save()
        }catch{
            print("Core Data Error!")
        }
        token = ""
        userid = ""
        //faceid = ""
        image = ""
        password = ""
        
    }
    
    class func exit(view:AnyObject){
        let appDelegate:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let entity:NSEntityDescription? = NSEntityDescription.entityForName("Users", inManagedObjectContext: managedObjectContext)
        let request:NSFetchRequest = NSFetchRequest()
        request.fetchOffset = 0
        request.fetchLimit = 10
        request.entity = entity
        let predicate = NSPredicate(format: "exitTime== %@","")
        request.predicate = predicate
        do{
            let results:[AnyObject]? = try managedObjectContext.executeFetchRequest(request)
            for user:Users in results as! [Users] {
                user.exitTime = CommonFunction.getNowTimeString()
            }
            try managedObjectContext.save()
        }catch{
            print("Core Data Error!")
        }
        token = ""
        userid = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        view.presentViewController(storyboard.instantiateViewControllerWithIdentifier("Login"), animated: true, completion: nil)
    }
    
    
    class func getWeek() -> NSNumber{
//        let formatter=NSDateFormatter()
//        formatter.dateStyle = .MediumStyle
//        formatter.timeStyle = .ShortStyle
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        formatter.timeZone = NSTimeZone(name: "Asia/Shanghai")
//        let defaultTime=formatter.dateFromString(firstWeekTime)
//        let nowTime=formatter.dateFromString(getNowTimeString())
//        print(defaultTime?.timeIntervalSince1970)
//        print(nowTime?.timeIntervalSince1970)
//        return (nowTime!.timeIntervalSince1970 - defaultTime!.timeIntervalSince1970)/(1000 * 3600 * 24 * 7) + 1
        //获取当前时间
        let now = NSDate()
        
        // 创建一个日期格式器
        let dformatter = NSDateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        let defaultDate = dformatter.dateFromString("2016-08-29")!
        let defaultTime = defaultDate.timeIntervalSince1970
        
        //当前时间的时间戳
        let timeInterval:NSTimeInterval = now.timeIntervalSince1970
        let timeStamp = timeInterval
        //print("当前时间的时间戳：\(timeStamp)")
        
        let d = (timeStamp - defaultTime)/86400
        print(Int(ceil(d/7)))
        return Int(ceil(d/7))
    }
    
    class func imageToBase64String(image:UIImage,headerSign:Bool = false)->String?{
        
        ///根据图片得到对应的二进制编码
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            return nil
        }
        ///根据二进制编码得到对应的base64字符串
        var base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue:0))
        ///判断是否带有头部base64标识信息
        if headerSign {
            ///根据格式拼接数据头 添加header信息，扩展名信息
            base64String = "data:image/png;base64," + base64String
        }
        return base64String
    }
}
