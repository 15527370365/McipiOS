//
//  UserInfoViewController.swift
//  校园微平台
//
//  Created by MAC on 16/8/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

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
        DataTool.loadPersonInfo() { result -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
