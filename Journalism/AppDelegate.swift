//
//  AppDelegate.swift
//  Journalism
//
//  Created by Mister on 16/5/16.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var reachability: Reachability!
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.initAppdelegateMethod()
        
        return true
    }


    
    
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return WeiboSDK.handleOpenURL(url, delegate:UserLoginSdkApiManager.shareWXApiManager()) || UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        
        return WeiboSDK.handleOpenURL(url, delegate: UserLoginSdkApiManager.shareWXApiManager()) || UMSocialSnsService.handleOpenURL(url)
    }
    
    
}




