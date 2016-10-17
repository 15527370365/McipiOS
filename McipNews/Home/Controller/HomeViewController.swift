//
//  HomeViewController.swift
//  McipNews
//
//  Created by MAC on 16/5/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController:UIViewController {

    @IBOutlet var titleItem: UINavigationItem!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var waitingLable: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var weatherImage2: UIImageView!
    
    @IBOutlet var weatherLabel2: UILabel!
    var week:String = "第\(CommonFunction.getWeek())周"
    var cells:[CellModel]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherImage.contentMode = .ScaleAspectFill
        self.weatherImage2.contentMode = .ScaleAspectFill
        //print(CommonFunction.getWeek())
        let barHeight = self.navigationController!.navigationBar.frame.size.height
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView=UIView(frame: CGRectZero)
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(HomeViewController.btnUser), view: self))
        self.navigationItem.titleView = ButtonTool.setNavigationMiddleItem(#selector(HomeViewController.btnUser), view: self, barHeight: barHeight, week: self.week)
        //setNavigationItems()
        weekLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2));
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.bounds.size.width * 0.5
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.userImage.contentMode = .ScaleAspectFill
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Loading"
        DataTool.loadHomePage(){ (result) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.waitingLable.text = "您有\(result.waitingNumber)条待办事项"
            self.cells = result.0
            self.tableView.reloadData()
        }
        let nowTime = CommonFunction.getNowTime()
        monthLabel.text = "\(nowTime.month)/\(nowTime.day)"
        switch nowTime.weekday {
        case 1:
            weekLabel.text = "Sun"
        case 2:
            weekLabel.text = "Mon"
        case 3:
            weekLabel.text = "Tues"
        case 4:
            weekLabel.text = "Wed"
        case 5:
            weekLabel.text = "Thur"
        case 6:
            weekLabel.text = "Fri"
        default:
            weekLabel.text = "Sat"
        }
        DataTool.loadWeather(){ result -> Void in
            print()
            let n1 = (result.weatherImageName1 as NSString).substringWithRange(NSMakeRange(1, 1))
            let n2 = (result.weatherImageName2 as NSString).substringWithRange(NSMakeRange(1, 1))
            if n1 == n2{
                self.weatherImage.kf_setImageWithURL(NSURL(string: "http://m.weather.com.cn/img/a"+n1+".gif")!,placeholderImage: UIImage(named: "weather1"))
                self.weatherImage2.hidden = true
            }else{
                self.weatherImage.kf_setImageWithURL(NSURL(string: "http://m.weather.com.cn/img/a"+n1+".gif")!,placeholderImage: UIImage(named: "weather1"))
                self.weatherImage2.kf_setImageWithURL(NSURL(string: "http://m.weather.com.cn/img/a"+n2+".gif")!,placeholderImage: UIImage(named: "weather1"))
                self.weatherImage2.hidden = false
            }
            //self.weatherImage.image = UIImage(named: result.weatherImageName1)
            self.weatherLabel.text = result.weatherLable
            self.weatherLabel2.text = result.weatherLable2
         }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(NoticeViewController.btnUser), view: self))
        if image.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            self.userImage.image = UIImage(data: NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
        }else{
            self.userImage.image = UIImage(named: "default_user_image")
        }
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
    
    @IBAction func itemsClick(sender: UIControl) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewControllerWithIdentifier("WaitingItems") as! ItemsViewController
//        self.hidesBottomBarWhenPushed=true
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.hidesBottomBarWhenPushed=false
    }
    
    @IBAction func codeBtnEvents(sender: UIBarButtonItem) {
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - tableView extension
extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cells.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cellModel = cells[indexPath.row] as CellModel
        if cellModel.type == 1 {
            let cell=self.tableView.dequeueReusableCellWithIdentifier("courseCell")! as UITableViewCell
            let name = cell.viewWithTag(102) as! UILabel
            let place = cell.viewWithTag(103) as! UILabel
            let num = cell.viewWithTag(104) as! UILabel
            let image = cell.viewWithTag(101) as! UIImageView
            let course = cellModel.data as! Course
            //name.text = "\(course.crname)（\(course.crcredit)学分，\(course.crhours)学时）"
            name.text = course.crname
            place.text = "\(course.place) · \(course.uname)"
            if course.tasknum == 0 {
                num.hidden=true
            }else{
                num.text = "\(course.tasknum)"
            }
            image.image=UIImage(named: course.picName)
            return cell
        }else if cellModel.type == 2{
            let cell=self.tableView.dequeueReusableCellWithIdentifier("noneCell")! as UITableViewCell
            cell.selectionStyle = .None
            return cell
        }else{
            let cell=self.tableView.dequeueReusableCellWithIdentifier("newsCell")! as UITableViewCell
            let title = cell.viewWithTag(201) as! UILabel
            let from = cell.viewWithTag(202) as! UILabel
            let time = cell.viewWithTag(203) as! UILabel
            let image = cell.viewWithTag(204) as! UIImageView
            let news = cellModel.data as! News
            title.text = news.ntitle
            from.text = "来自："+news.nfrom
            print(news.nimage)
            image.kf_setImageWithURL(NSURL(string: news.nimage)!,placeholderImage: UIImage(named: defautImage))
            time.text=news.ntime
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let cellModel = cells[indexPath.row] as CellModel
        if cellModel.type == 1 {
            return 70
        }else if cellModel.type == 2{
            return 127
        }else{
            return 80
        }
    }
    
    // MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let cellModel = cells[indexPath.row] as CellModel
        if cellModel.type==1 {
            let vc = sb.instantiateViewControllerWithIdentifier("CallConditions") as! CallViewController
            vc.rccid = (cellModel.data as! Course).rccid
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
        }else if cellModel.type==3{
            let vc = sb.instantiateViewControllerWithIdentifier("NewsDetail") as! NewsDetailViewController
            vc.detailTitle.title = "新闻"
            vc.newsid = (cellModel.data as! News).newsid
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
        
    }
}



