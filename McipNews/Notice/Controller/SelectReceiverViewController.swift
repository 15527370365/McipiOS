//
//  SelectReceiverViewController.swift
//  McipNews
//
//  Created by MAC on 16/7/1.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class SelectReceiverViewController: UIViewController {
    
    var showDatas = Array<ReceiverCell>()
    @IBOutlet var sureButton: UIButton!
    
    var select = Dictionary<NSNumber,ReceiverCell>()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        self.tableView.tableFooterView=UIView.init(frame: CGRectZero)
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Loading"
        DataTool.loadReceiver(){ (result) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if result.flag{
                self.showDatas = result.data
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnEvent(sender: AnyObject) {
        self.dismissViewControllerAnimated(true){ () -> Void in
        }
    }
    
    @IBAction func sureButtonEvent(sender: UIButton) {
        if self.select.count != 0 {
            var temp = Array<ReceiverCell>()
            for value in self.select.values{
                temp.append(value)
            }
            self.dismissViewControllerAnimated(true){ () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("SetSendReceiversNotification", object: self, userInfo: ["select":temp])
            }
//            
//            let vc = self.navigationController?.viewControllers[1] as! AddNoticeViewController
//            vc.selectReceivers = temp
//            vc.addReceiverEvent()
//            self.navigationController?.popToViewController(vc, animated: true)
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

extension SelectReceiverViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - UITableViewDataSourrce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return showDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=self.tableView.dequeueReusableCellWithIdentifier("receiverCell")! as UITableViewCell
        let receiver = showDatas[indexPath.row] as ReceiverCell
        let gname = cell.viewWithTag(102) as! UILabel
        gname.text = receiver.gname
        let pic = cell.viewWithTag(101) as! UIImageView
        if receiver.gpic.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            pic.image = UIImage(data: NSData(base64EncodedString: receiver.gpic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
        }else{
            pic.image = UIImage(named: "creatNotice_head3-1")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 62
    }
    
    // MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let receiver = showDatas[indexPath.row] as ReceiverCell
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        if receiver.flag {
            (cell?.viewWithTag(100) as! UIImageView).image = UIImage(named: "")
            self.select.removeValueForKey(receiver.groupid)
            showDatas[indexPath.row].flag = false
        }else{
            (cell?.viewWithTag(100) as! UIImageView).image = UIImage(named: "creatNotice_checked")
            self.select.updateValue(receiver, forKey: receiver.groupid)
            showDatas[indexPath.row].flag = true
        }
        if self.select.count > 0 {
            self.sureButton.setTitleColor(UIColor(red:0.32, green:0.75, blue:0.95, alpha:1), forState: .Normal)
        }else{
            self.sureButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
    }
}

