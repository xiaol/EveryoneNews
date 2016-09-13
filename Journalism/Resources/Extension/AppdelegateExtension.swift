//
//  App.swift
//  Journalism
//
//  Created by Mister on 16/6/14.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import CRToast
import Alamofire

// 完成登陆设置，和网络监测设置
extension AppDelegate:UISplitViewControllerDelegate {

    func startReachabilityNotifier(){
    
        self.reachability?.startListening()
    }
    
    /// 设置一些方法
    func initAppdelegateMethod(){
        
    /// 开始友盟启动
        let config = UMAnalyticsConfig.sharedInstance()
        config.appKey = UMENG_APPKEY
        config.ePolicy = BATCH
        
        MobClick.startWithConfigure(config)
        
        UMSocialData.setAppKey(UMENG_APPKEY) // 设置友盟 App Key
//        UMSocialQQHandler.setQQWithAppId(QQ_APPID, appKey: QQ_APPSECRET, url: nil) // 设置qq
        UMSocialWechatHandler.setWXAppId(WECHAT_APPID, appSecret: WECHAT_APPSECRET, url: nil) // 设置微信
        
        WeiboSDK.registerApp(SINA_KEY)/// 新浪微博
        
        self.initializationReachabilityMethod()
    }
    
    /// 初始化检测网络情况变化，方法
    private func initializationReachabilityMethod(){
        
        reachability = NetworkReachabilityManager()
        
        reachability?.listener = { status in
            
            switch status {
            case .NotReachable:
                dispatch_async(dispatch_get_main_queue()) {
                    CRToastManager.dismissAllNotifications(false)
                    CRToastManager.J_ShowNotification("无法连接到网络，请稍候再试",backColor: UIColor.a_noConn, tapHidden: true)
                    APPNETWORK = NetworkReachabilityManager.NetworkReachabilityStatus.NotReachable
                }
            case .Reachable(NetworkReachabilityManager.ConnectionType.EthernetOrWiFi):
                dispatch_async(dispatch_get_main_queue()) {
                    if APPNETWORK == NetworkReachabilityManager.NetworkReachabilityStatus.Reachable(NetworkReachabilityManager.ConnectionType.EthernetOrWiFi) {return}
                    CRToastManager.dismissAllNotifications(false)
                    CRToastManager.J_ShowNotification("网络恢复，查看新闻吧", tapHidden: true,backColor: UIColor.a_color2,dismiss:1)
                    APPNETWORK = NetworkReachabilityManager.NetworkReachabilityStatus.Reachable(NetworkReachabilityManager.ConnectionType.EthernetOrWiFi)
                }

            case .Reachable(NetworkReachabilityManager.ConnectionType.WWAN):
                dispatch_async(dispatch_get_main_queue()) {
                    CRToastManager.dismissAllNotifications(false)
                    CRToastManager.J_ShowNotification("网络为移动蜂窝煤，可能会造成流量流失",backColor: UIColor.a_cellular, tapHidden: true)
                    APPNETWORK = NetworkReachabilityManager.NetworkReachabilityStatus.Reachable(NetworkReachabilityManager.ConnectionType.WWAN)
                }
            default:
                dispatch_async(dispatch_get_main_queue()) {
                    CRToastManager.dismissAllNotifications(false)
                    CRToastManager.J_ShowNotification("未知网络，可能会造成流量流失",backColor: UIColor.a_cellular, tapHidden: true)
                    APPNETWORK = NetworkReachabilityManager.NetworkReachabilityStatus.Unknown
                }
            }
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

    private class func J_ShowNotification(message:String,tapHidden:Bool=false,backColor:UIColor = UIColor.redColor(),dismiss:Double=10000){
    
        var options = [NSObject : AnyObject]()
            
        options[kCRToastTextKey] = message
        options[kCRToastTextAlignmentKey] = NSTextAlignment.Center.rawValue
        options[kCRToastNotificationTypeKey] = CRToastType.StatusBar.rawValue
        options[kCRToastTimeIntervalKey] = dismiss
        options[kCRToastBackgroundColorKey] = backColor
        
        if tapHidden {
            let tap = CRToastInteractionResponder(interactionType: CRToastInteractionType.Tap, automaticallyDismiss: true, block: { (_) in })
            options[kCRToastInteractionRespondersKey] = [tap]
        }
        
        CRToastManager.showNotificationWithOptions(options) { 
            
        }
    }
}


extension AppDelegate{

    /**
     注册当复制版发生变化时的状态
     */
    func registerPasteboardChangedNotification(){
    
        NSNotificationCenter.defaultCenter().addObserverForName(UIPasteboardChangedNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            
            self.reloadPasteboardChange()
        }
        
        // 需要用户注册才可继续操作
        NSNotificationCenter.defaultCenter().addObserverForName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            
            if let currentViewController = UIViewController.getCurrentViewController(){
                
                let viewController = UIStoryboard.shareUserStoryBoard.get_LoginViewController()
                
                currentViewController.presentViewController(viewController, animated: true, completion: nil)
            }
        }
    }
    
    /**
     刷新
     */
    func reloadPasteboardChange(){
    
        /// 调用方法如下
        if let currentViewController = UIViewController.getCurrentViewController(){
            
            // 将字符串去掉前后空格并且小写
            if let str = UIPasteboard.generalPasteboard().string?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString {
                
                
//                str.grep("[a-z]*(://)?(\w.){1,}(.\w){1,}")
                
                if str.hasPrefix("http://") || str.hasPrefix("https://") || str.hasSuffix(".com") {
                    
                    let alert = UIAlertController(title: nil, message: "检测到您复制了一条链接是否打开", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "不需要", style: .Cancel, handler: nil))
                    
                    alert.addAction(UIAlertAction(title: "是的", style: UIAlertActionStyle.Default, handler: { (_) in
                        
                        currentViewController.goWebViewController(str)
                    }))
                    
                    currentViewController.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
}




private extension UIViewController{
    class func getCurrentViewController() -> UIViewController?{
        if let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController{
            var topViewController = rootViewController
            while let present = topViewController.presentedViewController{
                topViewController = present
            }
            return topViewController
        }
        return nil
    }
}