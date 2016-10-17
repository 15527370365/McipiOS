//
//  SelectNewReceiverViewController.swift
//  McipNews
//
//  Created by MAC on 16/7/1.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class SelectNewReceiverViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
//        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(backBtnEvent))
//        self.view.addGestureRecognizer(swipeLeftGesture)
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnEvent(sender: AnyObject) {
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
