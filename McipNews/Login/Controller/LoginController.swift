//
//  LoginController.swift
//  Mcip
//
//  Created by MAC on 16/4/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class LoginController: UIViewController {
    
    var state = 0
    let alert=UIAlertView(title: "提示", message: "", delegate: nil, cancelButtonTitle: "OK")
    var refreshControl=UIRefreshControl()
    var dataArray:[AnyObject]=[AnyObject]()
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var userField: UITextField!
    @IBOutlet var passField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loginButton.backgroundColor=UIColor.init(colorLiteralRed: 68/255.0, green: 187/255.0, blue: 234/255.0, alpha: 1)
        if self.state == 1 {
            alert.message="登录信息已失效，请重新登录";
            alert.show()
        }
//        self.automaticallyAdjustsScrollViewInsets=false
//        refreshControl.addTarget(self, action: #selector(refreshData), forControlEvents: UIControlEvents.ValueChanged)
//        refreshControl.attributedTitle=NSAttributedString(string: "松开后自动刷新")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextField(sender: UITextField) {
        self.passField.becomeFirstResponder()
    }
    @IBAction func finishEdit(sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func backTap(sender: UIControl) {
        self.userField.resignFirstResponder()
        self.passField.resignFirstResponder()
    }
    
    @IBAction func loginTap(sender: AnyObject) {
        if userField.text=="" {
            alert.message="请输入用户名";
            alert.show()
            userField.becomeFirstResponder()
        }else if passField.text=="" {
            alert.message="请输入密码";
            alert.show()
            passField.becomeFirstResponder()
        }else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.label.text = "Loading"
            let result=CommonFunction.getMacAddress()
            let parameters = ["consumer_key": ALAMOFIRE_KEY,"userid":userField.text!,"upass":passField.text!,"ustateadd":result.mac,"uequipment":"4","uchannelid":BPush.getChannelId()]
            //print(BPush.getChannelId())
            //let parameters = ["consumer_key": ALAMOFIRE_KEY,"userid":userField.text!,"upass":passField.text!,"ustateadd":result.mac,"uequipment":"4","uchannelid":"123"]
            Alamofire.request(.POST, POST_LOGIN, parameters:parameters).responseJSON() {
                response in
                print(response.request)
                if let jsonValue = response.result.value {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    let resultJSON=JSON(jsonValue)
                    if resultJSON["code"].string=="30000" {
                        let appDelegate:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
                        let manageObjectContext = appDelegate.managedObjectContext
                        let user = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: manageObjectContext) as! Users
                        user.token=resultJSON["token"].string
                        user.userid=self.userField.text
                        user.loginTime=CommonFunction.getNowTimeString()
                        user.exitTime=""
                        user.image=resultJSON["upic"].stringValue
                        do{
                            try manageObjectContext.save()
                            userid = self.userField.text!
                            token = resultJSON["token"].string!
                            image = resultJSON["upic"].stringValue
                            print(token)
                            let news = DataTool.loadNewsChannels(1)
                            if news.1{
                                if news.0["follow"].count == 0{
                                    self.alert.message="请选择感兴趣的新闻模块"
                                    self.alert.show()
                                    let sb = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = sb.instantiateViewControllerWithIdentifier("followModules") as! FollowModulesViewController
                                    vc.type = 1
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }else{
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    self.presentViewController(storyboard.instantiateViewControllerWithIdentifier("MainTabBar"), animated: true, completion: nil)
                                }
                            }else{
                                print("1")
                                self.alert.message="系统异常请稍后再试"
                                self.alert.show()
                            }
                            
                        }catch{
                            print("2")
                            self.alert.message="系统异常请稍后再试"
                            self.alert.show()
                        }
                    }else{
                        self.alert.message=resultJSON["msg"].string
                        self.alert.show()
                    }
                }else{
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.alert.message="登录请求超时，请检查网络"
                    self.alert.show()
                }
            }
            
        }
    }
    
    func refreshData()  {
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    
}
