//
//  ButtonTool.swift
//  McipNews
//
//  Created by MAC on 16/5/23.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class ButtonTool: NSObject {
    class func setNavigationLeftImageButton(selector:Selector,view:AnyObject) -> UIButton{

        let left = UIButton(type:UIButtonType.Custom)
        left.tag = 500
        left.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        //print(image)
        if image.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            left.setImage(UIImage(data: NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions(rawValue: 0))!), forState: UIControlState.Normal)
        }else{
            left.setImage(UIImage(named: "default_user_image"), forState: UIControlState.Normal)
        }
        left.layer.masksToBounds = true
        left.layer.cornerRadius = left.bounds.size.width * 0.5
        left.addTarget(view, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        return left
    }
    
    class func setScrollRightAddButton(selector:Selector,showView:AnyObject,menuHeight:CGFloat) -> UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: menuHeight))
        let line = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 35))
        line.backgroundColor = UIColor(red: 175.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1.0)
        view.addSubview(line)
        let button = UIButton(frame: CGRect(x: 2, y: 0, width: 48, height: menuHeight))
        button.addTarget(showView, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        button.setImage(UIImage(named: "more"), forState: .Normal)
        view.addSubview(button)
        return view
    }
    
    class func setNavigationMiddleItem(selector:Selector,view:AnyObject,barHeight:CGFloat,week:String) -> UIView{
        let middleItem = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: barHeight))
        let weekTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: barHeight))
        weekTitle.text = week
        weekTitle.font = UIFont(name: "System", size: 32.0)
        middleItem.addSubview(weekTitle)
//        let weekBtn = UIButton.init(type:UIButtonType.Custom)
//        weekBtn.frame = CGRect(x: 45, y: 0, width: 30, height: barHeight)
//        weekBtn.setImage(UIImage(named: "home_week_down"), forState: UIControlState.Normal)
//        weekBtn.layer.masksToBounds = true
//        weekBtn.layer.cornerRadius = weekBtn.bounds.size.width * 0.5
//        weekBtn.addTarget(view, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
//        middleItem.addSubview(weekBtn)
        return middleItem
    }
}
