//
//  ReplyCell.swift
//  McipNews
//
//  Created by MAC on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReplyCell: NSObject {
    var uname:String
    var nrtime:String
    var userid:String
    var upic:String
    var nreplycontent:String
    
    init(json:JSON) {
        let comps = CommonFunction.formatTime(json["nrtime"].stringValue)
        self.nrtime = "\(comps.month)-\(comps.day) \(comps.hour):\(comps.minute)"
        self.uname = json["uname"].stringValue
        self.userid = json["userid"].stringValue
        self.upic = json["upic"].stringValue
        self.nreplycontent = json["nreplycontent"].stringValue
    }
}
