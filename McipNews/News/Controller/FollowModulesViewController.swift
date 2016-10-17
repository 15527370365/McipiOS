//
//  FollowModulesViewController.swift
//  校园微平台
//
//  Created by MAC on 16/8/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class FollowModulesViewController: UIViewController {
    
    var type:NSNumber!
    
    var saveData:[Channel] = []
    var defaultData:[Channel] = []
    let defaultColors = [UIColor(red:0.94, green:0.57, blue:0.59, alpha:1),UIColor(red:0.96, green:0.56, blue:0.36, alpha:1),UIColor(red:0.22, green:0.68, blue:0.86, alpha:1),UIColor(red:0.42, green:0.75, blue:0.18, alpha:1)]
    
    @IBOutlet var saveCollection: UICollectionView!
    @IBOutlet var defaultCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.saveCollection.dataSource = self
        self.saveCollection.delegate = self
        self.defaultCollection.dataSource = self
        self.defaultCollection.delegate = self
        self.loadDatas()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDatas() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Loading"
        DataTool.loadModules(self.type) { (datas) -> Void in
            self.saveData = datas.followDatas
            self.defaultData = datas.unFollowDatas
            self.defaultCollection.reloadData()
            self.saveCollection.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
//            for i in 0..<self.defaultData.count{
//                print(self.defaultData[i].mname)
//            }
        }
    }
    
    
    @IBAction func sureBtnEvents(sender: UIButton) {
        if saveData.count == 0 {
            let alertController = UIAlertController(title: "提示", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            alertController.message = "请至少选择一个标签！"
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("MainTabBar") as! CustomViewController
            vc.select = self.type.integerValue
            // 根视图是普通的viewctr 用present跳转
            let appDelegate:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController=vc
//            let tabBarCtr = appDelegate.window?.rootViewController
//            
//            tabBarCtr?.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func followModule(sender:UIButton)  {
        let cell = sender.superview?.superview as! UICollectionViewCell
        let path = self.defaultCollection.indexPathForCell(cell)!
        let moduleid = self.defaultData[path.row].moduleid
        DataTool.followModule(moduleid) { (result) -> Void in
            if result {
                self.saveData.append(self.defaultData[path.row])
                self.saveCollection.insertItemsAtIndexPaths([NSIndexPath(forRow: self.saveData.count-1, inSection: 0)])
                self.defaultData.removeAtIndex(path.row)
                self.defaultCollection.deleteItemsAtIndexPaths([path])
                self.saveCollection.reloadData()
                self.defaultCollection.reloadData()
            }else{
                let alertController = UIAlertController(title: "提示", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(okAction)
                alertController.message = "系统异常请稍后再试！"
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func unFollowModule(sender:UIButton)  {
        let cell = sender.superview?.superview as! UICollectionViewCell
        let path = self.saveCollection.indexPathForCell(cell)!
        let moduleid = self.saveData[path.row].moduleid
        DataTool.unFollowModule(moduleid) { (result) -> Void in
            if result {
                self.defaultData.append(self.saveData[path.row])
                self.defaultCollection.insertItemsAtIndexPaths([NSIndexPath(forRow: self.defaultData.count-1, inSection: 0)])
                self.saveData.removeAtIndex(path.row)
                self.saveCollection.deleteItemsAtIndexPaths([path])
                self.defaultCollection.reloadData()
                self.saveCollection.reloadData()
            }else{
                let alertController = UIAlertController(title: "提示", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(okAction)
                alertController.message = "系统异常请稍后再试！"
                self.presentViewController(alertController, animated: true, completion: nil)
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

// MARK: - UICollection extension
extension FollowModulesViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
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
        var channel = Channel()
        if collectionView.tag == 200 {
            cell = self.saveCollection.dequeueReusableCellWithReuseIdentifier("followCell", forIndexPath: indexPath)
            channel = saveData[indexPath.row]
        }else{
            cell = self.defaultCollection.dequeueReusableCellWithReuseIdentifier("unFollowCell", forIndexPath: indexPath)
            channel = defaultData[indexPath.row]
        }
//        print(channel.mname)
//        print(collectionView.tag)
//        print(indexPath.row)
        let button = cell.viewWithTag(100) as! UIButton
        button.setTitle(channel.mname, forState: .Normal)
        //button.tag = 10000 + channel.moduleid.integerValue
        if collectionView.tag == 200 {
            button.addTarget(self, action: #selector(FollowModulesViewController.unFollowModule(_:)), forControlEvents: .TouchUpInside)
            button.setTitleColor(UIColor(red:0.56, green:0.56, blue:0.56, alpha:1), forState: .Normal)
            button.layer.borderColor = UIColor(red:0.56, green:0.56, blue:0.56, alpha:1).CGColor
        }else{
            let index = Int(arc4random() % 4)
            let color = self.defaultColors[index]
            button.setTitleColor(color, forState: .Normal)
            button.layer.borderColor = color.CGColor
            button.addTarget(self, action: #selector(FollowModulesViewController.followModule(_:)), forControlEvents: .TouchUpInside)
        }
        button.layer.borderWidth = 2;
        button.layer.cornerRadius = 16;
        return cell
    }
    
    // MARK: - UICollection delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        print(indexPath.row)
    }
    
}
