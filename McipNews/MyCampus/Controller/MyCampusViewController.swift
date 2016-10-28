//
//  MyCampusViewController.swift
//  McipNews
//
//  Created by MAC on 16/7/6.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class MyCampusViewController: UIViewController {
    
    var saveData = Array<ButtonCell>()
    var defaultData = Array<ButtonCell>()

    @IBOutlet var saveCollection: UICollectionView!
    @IBOutlet var defaultCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveCollection.dataSource = self
        self.saveCollection.delegate = self
        self.defaultCollection.dataSource = self
        self.defaultCollection.delegate = self
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(MyCampusViewController.btnUser), view: self))
        self.setAdLoop()
        self.setBtnData()
        self.saveCollection.reloadData()
        self.defaultCollection.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(NoticeViewController.btnUser), view: self))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - init function
    func setAdLoop(){
        let frame = CGRectMake(0, 64, view.bounds.width, 180)
        let imageView = ["mycampus1.png","mycampus2.png","mycampus3.png"]
        let loopView = XHAdLoopView(frame: frame, images: imageView, autoPlay: true, delay: 3, isFromNet: false)
        loopView.delegate = self
        view.addSubview(loopView)
    }
    
    func setBtnData(){
        saveData.append(ButtonCell(image: "calendar.png",title: "日程",url: "/user/getMySchedule"))
        saveData.append(ButtonCell(image: "leave.png",title: "请销假",url: "/user/getMyNoteList"))
        saveData.append(ButtonCell(image: "rollcall.png",title: "点名记录",url: "/education/getMyTodayRollCall"))
        saveData.append(ButtonCell(image: "task.png",title: "作业",url: "/user/getMyHomework"))
        saveData.append(ButtonCell(image: "emptyroom.png",title: "自习室",url: "/education/queryEmptyRoom"))
        defaultData.append(ButtonCell(image: "myclasses.png",title: "我的课表",url: "/education/showCourseTable"))
        defaultData.append(ButtonCell(image: "tests.png",title: "考试安排",url: "/education/showExamSchedule"))
        defaultData.append(ButtonCell(image: "tsgrades.png",title: "本学期成绩",url: "/education/showThisTermClass"))
        defaultData.append(ButtonCell(image: "allgrades.png",title: "已修成绩",url: "/education/showLearnedCourse"))
        saveData.append(ButtonCell(image: "dormitory.png",title: "寝室点名",url: ""))
    }
    
    // MARK: - Button Events
    func btnUser() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("personInfo") as! PersonInfoViewController
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            var buttonCell = ButtonCell()
            let collection = sender as! Collection
            if collection.collectionView.tag == 200 {
                buttonCell = saveData[collection.indexPath.row]
            }else{
                buttonCell = defaultData[collection.indexPath.row]
            }
            let vc = segue.destinationViewController as! MyCampusDetailViewController
            vc.url = buttonCell.url
            vc.navigationItem.title = buttonCell.title
        }
    }
 

}

// MARK: - AdLoop extension
extension MyCampusViewController : XHAdLoopViewDelegate {
    func adLoopView(adLoopView: XHAdLoopView, IconClick index: NSInteger) {
        print(index)
    }
}


// MARK: - UICollection extension
extension MyCampusViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    // MARK: - UICollection DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView.tag == 200 {
            return saveData.count
        }else{
            return defaultData.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = UICollectionViewCell()
        var buttonCell = ButtonCell()
        if collectionView.tag == 200 {
            cell = self.saveCollection.dequeueReusableCellWithReuseIdentifier("saveCell", forIndexPath: indexPath)
            buttonCell = saveData[indexPath.row]
        }else{
            cell = self.defaultCollection.dequeueReusableCellWithReuseIdentifier("defaultCell", forIndexPath: indexPath)
            buttonCell = defaultData[indexPath.row]
        }
        let image = cell.viewWithTag(101) as! UIImageView
        image.image = UIImage(named: buttonCell.image)
        let title = cell.viewWithTag(102) as! UILabel
        title.text = buttonCell.title
        return cell
    }
    
    // MARK: - UICollection delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
//        print(indexPath.row)
//        var buttonCell = ButtonCell()
//        if collectionView.tag == 200 {
//            buttonCell = saveData[indexPath.row]
//        }else{
//            buttonCell = defaultData[indexPath.row]
//        }
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewControllerWithIdentifier("myCampusDetail") as! MyCampusDetailViewController
//        vc.url = buttonCell.url
//        vc.navigationItem.title = buttonCell.title
//        self.hidesBottomBarWhenPushed=true
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.hidesBottomBarWhenPushed=false
        
        if faceid == ""{
            let alertController = UIAlertController(title: "提示", message: "您当前并未进行人脸信息采集，请前往左上角的个人中心进行人脸信息采集", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            if collectionView.tag == 200 && indexPath.row == 5{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("verify") as! VerifyViewController
                vc.type = 1
                //vc.rcid = returnResult.did
//                let vc = ScanCodeViewController()
//                vc.type = 1
                self.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed=false
            }else{
                self.performSegueWithIdentifier("showDetail", sender: Collection(collectionView: collectionView,indexPath: indexPath))
            }
        }
    }
    
}


