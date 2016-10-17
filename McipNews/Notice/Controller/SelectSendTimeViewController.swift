//
//  SelectSendTimeViewController.swift
//  McipNews
//
//  Created by MAC on 16/7/1.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Timepiece

class SelectSendTimeViewController: UIViewController {
    
    var type = 0
    var time = ""
    @IBOutlet var defaultSendImage: UIImageView!
    @IBOutlet var customSendImage: UIImageView!
    @IBOutlet var datepicker: UIDatePicker!
    @IBOutlet var sureButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sendBtnEvent(sender: UIButton) {
        let nowDate = CommonFunction.getNowTimeString().dateFromFormat("yyyy-MM-dd HH:mm:SS")
        let timeDate = self.time.dateFromFormat("yyyy-MM-dd HH:mm:SS")
        if nowDate > timeDate && self.type == 1{
            let alertController = UIAlertController(title: "提示", message: "选择的时间不能小于当前时间", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.dismissViewControllerAnimated(true){ () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("SetSendTimeNotification", object: self, userInfo: ["type":self.type,"time":self.time])
            }
        }
    }
    
    @IBAction func backBtnEvent(sender: AnyObject) {
        self.dismissViewControllerAnimated(true,completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func defaultSendBtnEvent(sender: UIControl) {
        self.type = 0
        self.defaultSendImage.hidden = false
        self.customSendImage.hidden = true
        self.datepicker.hidden = true
        self.sureButton.hidden = true
    }
    
    @IBAction func customSendBtnEvent(sender: UIControl) {
        self.type = 1
        self.time = CommonFunction.getNowTimeString()
        self.timeLabel.text = self.time
        self.defaultSendImage.hidden = true
        self.customSendImage.hidden = false
        self.datepicker.hidden = false
        self.sureButton.hidden = false
    }
    @IBAction func sureBtnEvent(sender: UIButton) {
        self.datepicker.hidden = true
        self.sureButton.hidden = true
        let time = self.datepicker.date.stringFromFormat("yyyy-MM-dd HH:mm:SS")
        self.time = time
        self.timeLabel.text = time
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
