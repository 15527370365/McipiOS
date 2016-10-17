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
        self.userImage.contentMode = .ScaleAspectFill
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.bounds.size.width * 0.5
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.whiteColor().CGColor
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
        DataTool.loadPersonInfo() { result -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if image.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
                self.userImage.image = UIImage(data: NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
            }else{
                self.userImage.image = UIImage(named: "default_user_image")
            }
            self.nameLabel.text = result.uname
            var sex = "男"
            if result.usex == 0{
                sex = "女"
            }
            self.sexLabel.text = sex
            self.birthdayLabel.text = result.ubirthday
            self.phoneLabel.text = result.uprovince + " " + result.ucity
            self.emailLabel.text = result.umail
            self.phoneLabel.text = result.uphone
            self.cardLabel.text = result.ucard
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
                self.validator.registerField(textField, rules: [RequiredRule(),EmailRule()])
            case 102:
                self.validator.registerField(textField, rules: [RequiredRule(),PhoneNumberRule()])
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
            print(textInput.text)
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
                alertController.message = "姓名不能为空"
                self.presentViewController(alertController, animated: true, completion: nil)
                //alert.message = "姓名不能为空"
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                hud.label.text = "Waitting"
                DataTool.editUserInfo("uname",value: value) { result -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if result {
                        alertController.message = "修改成功！"
                        self.presentViewController(alertController, animated: true, completion: nil)
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
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Waitting"
        let base64String = CommonFunction.imageToBase64String(gotImage)
        DataTool.editUserInfo("upic",value: base64String!) { result -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if result {
                image = base64String!
                self.userImage.image = UIImage(data: NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
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
