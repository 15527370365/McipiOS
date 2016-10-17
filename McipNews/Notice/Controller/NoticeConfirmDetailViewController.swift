//
//  NoticeConfirmDetailViewController.swift
//  McipNews
//
//  Created by MAC on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class NoticeConfirmDetailViewController: UIViewController {
    
    var showDatas = Array<User>()
    var sureDatas = Array<User>()
    var noSureDatas = Array<User>()
    var noticeid:NSNumber!
    let color = UIColor(red:0.29, green:0.74, blue:0.91, alpha:1)
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noSureView: UIView!
    @IBOutlet var sureView: UIView!
    @IBOutlet var sureLabel: UILabel!
    @IBOutlet var noSureLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        self.loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Loading"
        DataTool.loadConfirmDetails(self.noticeid) { result -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if result.flag {
                for i in 0..<result.users.count{
                    if result.users[i].nstate == 0{
                        self.noSureDatas.append(result.users[i])
                    }else{
                        self.sureDatas.append(result.users[i])
                    }
                }
                self.sureLabel.text = "已确认(\(self.sureDatas.count))"
                self.noSureLabel.text = "未确认(\(self.noSureDatas.count))"
                self.showDatas = self.sureDatas
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func sureBtnEvents(sender: UIControl) {
        self.sureLabel.textColor = self.color
        self.sureView.backgroundColor = self.color
        self.noSureLabel.textColor = UIColor.blackColor()
        self.noSureView.backgroundColor = UIColor.blackColor()
        self.showDatas = self.sureDatas
        self.tableView.reloadData()
    }
    @IBAction func noSureBtnEvents(sender: UIControl) {
        self.noSureLabel.textColor = self.color
        self.noSureView.backgroundColor = self.color
        self.sureLabel.textColor = UIColor.blackColor()
        self.sureView.backgroundColor = UIColor.blackColor()
        self.showDatas = self.noSureDatas
        self.tableView.reloadData()
    }
    @IBAction func backBtnEvent(sender: UIButton) {
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
extension NoticeConfirmDetailViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - UITableViewDataSourrce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return showDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=self.tableView.dequeueReusableCellWithIdentifier("sureCell")! as UITableViewCell
//        let reply = replyDatas[indexPath.row]
//        let image = cell.viewWithTag(101) as! UIButton
//        if reply.upic.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
//            image.setImage(UIImage(data: NSData(base64EncodedString: notices.upic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!), forState: .Normal)
//        }else{
//            image.setImage(UIImage(named: "default_user_image"), forState: .Normal)
//        }
//        let name = cell.viewWithTag(102) as! UILabel
//        name.text = reply.uname
//        let time = cell.viewWithTag(103) as! UILabel
//        time.text = reply.nrtime
//        let content = cell.viewWithTag(104) as! UILabel
//        content.text = reply.nreplycontent
        let user = self.showDatas[indexPath.row]
        let userImage = cell.viewWithTag(101) as! UIImageView
        if user.upic.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            userImage.image = UIImage(data: NSData(base64EncodedString: user.upic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
        }else{
            userImage.image = UIImage(named: "default_user_image")
        }
        let name = cell.viewWithTag(102) as! UILabel
        name.text = user.uname
        let role = cell.viewWithTag(103) as! UILabel
        role.text = user.nrole
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }
    
    // MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
}
