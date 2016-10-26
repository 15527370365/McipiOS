//
//  NewsController.swift
//  McipNews
//
//  Created by MAC on 16/5/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTableViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var ch:Channel!
    var flag = false
    var newsDatas:[News] = []
    
    override func viewDidLoad() {
        //print(ch)
        super.viewDidLoad()
        self.tableView.delegate=self
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self,refreshingAction: #selector(NewsTableViewController.requestInfo))
        self.tableView.mj_header.beginRefreshing()
        tableView.tableFooterView=UIView.init(frame: CGRectZero)
        //print(self.flag)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - function
    /**
     下拉刷新，加载最新数据
     */
    func requestInfo() {
        if self.newsDatas.count==0 {
            if self.flag {
                DataTool.loadWriteTable() { (newsArray) -> Void in
                    self.tableView.mj_header.endRefreshing()
                    if newsArray.state{
                        self.newsDatas = newsArray.0 + self.newsDatas
                        if self.newsDatas.count > 10{
                            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(NewsTableViewController.requestMoreInfo))
                        }
                        self.tableView.reloadData()
                    }
                    else{
                        print("error")
                        CommonFunction.exit(self)
                    }
                }
            }else{
                DataTool.loadNews((self.ch?.moduleid)!,newsid:0,type:0) { (newsArray) -> Void in
                    self.tableView.mj_header.endRefreshing()
                    if newsArray.state{
                        self.newsDatas = newsArray.0 + self.newsDatas
                        if self.newsDatas.count > 10{
                            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(NewsTableViewController.requestMoreInfo))
                        }
                        self.tableView.reloadData()
                    }
                    else{
                        print("error")
                        CommonFunction.exit(self)
                    }
                }
            }
        }else{
            if self.flag {
                DataTool.loadWriteTable() { (newsArray) -> Void in
                    self.tableView.mj_header.endRefreshing()
                    if newsArray.state{
                        self.newsDatas = newsArray.0 + self.newsDatas
                        if self.newsDatas.count > 10{
                            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(NewsTableViewController.requestMoreInfo))
                        }
                        self.tableView.reloadData()
                    }
                    else{
                        print("error")
                        CommonFunction.exit(self)
                    }
                }
            }else{
                DataTool.loadNews((self.ch?.moduleid)!,newsid:self.newsDatas[0].newsid,type:1) { (newsArray) -> Void in
                    self.tableView.mj_header.endRefreshing()
                    if newsArray.state{
                        self.newsDatas = newsArray.0 + self.newsDatas
                        if self.newsDatas.count > 10{
                            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(NewsTableViewController.requestMoreInfo))
                        }
                        self.tableView.reloadData()
                    }
                    else{
                        print("error")
                        CommonFunction.exit(self)
                    }
                }
            }
        }
        
    }
    /**
     上拉刷新，加载更多数据
     */
    func requestMoreInfo() {
        if flag {
            DataTool.loadWriteTable() { (newsArray) -> Void in
                self.tableView.mj_footer.endRefreshing()
                if newsArray.state{
                    self.newsDatas += newsArray.0
                    //self.page=newPage
                    self.tableView.reloadData()
                }else{
                    print("error")
                    CommonFunction.exit(self)
                }
            }
        }else{
            DataTool.loadNews((self.ch?.moduleid)!,newsid:self.newsDatas[self.newsDatas.count-1].newsid,type: 2) { (newsArray) -> Void in
                self.tableView.mj_footer.endRefreshing()
                if newsArray.state{
                    self.newsDatas += newsArray.0
                    //self.page=newPage
                    self.tableView.reloadData()
                }else{
                    print("error")
                    CommonFunction.exit(self)
                }
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        
        print((cell.viewWithTag(101) as! UILabel).text)
        print(segue.destinationViewController)
    }*/

}

extension NewsTableViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - UITableViewDataSourrce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return newsDatas.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=self.tableView.dequeueReusableCellWithIdentifier("newsCell")! as UITableViewCell
        let news = newsDatas[indexPath.row] as News
        let title = cell.viewWithTag(101) as! UILabel
        let from = cell.viewWithTag(102) as! UILabel
        let time = cell.viewWithTag(103) as! UILabel
        let image = cell.viewWithTag(104) as! UIImageView
        title.text = news.ntitle
        from.text = "来自："+news.nfrom
//        print(news.nimage)
//        print(news.newsid)
        image.kf_setImageWithURL(NSURL(string: news.nimage)!,placeholderImage: UIImage(named: defautImage))
        time.text=news.ntime
        return cell
    }
    
    // MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("NewsDetail") as! NewsDetailViewController
        vc.detailTitle.title = ch.mname
        vc.newsid = newsDatas[indexPath.row].newsid
        if ch.mname == "信息采集" {
            vc.flag = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

