//
//  Person.swift
//  校园微平台
//
//  Created by MAC on 16/8/29.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Person: NSObject {
    var userid:String!
    var uname:String!
    var upic:String!
    var usex:NSNumber!
    var ubirthday:String!
    var uprovince:String!
    var ucity:String!
    var ucollege:String!
    var uclass:String!
    var udescription:String!
    var uphone:String!
    var umail:String!
    var ucard:String!
    
    init(data:JSON) {
        self.userid = data["userid"].stringValue
        self.uname = data["uname"].stringValue
        self.upic = data["upic"].stringValue
        self.usex = data["usex"].intValue
        self.ubirthday = data["ubirthday"].stringValue
        self.uprovince = data["uprovince"].stringValue
        self.ucity = data["ucity"].stringValue
        self.ucollege = data["ucollege"].stringValue
        self.uclass = data["uclass"].stringValue
        self.udescription = data["udescription"].stringValue
    }
    
    init(json:JSON) {
        self.userid = json["userid"].stringValue
        self.uname = json["uname"].stringValue
        self.upic = json["upic"].stringValue
        self.usex = json["usex"].intValue
        self.ubirthday = json["ubirthday"].stringValue
        self.uprovince = json["uprovince"].stringValue
        self.ucity = json["ucity"].stringValue
        self.uphone = json["uphone"].stringValue
        self.umail = json["umail"].stringValue
        self.ucard = json["ucredit"].stringValue
    }
    override init() {
        
    }
    
}
