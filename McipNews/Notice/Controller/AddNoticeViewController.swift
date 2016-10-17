//
//  AddNoticeViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class AddNoticeViewController: UIViewController {

    // MARK: - Parameters
    var selectReceivers = Array<ReceiverCell>()
    var sendTime = (type:0,time:"")
    @IBOutlet var receiverView: UIView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var timeButton: UIButton!
    
    // MARK: - ViewController override function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        sendBtn.backgroundColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1)
        self.contentTextView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        //print(123)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AddNoticeViewController.setSendTime(_:)),name: "SetSendTimeNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AddNoticeViewController.setReceivers(_:)),name: "SetSendReceiversNotification", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Butten Event
    @IBAction func backBtnEvent(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func sendBtnEvent(sender: UIButton) {
        if self.contentTextView.text != "" {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            hud.label.text = "Loading"
            DataTool.sendNotice(self.selectReceivers,content: self.contentTextView.text,nremindtype: 0,nsendtime: self.sendTime.time,type: self.sendTime.type){ (result) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if result{
                    let alertController = UIAlertController(title: "提示", message: "发送成功", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default){
                        (action) -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    self.navigationController?.popToViewController(storyboard.instantiateViewControllerWithIdentifier("noticeView"), animated: true)
                    
                }else{
                    let alertController = UIAlertController(title: "提示", message: "请稍后再试！", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else{
            let alertController = UIAlertController(title: "提示", message: "请填写通知内容", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Notificaion function
    func setSendTime(notification: NSNotification){
        print(notification.userInfo)
        let userInfo = notification.userInfo as! [String: AnyObject]
        self.sendTime = (userInfo["type"] as! Int, userInfo["time"] as! String)
        if self.sendTime.type == 1 {
            self.timeButton.titleLabel?.text = self.sendTime.time
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func setReceivers(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        self.selectReceivers = userInfo["select"] as! Array<ReceiverCell>
        if let oldView = self.receiverView.viewWithTag(400) {
            oldView.removeFromSuperview()
        }
        let containerView = UIScrollView(frame:CGRect(x: 125, y: self.addBtn.frame.origin.y, width: 118,height: self.addBtn.frame.height))
        containerView.contentSize = CGSizeMake(200, 36)
        containerView.tag = 400
        for i in 0..<self.selectReceivers.count {
            var sum = 0
            if i != 0 {
                sum = 41*i
            }
            let imageView = UIImageView(frame:CGRect(x: CGFloat(sum), y: 0, width: 36,height: self.addBtn.frame.height))
            if self.selectReceivers[i].gpic.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
                imageView.image = UIImage(data: NSData(base64EncodedString: self.selectReceivers[i].gpic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
            }else{
                imageView.image = UIImage(named: "creatNotice_head3-1")
            }
            containerView.addSubview(imageView)
        }
        self.receiverView.addSubview(containerView)
        self.sendBtn.setTitleColor(UIColor(red:0.32, green:0.75, blue:0.95, alpha:1), forState: .Normal)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        segue.destinationViewController
    }*/
 

}

extension AddNoticeViewController:UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView){
        if self.contentTextView.text == "点击输入内容..." {
            self.contentTextView.text = ""
        }
        let defaultFrame = self.contentTextView.frame
        self.contentTextView.frame = CGRectMake(defaultFrame.origin.x, defaultFrame.origin.y, defaultFrame.width, defaultFrame.height-300)
        print(self.contentTextView.frame.height)
        self.contentTextView.reloadInputViews()
    }
}
