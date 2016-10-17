//
//  CreditNumberRule.swift
//  校园微平台
//
//  Created by MAC on 16/9/11.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftValidator

class CreditNumberRule: RegexRule {
    static let regex = "^(\\d{6})(18|19|20)?(\\d{2})([01]\\d)([0123]\\d)(\\d{3})(\\d|X)?$"
    
    convenience init(message : String = "Invalid Regular Expression"){
        self.init(regex: CreditNumberRule.regex, message : message)
    }
}
