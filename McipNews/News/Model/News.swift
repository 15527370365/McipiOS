//
//  News.swift
//  McipNews
//
//  Created by MAC on 16/5/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class News: NSObject {
    var newsid:Int
    var ntitle:String
    var nfrom:String
    var ntime:String
    var nimage:String
    
    init(newsid:Int,ntitle:String,nfrom:String,ntime:String,nimage:String) {
        self.newsid=newsid
        self.ntitle=ntitle
        self.nfrom=nfrom
        self.ntime=ntime
        self.nimage=nimage
    }
}
