//
//  CustomViewController.swift
//  校园微平台
//
//  Created by MAC on 16/7/8.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class CustomViewController: UITabBarController {

    var select = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.select != 0 {
            self.selectedIndex = self.select
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController){
        if self.select == 3 {
            let vc = viewController as! NoticeViewController
            vc.tableView.mj_header.beginRefreshing()
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
