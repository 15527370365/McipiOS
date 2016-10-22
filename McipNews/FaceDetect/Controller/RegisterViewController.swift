//
//  TestViewController.swift
//  FaceDetect
//
//  Created by 赵展浩 on 16/7/16.
//  Copyright © 2016年 Wuhan Shiyizhichuang Network Technology Wuhan Shiyizhichuang Network Technology Co.,Ltd. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import SwiftyJSON
import CoreData

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IFlyFaceRequestDelegate, UIAlertViewDelegate {
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var takePictureButton:UIButton!
    
    var image:UIImage?
    var lastChosenMediaType:String?
    var resultStrings:String?
    var iFlySpFaceRequest: IFlyFaceRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            takePictureButton.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
    }
    
    //调用摄像头
    @IBAction func shootPictureOrVideo(sender: UIButton) {
        pickMediaFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    
    func updateDisplay() {
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                imageView.image = image!.fixOrientation().compressedImage()
                imageView.hidden = false

            }
        }
    }
    
    //注册人脸
    @IBAction func registerFace(sender: AnyObject) {
        self.resultStrings = nil;
        
        
        self.iFlySpFaceRequest=IFlyFaceRequest.sharedInstance()
        self.iFlySpFaceRequest?.delegate = self
        
        self.iFlySpFaceRequest?.setParameter(IFlySpeechConstant.FACE_REG(), forKey: IFlySpeechConstant.FACE_SST())
        self.iFlySpFaceRequest?.setParameter("57899eda", forKey: IFlySpeechConstant.APPID())
        self.iFlySpFaceRequest?.setParameter("57899eda", forKey: "auth_id")
        self.iFlySpFaceRequest?.setParameter("del", forKey: "property")

        //  压缩图片大小
        if let imgData = imageView.image  {
            print("reg image data length: \(imgData.compressedData().length)")
            self.iFlySpFaceRequest?.sendRequest(imgData.compressedData())
        }else{
            print("未选择")
            self.performSelectorOnMainThread(#selector(showResultInfo), withObject: "尚未拍摄照片", waitUntilDone: false)
        }
        
        
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
            self.performSelectorOnMainThread(#selector(showResultInfo), withObject: "成功啦", waitUntilDone: false)
            let result = JSON(data: self.resultStrings!.dataUsingEncoding(NSUTF8StringEncoding)!)
            print("asda"+result["gid"].stringValue)
            let appDelegate:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
            let manageObjectContext = appDelegate.managedObjectContext
            let entity:NSEntityDescription? = NSEntityDescription.entityForName("Users", inManagedObjectContext:manageObjectContext)
            let request:NSFetchRequest = NSFetchRequest()
            request.fetchOffset = 0
            request.fetchLimit = 10
            request.entity = entity
            let predicate = NSPredicate(format: "exitTime== %@","")
            request.predicate = predicate
            do{
                let results = try manageObjectContext.executeFetchRequest(request) as! [Users]
                results[0].faceid = result["gid"].stringValue
                faceid = result["gid"].stringValue
                do {
                    try manageObjectContext.save()
                } catch  {
                    print("Core Data Error!")
                }
            }catch{
                print("Core Data Error!")
            }

        }
    }
    
    func showResultInfo(resultInfo:String) {
        let alert = UIAlertView.init(title: "结果", message: resultInfo, delegate: self, cancelButtonTitle: "确定")
        alert.show()
    }
    
    //Data praser
    func praseRegResult(result:String) {
        
    }
    
    func praseVerifyResult(result:String) {
        
    }
    
}
