//
//  NewsViewController.swift
//  McipNews
//
//  Created by MAC on 16/5/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class NewsViewController: PageController {
    
    //let alert=UIAlertView(title: "提示", message: "", delegate: nil, cancelButtonTitle: "OK")
    
    var vcTitles:[Channel] = []
    var moreTitles:[Channel] = []
    var state = true
    
    // MARK: - TEST
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
        preloadPolicy = PreloadPolicy.Neighbour
        let result = DataTool.loadNewsChannels(1)
        if !result.1 {
            print("token失效")
            state = false
        }
        let datas = result.0
        //print(datas)
        for i in 0..<datas["follow"].count{
            vcTitles.append(Channel(json: datas["follow"][i]))
        }
        if datas["unfollow"].stringValue != "" {
            for i in 0..<datas["unfollow"].count{
                moreTitles.append(Channel(json: datas["unfollow"][i]))
            }
        }
//        self.menuBGColor = UIColor(red: 201.0/255.0, green: 201.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.menuBGColor = UIColor(red: 34.0/255.0, green: 168.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        self.titleColorNormal = UIColor.whiteColor()
        self.titleColorSelected = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.tintColor = UIColor(red: 34.0/255.0, green: 168.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        self.menuHeight=35
        menuView?.rightView = ButtonTool.setScrollRightAddButton(#selector(NewsViewController.buttonPressed), showView: self, menuHeight: menuHeight)
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(NewsViewController.btnUser),view:self ))
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(NoticeViewController.btnUser), view: self))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PageController DataSource
    func numberOfControllersInPageController(pageController: PageController) -> Int {
        return vcTitles.count
    }
    
    func pageController(pageController: PageController, titleAtIndex index: Int) -> String {
        return vcTitles[index].mname
    }
    
    func pageController(pageController: PageController, viewControllerAtIndex index: Int) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("TableViewController") as! NewsTableViewController
        vc.ch = vcTitles[index]
        return vc
    }
    
    func pageController(pageController: PageController, lazyLoadViewController viewController: UIViewController, withInfo info: NSDictionary) {
        //print(info)
    }
    
    override func menuView(menuView: MenuView, widthForItemAtIndex index: Int) -> CGFloat {
        var count = vcTitles[index].mname.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        //print(vcTitles[index].mname.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        if count%3==0 {
            count = count/3
        }else{
            count = count/3+1
        }
        return CGFloat(25*count)
    }
    
    // MARK: - Button Events
    
    @IBAction func btnCode(sender: UIBarButtonItem) {
        let vc = ScanCodeViewController()
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
    }
    
    @IBAction func btnQuick(sender: AnyObject) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("setting") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    func btnUser() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("personInfo") as! PersonInfoViewController
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    func buttonPressed() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("followModules") as! FollowModulesViewController
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
