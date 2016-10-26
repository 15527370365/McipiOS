//
//  StudentHomeViewController.swift
//  McipNews
//
//  Created by MAC on 16/5/14.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class StudentHomeController: PageController {
    
    var shArray = Dictionary<String,Channel>()
    var ptArray = Dictionary<String,Channel>()
    var vcTitles:[Channel] = []
    var moreTitles:[Channel] = []
    var childTitles:[Channel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
        preloadPolicy = PreloadPolicy.Neighbour
        let result = DataTool.loadNewsChannels(0)
        if !result.1 {
            print("没有关注模块")
            CommonFunction.exit(self)
        }
        //print(result)
        let datas = result.0
        //print(datas)
        vcTitles.append(Channel(dict:["mname":"学子家园","moduleid":1,"mintroduce":"","mfixed":1]))
        vcTitles.append(Channel(dict:["mname":"党建园地","moduleid":1,"mintroduce":"","mfixed":1]))
        for i in 0..<datas["follow"].count{
            let tempChannel = Channel(json: datas["follow"][i])
            switch tempChannel.mname {
            case "思政教育":
                shArray["思政教育"] = tempChannel
            case "创业就业":
                shArray["创业就业"] = tempChannel
            case "学生工作":
                shArray["学生工作"] = tempChannel
            case "讲座引导":
                shArray["讲座引导"] = tempChannel
            case "规章制度":
                shArray["规章制度"] = tempChannel
            case "党建动态":
                ptArray["党建动态"] = tempChannel
            case "特别策划":
                ptArray["特别策划"] = tempChannel
            case "信息采集":
                ptArray["信息采集"] = tempChannel
            case "闪闪红星":
                ptArray["闪闪红星"] = tempChannel
            default:
                vcTitles.append(tempChannel)
            }
            
        }
//        childTitles.append(shArray["学生工作"]!)
//        childTitles.append(shArray["思政教育"]!)
//        childTitles.append(shArray["创业就业"]!)
//        childTitles.append(shArray["讲座引导"]!)
//        childTitles.append(shArray["规章制度"]!)
        for i in 0..<datas["unfollow"].count{
            moreTitles.append(Channel(json: datas["unfollow"][i]))
        }
        self.menuBGColor = UIColor(red: 34.0/255.0, green: 168.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        self.titleColorNormal = UIColor.whiteColor()
        self.titleColorSelected = UIColor.whiteColor()
    }

    override func viewDidLoad() {
        //print("123")
        super.viewDidLoad()
        if vcTitles.count == 0 {
            print("none")
            CommonFunction.exit(self)
        }
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.tintColor = UIColor(red: 34.0/255.0, green: 168.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        //menuView?.rightView = setRightButton()
        self.menuHeight=35
        menuView?.rightView = ButtonTool.setScrollRightAddButton(#selector(StudentHomeController.buttonPressed), showView: self, menuHeight: menuHeight)
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(StudentHomeController.btnUser), view: self))
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(NoticeViewController.btnUser), view: self))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    private func setRightButton() -> UIView{
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: menuHeight))
//        let line = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 35))
//        line.backgroundColor = UIColor(red: 175.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1.0)
//        view.addSubview(line)
//        let button = UIButton(frame: CGRect(x: 2, y: 0, width: 48, height: menuHeight))
//        button.addTarget(self, action: #selector(StudentHomeController.buttonPressed), forControlEvents: UIControlEvents.TouchUpInside)
//        button.setImage(UIImage(named: "more"), forState: .Normal)
//        view.addSubview(button)
//        return view
//    }
    
    // MARK: - PageController DataSource
    func numberOfControllersInPageController(pageController: PageController) -> Int {
        return vcTitles.count
    }
    
    func pageController(pageController: PageController, titleAtIndex index: Int) -> String {
        return vcTitles[index].mname
    }
    
    func pageController(pageController: PageController, viewControllerAtIndex index: Int) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if vcTitles[index].mname == "学子家园" {
            let vc = sb.instantiateViewControllerWithIdentifier("StudentHomeChild") as! StudentHomeChildViewController
            vc.titles = shArray
            return vc
        }else if vcTitles[index].mname == "党建园地" {
            let vc = sb.instantiateViewControllerWithIdentifier("PartySetChild") as! PartySetChildViewController
            vc.titles = ptArray
            return vc
        }else{
            let vc = sb.instantiateViewControllerWithIdentifier("TableViewController") as! NewsTableViewController
            vc.ch = vcTitles[index]
            return vc
        }
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
        return CGFloat(20*count)
    }
    
    // MARK: - Button Events
    
    func buttonPressed() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("followModules") as! FollowModulesViewController
        vc.type = 0
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
    
    @IBAction func codeBtnEvents(sender: UIBarButtonItem) {
        let vc = ScanCodeViewController()
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
    }
    @IBAction func settingBtnEvents(sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("setting") as! SettingViewController
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
