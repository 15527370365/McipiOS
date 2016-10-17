//
//  NoticeViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/29.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController {
    
    var showDatas = Array<Notices>()
    var allDatas = Array<Notices>()
    var receiveDatas = Array<Notices>()
    var sendDatas = Array<Notices>()
    
    var type = 0
    
    @IBOutlet var selectLabel: UILabel!
    @IBOutlet var strangercountLabel: UILabel!
    @IBOutlet var systemcountLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate=self
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self,refreshingAction: #selector(NoticeViewController.requestInfo))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(NoticeViewController.requestMoreInfo))
        self.tableView.mj_header.beginRefreshing()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        addButton.backgroundColor=UIColor(colorLiteralRed: 68/255.0, green: 187/255.0, blue: 234/255.0, alpha: 1)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(NoticeViewController.btnUser), view: self))
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(NoticeViewController.btnUser), view: self))
        self.tableView.mj_header.beginRefreshing()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Button Events
    func btnUser() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("personInfo") as! PersonInfoViewController
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func boxBtnEvent(sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("boxView") as! BoxViewController
        if sender.tag == 200 {
            vc.navigationItem.title = "系统盒子"
            vc.type = 0
        }else{
            vc.navigationItem.title = "陌生人盒子"
            vc.type = 1
        }
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
    }
    
    @IBAction func codeBtnEvent(sender: UIBarButtonItem) {
        let vc = ScanCodeViewController()
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
    }
    
    
    @IBAction func settingBtnEvents(sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("setting") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    @IBAction func selectBtnEvents(sender: UIButton) {
        var alert: UIAlertController!
        alert = UIAlertController(title: "", message: "请选择要筛选的内容", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cleanAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let allAction = UIAlertAction(title: "全部", style: UIAlertActionStyle.Default, handler: {action in self.changeType(0)})
        let sendAction = UIAlertAction(title: "我发出的", style: UIAlertActionStyle.Default, handler: {action in self.changeType(1)})
        let receiveAction = UIAlertAction(title: "我收到的", style: UIAlertActionStyle.Default, handler: {action in self.changeType(2)})
        
        alert.addAction(cleanAction)
        alert.addAction(allAction)
        alert.addAction(sendAction)
        alert.addAction(receiveAction)
        
        self.presentViewController(alert, animated: true,completion: nil)
    }
    
    func changeType(type:NSNumber)  {
        print(self.receiveDatas.count)
        self.type = type.integerValue
        print(self.type)
        self.setShowDatas()
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    // MARK: - Data
    func requestInfo(){
        DataTool.loadNotices(0){ (result) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result.flag{
                if result.systemcount == 0 {
                    self.systemcountLabel.hidden = true
                }else{
                    self.systemcountLabel.hidden = false
                }
                if result.strangercount == 0 {
                    self.strangercountLabel.hidden = true
                }else{
                    self.strangercountLabel.hidden = false
                }
                self.systemcountLabel.text = "\(result.systemcount)"
                self.strangercountLabel.text = "\(result.strangercount)"
                self.allDatas.removeAll()
                self.receiveDatas.removeAll()
                self.sendDatas.removeAll()
                self.allDatas = result.data
                for notices in result.data{
                    if notices.nflag == 1{
                        self.sendDatas.append(notices)
                    }else{
                        self.receiveDatas.append(notices)
                    }
                }
                self.setShowDatas()
                self.tableView.reloadData()
            }
        }
    }
    
    func requestMoreInfo() {
        DataTool.loadNotices(allDatas.count){ (result) -> Void in
            self.tableView.mj_footer.endRefreshing()
            if result.flag{
                self.systemcountLabel.text = "\(result.systemcount)"
                self.strangercountLabel.text = "\(result.strangercount)"
                self.allDatas += result.data
                for notices in result.data{
                    if notices.nflag == 1{
                        self.sendDatas.append(notices)
                    }else{
                        self.receiveDatas.append(notices)
                    }
                }
                self.setShowDatas()
                self.tableView.reloadData()
            }
        }
    }
    
    func setShowDatas(){
        if self.type == 0 {
            self.showDatas = self.allDatas
            self.selectLabel.text = "全部"
        }else if self.type == 1 {
            self.showDatas = self.sendDatas
            self.selectLabel.text = "我发出的"
        }else{
            self.showDatas = self.receiveDatas
            self.selectLabel.text = "我收到的"
        }
    }
    
    func makeSureNotice(sender:UIButton){
        let cell = sender.superview?.superview as! UITableViewCell
        let path = self.tableView.indexPathForCell(cell)!
        let notice = self.showDatas[path.row]
        notice.unconfirmcount = notice.unconfirmcount.integerValue - 1
        notice.nstate = 1
        DataTool.makeSureNotice(notice.noticeid){ result -> Void in
            if result {
                for i in 0..<self.allDatas.count{
                    if self.allDatas[i].noticeid == notice.noticeid{
                        self.allDatas[i] = notice
                        break
                    }
                }
                for i in 0..<self.receiveDatas.count{
                    if self.receiveDatas[i].noticeid == notice.noticeid{
                        self.receiveDatas[i] = notice
                        break
                    }
                }
                self.showDatas[path.row] = notice
                self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation: .Right)
            }
        }
//        sender.hidden = true
//        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag - 10000, inSection: 0))
//        for index in 104...108 {
//            cell?.viewWithTag(index)?.hidden = false
//        }
    }

}


// MARK: - Extension
extension NoticeViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - UITableViewDataSourrce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return showDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell
        let notices = showDatas[indexPath.row] as Notices
        if notices.nstate == 0 {
            cell = self.tableView.dequeueReusableCellWithIdentifier("noticeReceiveCell")! as UITableViewCell
            let button = cell.viewWithTag(110) as! UIButton
            button.addTarget(self, action: #selector(NoticeViewController.makeSureNotice(_:)), forControlEvents: .TouchUpInside)
            
        }else{
            cell = self.tableView.dequeueReusableCellWithIdentifier("noticeCell")! as UITableViewCell
            let reply = cell.viewWithTag(104) as! UILabel
            reply.text = "共\(notices.nreplynum)条回复"
            if notices.unconfirmcount == 0 {
                let stateImage = cell.viewWithTag(105) as! UIImageView
                stateImage.image = UIImage(named: "notice_allget")
                let stateLabel = cell.viewWithTag(106) as! UILabel
                stateLabel.text = "已全部确认"
            }
        }
        let name = cell.viewWithTag(101) as! UILabel
        name.text = notices.uname
        let time = cell.viewWithTag(102) as! UILabel
        time.text = notices.nsendtime
        let content = cell.viewWithTag(103) as! UILabel
        content.text = notices.ncontent
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
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
