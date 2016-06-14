//
//  App.swift
//  Journalism
//
//  Created by Mister on 16/6/14.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import CRToast
import ReachabilitySwift

extension AppDelegate:UISplitViewControllerDelegate {
    
    /// 设置一些方法
    func initAppdelegateMethod(){
    
        UMSocialData.setAppKey(UMENG_APPKEY) // 设置友盟 App Key
        UMSocialQQHandler.setQQWithAppId(QQ_APPID, appKey: QQ_APPSECRET, url: nil) // 设置qq
        UMSocialWechatHandler.setWXAppId(WECHAT_APPID, appSecret: WECHAT_APPSECRET, url: nil) // 设置微信
        WeiboSDK.registerApp(SINA_KEY)/// 新浪微博
        
        UIStoryboard.shareStoryBoard.get_UISplitViewController().delegate = self // 设置SplitViewController 代理方法
        
        self.initializationReachabilityMethod()
    }
    
    /// 初始化检测网络情况变化，方法
    private func initializationReachabilityMethod(){
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
        }
        
        reachability.whenReachable = { reachability in
            
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    
                    if APPNETWORK == Reachability.NetworkStatus.ReachableViaWiFi {return}
                    
                    CRToastManager.J_ShowNotification("网络恢复，查看新闻吧", tapHidden: true,dismiss:1)
                    APPNETWORK = Reachability.NetworkStatus.ReachableViaWiFi
                } else {
                    
                    CRToastManager.J_ShowNotification("网络为移动蜂窝煤，可能会造成流量流失", tapHidden: true)
                    APPNETWORK = Reachability.NetworkStatus.ReachableViaWWAN
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                CRToastManager.J_ShowNotification("无法连接到网络，请稍候再试", tapHidden: false)
                APPNETWORK = Reachability.NetworkStatus.NotReachable
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    // 处理Split视图代理方法
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        
        guard let secondaryAsDetailController = secondaryViewController as? DetailAndCommitViewController else { return false }
        guard let _ = secondaryAsDetailController.new else {return true}
        return false
    }
    
    // 控制视图的旋转方向限制
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask{
        if IS_PLUS {
            return [UIInterfaceOrientationMask.LandscapeLeft,UIInterfaceOrientationMask.LandscapeRight,UIInterfaceOrientationMask.Portrait]
        }else{
            return UIInterfaceOrientationMask.Portrait
        }
    }
}



extension CRToastManager{

    private class func J_ShowNotification(message:String,tapHidden:Bool=false,dismiss:Double=10000){
    
        var options = [NSObject : AnyObject]()
            
        options[kCRToastTextKey] = message
        options[kCRToastTextAlignmentKey] = NSTextAlignment.Center.rawValue
        options[kCRToastNotificationTypeKey] = CRToastType.StatusBar.rawValue
        options[kCRToastTimeIntervalKey] = dismiss
        
        if tapHidden {
            let tap = CRToastInteractionResponder(interactionType: CRToastInteractionType.Tap, automaticallyDismiss: true, block: { (_) in })
            options[kCRToastInteractionRespondersKey] = [tap]
        }
        
        CRToastManager.showNotificationWithOptions(options) { 
            
        }
    }
}