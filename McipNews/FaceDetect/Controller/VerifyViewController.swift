//
//  VerifyViewController.swift
//  FaceDetect
//
//  Created by 赵展浩 on 16/7/17.
//  Copyright © 2016年 Wuhan Shiyizhichuang Network Technology Wuhan Shiyizhichuang Network Technology Co.,Ltd. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import SwiftyJSON

class VerifyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IFlyFaceRequestDelegate, UIAlertViewDelegate  {
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var takePictureButton:UIButton!
    
    var image:UIImage?
    var lastChosenMediaType:String?
    var resultStrings:String?
    var iFlySpFaceRequest: IFlyFaceRequest?
    var type = 0
    var rcid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            takePictureButton.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
    }
    
    func updateDisplay() {
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                imageView.image = image!.fixOrientation().compressedImage()
                imageView.hidden = false
            }
        }
    }
    
    //调用摄像头
    @IBAction func shootPictureOrVideo(sender: UIButton) {
        pickMediaFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    //验证人脸
    @IBAction func verifyFace(sender: AnyObject) {
        self.resultStrings = nil;
        //需要appid, authid, gid
        
        self.iFlySpFaceRequest=IFlyFaceRequest.sharedInstance()
        self.iFlySpFaceRequest?.delegate = self
        
        self.iFlySpFaceRequest?.setParameter(IFlySpeechConstant.FACE_VERIFY(), forKey: IFlySpeechConstant.FACE_SST())
        self.iFlySpFaceRequest?.setParameter("57899eda", forKey: IFlySpeechConstant.APPID())
        self.iFlySpFaceRequest?.setParameter(userid, forKey: IFlySpeechConstant.MFV_AUTH_ID())
        self.iFlySpFaceRequest?.setParameter("del", forKey: "property")
//        self.iFlySpFaceRequest?.setParameter(
//            faceid, forKey: IFlySpeechConstant.FACE_GID())
        self.iFlySpFaceRequest?.setParameter("2000", forKey: "wait_time")
        //  压缩图片大小
        if let imgData = imageView.image  {
            print("reg image data length: \(imgData.compressedData().length)")
            self.iFlySpFaceRequest?.sendRequest(imgData.compressedData())
        }else{
            print("未选择")
            self.performSelectorOnMainThread(#selector(showResultInfo), withObject: "尚未拍摄照片", waitUntilDone: false)
        }
       // let imgData = imageView.image!.compressedData()
        

//        NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
//        NSString* gid=[userDefaults objectForKey:KCIFlyFaceResultGID];
//        if(!gid){
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"结果" message:@"请先注册，或在设置中输入已注册的gid" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            alert=nil;
//            return;
//        }
//        [self.iFlySpFaceRequest setParameter:gid forKey:[IFlySpeechConstant FACE_GID]];

    }
    
    func pickMediaFromSource(sourceType:UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = sourceType
            presentViewController(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController( title:"Error accessing media", message: "Unsupported media source.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        if lastChosenMediaType != nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion:nil)
        
    }
    
    // IFlyFaceRequestDelegate
    
    /**
     * 消息回调
     * @param eventType 消息类型
     * @param params 消息数据对象
     */
    func onEvent(eventType: Int32, withBundle params: String!) {
        print("onEvent | params: \(params)")
    }
    
    /**
     * 数据回调，可能调用多次，也可能一次不调用
     * @param buffer 服务端返回的二进制数据
     */
    func onData(data: NSData!) {
        print("onData | ")
        let result :String = String.init(data: data, encoding: NSUTF8StringEncoding)!
        print("result:\(result)")
        if !result.isEmpty {
            self.resultStrings = result
        }
    }
    
    /**
     * 结束回调，没有错误时，error为null
     * @param error 错误类型
     */
    func onCompleted(error: IFlySpeechError?) {
        if let er = error {
            print("onCompleted | error:\(er.errorDesc)")
            let errorInfo = "错误码：\(error!.errorCode)\n 错误描述：\(error!.errorDesc)"
            self.performSelectorOnMainThread(#selector(showResultInfo), withObject: errorInfo, waitUntilDone: false)
        }else {
            //print(self.resultStrings)
            parseVerifyResult(self.resultStrings!)
        }
    }
    func parseVerifyResult(result: String) {
        print(result)
        var resultInfo = ""
        let resultData: NSData = result.dataUsingEncoding(NSUTF8StringEncoding)!
        let dic=JSON(data: resultData)
        if dic.count != 0 {
            let strSessionType = dic[KCIFlyFaceResultSST].stringValue as NSString
            if strSessionType.isEqualToString(KCIFlyFaceResultVerify) {
                let rst = dic[KCIFlyFaceResultRST].stringValue as NSString
                let ret = dic[KCIFlyFaceResultRet]
                if ret.intValue != 0 {
                    resultInfo=resultInfo.stringByAppendingString("验证错误\n错误码：\(ret)")
                }else {
                    if rst.isEqualToString(KCIFlyFaceResultSuccess) {
                        resultInfo=resultInfo.stringByAppendingString("检测到人脸\n")
                    }else {
                        resultInfo=resultInfo.stringByAppendingString("未检测到人脸\n")
                    }
                    let verf = dic[KCIFlyFaceResultVerf].boolValue
                    if verf != false {
                        resultInfo=resultInfo.stringByAppendingString("验证结果:验证成功!")
                        if self.type == 0{
                            DataTool.loadVerifyFace(self.rcid){ (returnResult) -> Void in
                                
                            }
                        }else{
//                            DataTool.loadVerifyFaceDormitory(self.rcid){ (returnResult) -> Void in
//                                
//                            }
                            let vc = ScanCodeViewController()
                            vc.type = 1
                            self.hidesBottomBarWhenPushed=true
                            self.navigationController?.pushViewController(vc, animated: true)

                        }
                    }else {
                        resultInfo=resultInfo.stringByAppendingString("验证结果:验证失败!")
                    }
                }
            }
        }
        self.performSelectorOnMainThread(#selector(showResultInfo), withObject: resultInfo, waitUntilDone: false)

    }
    
    func showResultInfo(resultInfo:String) {
        let alert = UIAlertView.init(title: "结果", message: resultInfo, delegate: self, cancelButtonTitle: "确定")
        alert.show()
    }

}


