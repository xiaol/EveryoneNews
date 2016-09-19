//
//  AppDelegate.swift
//  Journalism
//
//  Created by Mister on 16/5/16.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import Alamofire
import PINRemoteImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var reachability: NetworkReachabilityManager!
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.initAppdelegateMethod()
        
        // 版本迁移
        RealmMigration.MigrationConfig()
        

        self.registerPasteboardChangedNotification()
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        return WeiboSDK.handleOpen(url, delegate:UserLoginSdkApiManager.shareWXApiManager()) || UMSocialSnsService.handleOpen(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return WeiboSDK.handleOpen(url, delegate: UserLoginSdkApiManager.shareWXApiManager()) || UMSocialSnsService.handleOpen(url)
    }
}




