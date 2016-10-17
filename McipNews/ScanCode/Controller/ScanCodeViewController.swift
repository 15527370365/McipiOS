//
//  ScanCodeViewController.swift
//  McipNews
//
//  Created by MAC on 16/7/5.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class ScanCodeViewController: LBXScanViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scanStyle=self.setStyle()
        self.isOpenInterestRect = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        
//        for result:LBXScanResult in arrayResult
//        {
//            print("%@",result.strScanned)
//        }
        let result:LBXScanResult = arrayResult[0]
        print(result.strScanned)
        DataTool.loadRollCall(result.strScanned!){ (returnResult) -> Void in
            print(returnResult)
            let alertController = UIAlertController(title: "提示", message: returnResult.content, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
//            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func setStyle() -> LBXScanViewStyle {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On;
        style.photoframeLineW = 6;
        style.photoframeAngleW = 24;
        style.photoframeAngleH = 24;
        style.isNeedShowRetangle = true;
        
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net");
        return style
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
