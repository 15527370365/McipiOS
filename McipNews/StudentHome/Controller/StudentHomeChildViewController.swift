//
//  StudentHomeChildViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/21.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class StudentHomeChildViewController: UIViewController {
    
    var titles:[String:Channel]!
    let titleSort = ["学生工作","思政教育","创业就业","讲座引导","规章制度"]
    let titleIndex = ["学生工作":0,"思政教育":1,"创业就业":2,"讲座引导":3,"规章制度":4]
    var lastPage = 0
    var currentPage:Int = 0 {
        didSet {
            //根据currentPage 和 lastPage的大小关系，控制页面的切换方向
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("TableViewController") as! NewsTableViewController
            if currentPage > lastPage {
                vc.ch = titles[titleSort[currentPage]]
                self.pageViewController.setViewControllers([vc], direction: .Forward, animated: true, completion: nil)
            }
            else {
                vc.ch = titles[titleSort[currentPage]]
                self.pageViewController.setViewControllers([vc], direction: .Reverse, animated: true, completion: nil)
            }
            
            lastPage = currentPage
        }
    }

    var pageViewController:UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = self.childViewControllers.first as! UIPageViewController
        pageViewController.dataSource = self
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("TableViewController") as! NewsTableViewController
        vc.ch = titles["学生工作"]
        pageViewController.setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePage(sender: UIControl) {
        currentPage = sender.tag - 100
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

extension StudentHomeChildViewController:UIPageViewControllerDataSource{
    //返回当前页面的下一个页面
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let old=viewController as! NewsTableViewController
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("TableViewController") as! NewsTableViewController
        var index = titleIndex[old.ch.mname]! + 1
        if index == 5 {
            index = 0
        }
        vc.ch = titles[titleSort[index]]
        return vc
        
    }
    
    //返回当前页面的上一个页面
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let old=viewController as! NewsTableViewController
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("TableViewController") as! NewsTableViewController
        var index = titleIndex[old.ch.mname]! - 1
        if index == -1 {
            index = 4
        }
        vc.ch = titles[titleSort[index]]
        return vc
    }
}
