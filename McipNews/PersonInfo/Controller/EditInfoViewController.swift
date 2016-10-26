//
//  EditInfoViewController.swift
//  校园微平台
//
//  Created by MAC on 16/8/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftValidator

class EditInfoViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    let validator = Validator()
    var validateState = false

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var cardLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadInfo(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Loading"
        DataTool.loadUserInfo() { result -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if image.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
                self.userImage.image = UIImage(data: NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
                self.userImage.contentMode = .ScaleAspectFill
                self.userImage.layer.layoutIfNeeded()
                self.userImage.layer.masksToBounds = true
                self.userImage.layer.cornerRadius = self.userImage.bounds.size.width * 0.5
            }else{
                self.userImage.image = UIImage(named: "default_user_image")
                self.userImage.contentMode = .ScaleAspectFill
                self.userImage.layer.layoutIfNeeded()
                self.userImage.layer.masksToBounds = true
                self.userImage.layer.cornerRadius = self.userImage.bounds.size.width * 0.5
            }
            self.nameLabel.text = result.user.unickname
            var sex = "男"
            if result.user.usex == 0{
                sex = "女"
            }
            self.sexLabel.text = sex
            self.birthdayLabel.text = result.user.ubirthday
            self.phoneLabel.text = result.user.uprovince + " " + result.user.ucity
            self.emailLabel.text = result.user.umail
            self.phoneLabel.text = result.user.uphone
            self.cardLabel.text = result.user.ucard
        }
    }
    
    @IBAction func imageBtnEvent(sender: UIControl) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        self.imagePicker.modalTransitionStyle=UIModalTransitionStyle.CoverVertical
        self.imagePicker.allowsEditing=true
        self.presentViewController(imagePicker, animated:true, completion: nil)
    }
    
    
    @IBAction func textInputBtnEvent(sender: UIControl) {
        let titleView = sender.viewWithTag(201) as! UILabel
        let valueView = sender.viewWithTag(200) as! UILabel
        let alertController = UIAlertController(title: "编辑资料",
                                                message: titleView.text, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = valueView.text
            switch sender.tag{
            case 100:
                self.validator.registerField(textField, rules: [RequiredRule()])
            case 101:
                self.validator.registerField(textField, rules: [RequiredRule(),SelfMailRule()])
            case 102:
                self.validator.registerField(textField, rules: [RequiredRule(),SelfPhoneNumberRule()])
            case 103:
                self.validator.registerField(textField, rules: [RequiredRule(),CreditNumberRule()])
            default:
                print("")
            }
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .Default,handler: { action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let textInput = alertController.textFields!.first! as UITextField
            self.textInpustSureBtnEvent(sender.tag, value: textInput.text!)
            //print(textInput.text)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changePwdBtnEvent(sender: UIControl) {
        let alertController = UIAlertController(title: "修改密码",
                                                message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "原始密码"
            textField.secureTextEntry = true
            
        }
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "新密码"
            textField.secureTextEntry = true
        }
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "再次输入"
            textField.secureTextEntry = true
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .Default,handler: { action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let oldPwd = alertController.textFields![0] as UITextField
            let newPwd = alertController.textFields![1] as UITextField
            let samePwd = alertController.textFields![2] as UITextField
            let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
            let length = newPwd.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            if samePwd.text != newPwd.text{
                alertController.message = "两次输入的密码不一致"
                self.presentViewController(alertController, animated: true, completion: nil)
            }else if oldPwd.text != password {
                alertController.message = "原始密码错误"
                self.presentViewController(alertController, animated: true, completion: nil)
            }else if newPwd.text == "" {
                alertController.message = "新密码不能为空"
                self.presentViewController(alertController, animated: true, completion: nil)
            }else if length > 15 || length < 6{
                alertController.message = "新密码的长度应该在6-15位"
                self.presentViewController(alertController, animated: true, completion: nil)
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                hud.label.text = "Waitting"
                DataTool.changeLoginPassword(newPwd.text!) { result -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if result {
                        alertController.message = "修改成功！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                        password = newPwd.text!
                    }else{
                        alertController.message = "系统异常，请稍后再试！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func textInpustSureBtnEvent(tag:Int,value:String){
        self.validator.validate(self)
        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
        switch tag {
        case 100:
            if !self.validateState {
                alertController.message = "昵称不能为空"
                self.presentViewController(alertController, animated: true, completion: nil)
                //alert.message = "姓名不能为空"
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                hud.label.text = "Waitting"
                DataTool.editUserInfo("unickname",value: value) { result -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if result {
                        alertController.message = "修改成功！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                        self.nameLabel.text = value
                    }else{
                        alertController.message = "系统异常，请稍后再试！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        case 101:
            if !self.validateState {
                alertController.message = "邮箱不合法"
                self.presentViewController(alertController, animated: true, completion: nil)
                //alert.message = "姓名不能为空"
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                hud.label.text = "Waitting"
                DataTool.editUserInfo("umail",value: value) { result -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if result {
                        alertController.message = "修改成功！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                        self.emailLabel.text = value
                    }else{
                        alertController.message = "系统异常，请稍后再试！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        case 102:
            if !self.validateState {
                alertController.message = "手机号不合法"
                self.presentViewController(alertController, animated: true, completion: nil)
                //alert.message = "姓名不能为空"
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                hud.label.text = "Waitting"
                DataTool.editUserInfo("uphone",value: value) { result -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if result {
                        alertController.message = "修改成功！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                        self.phoneLabel.text = value
                    }else{
                        alertController.message = "系统异常，请稍后再试！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        case 103:
            if !self.validateState {
                alertController.message = "身份证号码不合法"
                self.presentViewController(alertController, animated: true, completion: nil)
                //alert.message = "姓名不能为空"
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                hud.label.text = "Waitting"
                DataTool.editUserInfo("ucredit",value: value) { result -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if result {
                        alertController.message = "修改成功！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                        self.cardLabel.text = value
                    }else{
                        alertController.message = "系统异常，请稍后再试！"
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        default:
            print("")
        }
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

extension EditInfoViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,ValidationDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        self.dismissViewControllerAnimated(true, completion:nil);
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
//        hud.label.text = "Waitting"
        let base64String = CommonFunction.imageToBase64String(gotImage)
//        let changeString = base64String?.stringByReplacingOccurrencesOfString("/", withString: "\\/")
//        print(changeString)
        DataTool.editUserInfo("upic",value: base64String!) { result -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if result {
                image = base64String!
                self.userImage.image = UIImage(data: NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
                self.userImage.contentMode = .ScaleAspectFill
                self.userImage.layer.layoutIfNeeded()
                self.userImage.layer.masksToBounds = true
                self.userImage.layer.cornerRadius = self.userImage.bounds.size.width * 0.5
                //print(base64String!)
                let alertController = UIAlertController(title: "提醒", message: "修改成功", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "提醒", message: "系统异常，请稍后再试", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
            
        }
    }
    
    func validationSuccessful() {
        // submit the form
        self.validateState = true
    }
    
    func validationFailed(errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.redColor().CGColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
            print(error.errorMessage)
        }
        self.validateState = false
    }
}
