//
//  CellModel.swift
//  McipNews
//
//  Created by MAC on 16/5/25.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class CellModel: NSObject {
    let type:NSNumber
    let data:AnyObject
    
    init(type:NSNumber,data:AnyObject) {
        self.type = type
        self.data=data
    }
}
