//
//  SelfMailRule.swift
//  校园微平台
//
//  Created by MAC on 2016/10/25.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftValidator

class SelfMailRule: RegexRule {
    
    static let regex = "^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$"
    
    convenience init(message : String = "Invalid Regular Expression"){
        self.init(regex: SelfMailRule.regex, message : message)
    }
}
