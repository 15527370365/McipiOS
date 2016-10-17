//
//  Course.swift
//  McipNews
//
//  Created by MAC on 16/5/25.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Course: NSObject {
    var rccid:NSNumber //课程编号
    var crcredit:NSNumber //学分
    var crhours:NSNumber //学时
    var uname:String //任课老师
    var place:String //上课地点
    var crname:String //课程名称
    var tasknum:NSNumber //代表事情数量
    var picName:String //Cell图片名称
    
    init(json:JSON,time:NSNumber) {
        self.rccid = json["classinfo"]["rccid"].intValue
        self.crcredit=json["classinfo"]["crcredit"].intValue
        self.crhours=json["classinfo"]["crhours"].intValue
        self.uname=json["classinfo"]["uname"].stringValue
        self.place=json["classinfo"]["place"].stringValue
        self.crname=json["classinfo"]["crname"].stringValue
        self.tasknum=json["tasknum"].intValue
        switch time {
        case 0:
            self.picName = "home_fst"
        case 1:
            self.picName = "home_snd"
        case 2:
            self.picName = "home_third"
        case 3:
            self.picName = "home_forth"
        case 4:
            self.picName = "home_fifth"
        default:
            self.picName = "home_fst"
        }
    }
}
