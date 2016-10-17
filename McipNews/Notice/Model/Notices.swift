//
//  Notices.swift
//  McipNews
//
//  Created by MAC on 16/7/6.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Notices: NSObject {
    var nsendtime: String! //发送时间
    var noticeid: NSNumber! //通知编号
    var nflag: NSNumber! //是否是我发送的：1-是，0-否
    var nreplynum: NSNumber! //回复数量
    var uname: String! //发送者姓名
    var upic: String! //发送者头像
    var ncontent: String! //通知内容
    var unconfirmcount: NSNumber! //未确认人数
    var npublisher: String! //发送者
    var nstate: NSNumber! //通知是否确认：0-否，1-是
    
    init(data:JSON){
        let comps = CommonFunction.formatTime(data["nsendtime"].stringValue)
        self.nsendtime = "\(comps.year)-\(comps.month)-\(comps.day) \(comps.hour):\(comps.minute)"
        self.noticeid = data["noticeid"].intValue
        self.nflag = data["nflag"].intValue
        self.nreplynum = data["nreplynum"].intValue
        self.uname = data["uname"].stringValue
        self.upic = data["upic"].stringValue
        self.ncontent = data["ncontent"].stringValue
        self.unconfirmcount = data["unconfirmcount"].intValue
        self.npublisher = data["npublisher"].stringValue
        self.nstate = data["nstate"].intValue
    }
    
    override init() {
        
    }
    
}
