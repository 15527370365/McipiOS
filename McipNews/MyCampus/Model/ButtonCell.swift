//
//  ButtonCell.swift
//  McipNews
//
//  Created by MAC on 16/7/6.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class ButtonCell: NSObject {
    var image:String!
    var title:String!
    var url:String!
    
    init(image:String,title:String,url:String){
        self.image = image
        self.title = title
        self.url = url
    }
    
    override init() {
        
    }
}
