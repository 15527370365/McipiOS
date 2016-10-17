//
//  BoxViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/29.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class BoxViewController: UIViewController {
    
    var showDatas = Array<Notices>()
    var type = 0

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self,refreshingAction: #selector(BoxViewController.requestInfo))
        self.tableView.mj_header.beginRefreshing()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(backBtnEvent))
        self.view.addGestureRecognizer(swipeLeftGesture)
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnEvent(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Data
    func requestInfo(){
        DataTool.loadBoxNotices(0,type: self.type){ (result) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result.flag{
                self.showDatas = result.data
                if self.showDatas.count > 10 {
                    self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(BoxViewController.requestMoreInfo))
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func requestMoreInfo() {
        DataTool.loadBoxNotices(showDatas.count,type: self.type){ (result) -> Void in
            self.tableView.mj_footer.endRefreshing()
            if result.flag{
                self.showDatas += result.data
                self.tableView.reloadData()
            }
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

extension BoxViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - UITableViewDataSourrce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return showDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=self.tableView.dequeueReusableCellWithIdentifier("noticeCell")! as UITableViewCell
        let notices = showDatas[indexPath.row] as Notices
        let name = cell.viewWithTag(101) as! UILabel
        name.text = notices.uname
        let time = cell.viewWithTag(102) as! UILabel
        time.text = notices.nsendtime
        let content = cell.viewWithTag(103) as! UILabel
        content.text = notices.ncontent
        let reply = cell.viewWithTag(104) as! UILabel
        reply.text = "共\(notices.nreplynum)条回复"
        if notices.nstate == 1 {
            let stateImage = cell.viewWithTag(105) as! UIImageView
            stateImage.image = UIImage(named: "notice_allget")
            let stateLabel = cell.viewWithTag(106) as! UILabel
            stateLabel.text = "已全部确认"
        }
        let pic = cell.viewWithTag(100) as! UIImageView
        if notices.upic.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            pic.image = UIImage(data: NSData(base64EncodedString: notices.upic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
        }else{
            pic.image = UIImage(named: "default_user_image")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 111
    }
    
    // MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("noticeDetail") as! NoticeDetailViewController
        vc.notices = showDatas[indexPath.row]
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
