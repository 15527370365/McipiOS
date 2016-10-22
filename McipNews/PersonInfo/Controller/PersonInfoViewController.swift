//
//  PersonInfoViewController.swift
//  校园微平台
//
//  Created by MAC on 16/8/29.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class PersonInfoViewController: UIViewController {

    var person:Person!
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var collegeLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var signLabel: UILabel!
    @IBOutlet var signView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        userImage.layer.layoutIfNeeded()
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.bounds.size.width * 0.5
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.whiteColor().CGColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if image.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            self.userImage.image = UIImage(data: NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
        }else{
            self.userImage.image = UIImage(named: "default_user_image")
            print(UIImage(named: "default_user_image"))
        }
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Loading"
        DataTool.loadPersonInfo() { result -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            //print(result.userid)
            self.person = result
            self.nameLabel.text = self.person.uname
            var sex = "男"
            if self.person.usex == 0{
                sex = "女"
            }
            self.detailLabel.text = sex
            if self.person.ubirthday.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0{
                if let year = Int (self.person.ubirthday.substringToIndex(self.person.ubirthday.startIndex.advancedBy(5))){
                    self.detailLabel.text = self.detailLabel.text! + " \(CommonFunction.getNowTime().year - year)岁"
                }else{
                    self.detailLabel.text = self.detailLabel.text! + " 0岁"
                }
                
            }
            if self.person.uprovince.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
                self.detailLabel.text = self.detailLabel.text! + " " + self.person.uprovince
            }
            if self.person.ucity.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
                self.detailLabel.text = self.detailLabel.text! + " " + self.person.ucity
            }
            self.collegeLabel.text = self.person.ucollege
            self.classLabel.text = self.person.uclass
            if self.person.udescription.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
                self.signLabel.text = self.person.udescription
            }else{
                self.signLabel.text = ""
            }
        }
    }
    
    @IBAction func backBtnEvents(sender: UIButton) {
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.popViewControllerAnimated(true)
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
