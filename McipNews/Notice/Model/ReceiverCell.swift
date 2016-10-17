//
//  ReceiverCell.swift
//  McipNews
//
//  Created by MAC on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReceiverCell: NSObject {
    var gpic:String
    var members = Array<User>()
    var groupid:NSNumber
    var gname:String
    var flag = false
    init(json:JSON){
        self.gpic = json["gpic"].stringValue
        self.groupid = json["groupid"].intValue
        self.gname = json["gname"].stringValue
        for i in 0..<json["members"].count{
            self.members.append(User(json: json["members"][i]))
        }
    }
}
