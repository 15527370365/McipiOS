//
//  AppDelegate.swift
//  Mcip
//
//  Created by MAC on 16/4/19.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("didFinishLaunchingWithOptions")
        //MARK: - BPush settings
        let Types = UIUserNotificationType([.Sound,.Alert, .Badge])
        let settings = UIUserNotificationSettings(forTypes: Types, categories: nil)
        application.registerUserNotificationSettings(settings)
        BPush.registerChannel(launchOptions, apiKey: PUSH_KEY, pushMode: BPushMode.Development, withFirstAction: nil, withSecondAction: nil, withCategory: nil, isDebug: true)
        // App 是用户点击推送消息启动
        if (launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {
            let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary
            if ((userInfo) != nil) {
                BPush.handleNotification(userInfo as! [NSObject : AnyObject])
            }
        }
        //角标清0
        let shared = UIApplication.sharedApplication()
        shared.applicationIconBadgeNumber = 0
        //设置状态栏的字体颜色模式
        shared.statusBarStyle = UIStatusBarStyle.LightContent
        self.window?.makeKeyAndVisible()
        
        let entity:NSEntityDescription? = NSEntityDescription.entityForName("Users", inManagedObjectContext:self.managedObjectContext)
        let request:NSFetchRequest = NSFetchRequest()
        request.fetchOffset = 0
        request.fetchLimit = 10
        request.entity = entity
        
        let predicate = NSPredicate(format: "exitTime== %@","")
        request.predicate = predicate
        do{
            let results:[AnyObject]? = try self.managedObjectContext.executeFetchRequest(request)
            for user:Users in results as! [Users] {
                userid=user.userid!
                token=user.token!
                image = user.image!
            }
            if results?.count != 0 {
                if token != "" && !DataTool.checkToken() {
                    CommonFunction.exit()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("Login") as! LoginController
                    vc.state = 1
                    self.window?.rootViewController = vc
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    self.window?.rootViewController=storyboard.instantiateViewControllerWithIdentifier("MainTabBar")
                    NSLog("token:%@", token)
                }
            }
        }catch{
            print("Core Data Error!")
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        print("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        print("applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        print("applicationWillEnterForeground")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        DataTool.loadWeather(){ result -> Void in
//            print(result.weatherImageName1)
//        }
        if token != "" && !DataTool.checkToken() {
            CommonFunction.exit()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Login") as! LoginController
            vc.state = 1
            self.window?.rootViewController = vc
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        print("applicationWillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - BPush func
    
    // 远程推送通知 注册成功
    func application(application: UIApplication , didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        //  向云推送注册 device token
        BPush.registerDeviceToken(deviceToken)
        // 绑定channel.将会在回调中看获得channnelid appid userid 等
        
        BPush.bindChannelWithCompleteHandler({ (result, error) -> Void in
            let baiduUser = result["user_id"] as! String
            let channelID = result["channel_id"] as! String
            //  [self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]];
            // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
            if ((result) != nil){
                BPush.setTag("Mytag", withCompleteHandler: { (result, error) -> Void in
                    if ((result) != nil){
                        NSLog("user_id:%@,channelID:%@",baiduUser,channelID)
                    }
                })
            }
        })
        
        
    }
    
    // 当 DeviceToken 获取失败时，系统会回调此方法
    func application(application: UIApplication , didFailToRegisterForRemoteNotificationsWithError error: NSError ) {
        if error.code == 3010 {
            
        } else {
            
        }
    }
    
    func application(application: UIApplication , didReceiveRemoteNotification userInfo: [ NSObject : AnyObject ]) {
        
        // App 收到推送的通知
        BPush.handleNotification(userInfo as [NSObject : AnyObject]!)
        
        
        let notif    = userInfo as NSDictionary
        let apsDic   = notif.objectForKey ( "aps" ) as! NSDictionary
        let alertDic = apsDic.objectForKey ( "alert" ) as! String
        print(notif)
        // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
        if (application.applicationState == UIApplicationState.Active || application.applicationState == UIApplicationState.Background) {
            let alertView = UIAlertView (title: "收到一条消息", message: alertDic, delegate: nil , cancelButtonTitle: " 取消 ",otherButtonTitles:"确定")
            alertView.show ()
        }
        else//杀死状态下，直接跳转到跳转页面。
        {
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("MainTabBar") as! CustomViewController
            vc.select = 3
            // 根视图是普通的viewctr 用present跳转
            let tabBarCtr = self.window?.rootViewController
            tabBarCtr?.presentViewController(vc, animated: true, completion: nil)
        }
    }
    // 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
    func application(application: UIApplication , didReceiveRemoteNotification userInfo: [ NSObject : AnyObject ], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult ) -> Void ) {
        let notif    = userInfo as NSDictionary
        let apsDic   = notif.objectForKey ( "aps" ) as! NSDictionary
        let alertDic = apsDic.objectForKey ( "alert" ) as! String
        print("ss\(notif)")
        // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
        if (application.applicationState == UIApplicationState.Active || application.applicationState == UIApplicationState.Background) {
            let alertView = UIAlertView (title: "收到一条消息", message: alertDic, delegate: nil , cancelButtonTitle: " 取消 ",otherButtonTitles:"确定")
            alertView.show ()
        }
        else//杀死状态下，直接跳转到跳转页面。
        {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("MainTabBar") as! CustomViewController
            vc.select = 3
            // 根视图是普通的viewctr 用present跳转
            let tabBarCtr = self.window?.rootViewController
            tabBarCtr?.presentViewController(vc, animated: true, completion: nil)
            
            
        }
        
    }
    
    // 注册通知 alert 、 sound 、 badge （ 8.0 之后，必须要添加下面这段代码，否则注册失败）
    func application(application: UIApplication , didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings ) {
        application.registerForRemoteNotifications ()
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "syzc.Mcip" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("McipNews", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

