//
//  AppDelegate.swift
//  Journalism
//
//  Created by Mister on 16/5/16.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import PINRemoteImage
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var reachability: Reachability!
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        self.initAppdelegateMethod()
        
        // 版本迁移
        RealmMigration.MigrationConfig()
        
        
        PINRemoteImageManager.sharedImageManager().setProgressiveRendersMaxProgressiveRenderSize(CGSize(width: 2048,height: 2048), completion: nil)
        PINRemoteImageManager.sharedImageManager().setProgressThresholds([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], completion: nil)

        
        return true
    }


    
    
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return WeiboSDK.handleOpenURL(url, delegate:UserLoginSdkApiManager.shareWXApiManager()) || UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        
        return WeiboSDK.handleOpenURL(url, delegate: UserLoginSdkApiManager.shareWXApiManager()) || UMSocialSnsService.handleOpenURL(url)
    }
    
    
}




