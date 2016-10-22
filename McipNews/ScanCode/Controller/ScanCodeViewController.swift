//
//  ScanCodeViewController.swift
//  McipNews
//
//  Created by MAC on 16/7/5.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class ScanCodeViewController: LBXScanViewController {
    
    // 0 课堂点名
    // 1 寝室点名
    var type = 0

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
        let strArr = result.strScanned!.componentsSeparatedByString("#")
        if self.type == 0 {
            DataTool.loadRollCall(result.strScanned!){ (returnResult) -> Void in
                print(returnResult)
                if returnResult.flag && strArr[2] == "1"{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("verify") as! VerifyViewController
                    vc.rcid = strArr[0]
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let alertController = UIAlertController(title: "提示", message: returnResult.content, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                //            self.navigationController?.popViewControllerAnimated(true)
            }
        }else{
            DataTool.loadDormitoryRollcall(result.strScanned!){ (returnResult) -> Void in
                print(returnResult)
                if returnResult.flag{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("verify") as! VerifyViewController
                    vc.type = 1
                    vc.rcid = returnResult.did
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let alertController = UIAlertController(title: "提示", message: returnResult.content, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                //            self.navigationController?.popViewControllerAnimated(true)
            }
            
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
