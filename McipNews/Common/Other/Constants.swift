//
//  Constants.swift
//  Mcip
//
//  Created by MAC on 16/4/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

//项目路径
//let server = "http://www.syzc.net.cn/mcip"
let host = "http://www.wanghongyu.cn"
let server = host+"/mcip"

//登录请求
let POST_LOGIN = server+"/user/login"

//POST
let POST       = server+"/rest/post"

//GET
let GET        = server+"/rest/get"

let NEWS_DETAIL = server + "/detail/getNewsDetail/"

let ALAMOFIRE_KEY="zpckpFMNxCpyjqGVCCcO6oG517wp955vA6ufw0P6"

let PUSH_KEY="Cq5W1obONeLnUYawfGfL4ycg"

let defautImage = "defaultImage"

var userid:String=""
var token:String=""
var image:String=""
//var faceid:String=""
var password:String = ""

var firstWeekTime="2015-03-14 13:14:00"

class Constants: NSObject {

    //声明常量
    //export global constants

}
