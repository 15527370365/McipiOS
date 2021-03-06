//
//  CallViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    
    var rccid:NSNumber = 0
    
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        let url = NSURL(string:server+"/education/getClassroomRollCall/\(userid)-\(rccid)")
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10)
        request.HTTPMethod = "GET"//设置请求方式为POST，默认为GET
        request.addValue(userid, forHTTPHeaderField: "userid")
        request.addValue(token, forHTTPHeaderField: "token")
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Loading"
        webView.loadRequest(request)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(backBtn))
        self.view.addGestureRecognizer(swipeLeftGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(sender: UIBarButtonItem) {
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

extension CallViewController:UIWebViewDelegate{
    func webViewDidFinishLoad(webView: UIWebView){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}
