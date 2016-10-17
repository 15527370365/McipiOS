//
//  Channel.swift
//  McipNews
//
//  Created by MAC on 16/5/15.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Channel: NSObject {
    var moduleid:NSNumber!
    var mintroduce:String!
    var mname:String!
    var mfixed:NSNumber!
    init(dict:NSDictionary){
        self.moduleid=dict["moduleid"] as! NSNumber
        self.mname=dict["mname"] as! String
        self.mintroduce=dict["mintroduce"] as! String
        self.mfixed=dict["mfixed"] as! NSNumber
    }
    init(json:JSON) {
        self.moduleid=json["moduleid"].intValue
        self.mname=json["mname"].stringValue
        self.mintroduce=json["mintroduce"].stringValue
        self.mfixed=json["mfixed"].intValue
    }
    
    override init() {
        
    }
}
