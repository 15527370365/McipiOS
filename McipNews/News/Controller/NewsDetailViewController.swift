//
//  NewsDetailViewController.swift
//  McipNews
//
//  Created by MAC on 16/5/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet var detailTitle: UINavigationItem!
    @IBOutlet var webView: UIWebView!
    var newsid:NSNumber!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webView.delegate = self
        let url = NSURL(string:NEWS_DETAIL+"\(newsid)")
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10)
        
        request.HTTPMethod = "GET"//设置请求方式为POST，默认为GET
        request.addValue(userid, forHTTPHeaderField: "userid")
        request.addValue(token, forHTTPHeaderField: "token")
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "Loading"
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
//        hud.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        webView.loadRequest(request)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(backClicks))
        self.view.addGestureRecognizer(swipeLeftGesture)
        self.tabBarController?.tabBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func backClick() {
//        self.tabBarController?.tabBar.hidden = false
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    @IBAction func backClicks(sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.hidden = false
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

extension NewsDetailViewController:UIWebViewDelegate{
    func webViewDidFinishLoad(webView: UIWebView){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}
