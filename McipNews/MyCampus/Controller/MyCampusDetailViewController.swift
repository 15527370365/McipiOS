//
//  MyCampusDetailViewController.swift
//  McipNews
//
//  Created by MAC on 16/7/6.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class MyCampusDetailViewController: UIViewController {
    
    var url:String!
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        let url = NSURL(string:"http://139.129.21.70"+self.url)
        print(self.url)
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10)
        request.HTTPMethod = "GET"//设置请求方式为POST，默认为GET
        request.addValue(userid, forHTTPHeaderField: "userid")
        request.addValue(token, forHTTPHeaderField: "token")
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Loading"
        webView.loadRequest(request)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(backBtnEvent))
        self.view.addGestureRecognizer(swipeLeftGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button event
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

extension MyCampusDetailViewController:UIWebViewDelegate{
    func webViewDidFinishLoad(webView: UIWebView){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}
