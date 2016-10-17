//
//  ItemsViewController.swift
//  McipNews
//
//  Created by MAC on 16/5/23.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    
    var items = [CellModel]()
    let defaultColors = [UIColor(red:0.83, green:0.24, blue:0.26, alpha:1),UIColor(red:0.97, green:0.53, blue:0.14, alpha:1),UIColor(red:0.73, green:0.9, blue:0.22, alpha:1),UIColor(red:0.44, green:0.67, blue:0.86, alpha:1)]

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.96, alpha:1)
        self.tableView.tableFooterView=UIView(frame: CGRectZero)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(backBtnClick))
        self.view.addGestureRecognizer(swipeLeftGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnClick(sender: UIBarButtonItem) {
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

extension ItemsViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - UITableViewDataSourrce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=self.tableView.dequeueReusableCellWithIdentifier("itemCell")! as UITableViewCell
        let view = cell.viewWithTag(100)! as UIView
        let aLabel = cell.viewWithTag(101) as! UILabel
        //let bLabel = cell.viewWithTag(102) as! UILabel
        let timeLabel = cell.viewWithTag(103) as! UILabel
        let color = defaultColors[indexPath.row%4]
        view.backgroundColor = color
        aLabel.textColor = color
        //bLabel.textColor = color
        timeLabel.textColor = color
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 62
    }
    
    // MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
