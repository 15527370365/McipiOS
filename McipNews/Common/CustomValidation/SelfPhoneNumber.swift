//
//  SelfPhoneNumber.swift
//  校园微平台
//
//  Created by MAC on 2016/10/25.
//  Copyright © 2016年 MAC. All rights reserved.
//

import Foundation
import SwiftValidator

class SelfPhoneNumberRule: RegexRule {
    static let regex = "^1[34578]\\d{9}$"
    
    convenience init(message : String = "Invalid Regular Expression"){
        self.init(regex: SelfPhoneNumberRule.regex, message : message)
    }
}
