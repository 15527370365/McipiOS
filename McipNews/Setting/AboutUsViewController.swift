//
//  AboutUsViewController.swift
//  校园微平台
//
//  Created by MAC on 16/8/26.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let majorVersion :AnyObject? = infoDictionary! ["CFBundleShortVersionString"]
        self.versionLabel.text = "V \(majorVersion as! String)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnEvents(sender: UIButton) {
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
