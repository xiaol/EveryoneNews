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
        config?.appKey = UMENG_APPKEY
        config?.ePolicy = BATCH
        
        MobClick.start(withConfigure: config)
        
        UMSocialData.setAppKey(UMENG_APPKEY) // 设置友盟 App Key
//        UMSocialQQHandler.setQQWithAppId(QQ_APPID, appKey: QQ_APPSECRET, url: nil) // 设置qq
        UMSocialWechatHandler.setWXAppId(WECHAT_APPID, appSecret: WECHAT_APPSECRET, url: nil) // 设置微信
        
        WeiboSDK.registerApp(SINA_KEY)/// 新浪微博
        
        self.initializationReachabilityMethod()
    }
    
    /// 初始化检测网络情况变化，方法
    fileprivate func initializationReachabilityMethod(){
        
        reachability = NetworkReachabilityManager()
        
        reachability?.listener = { status in
            
            switch status {
            case .notReachable:
                DispatchQueue.main.async {
                    CRToastManager.dismissAllNotifications(false)
                    CRToastManager.J_ShowNotification("无法连接到网络，请稍候再试",tapHidden: true, backColor: UIColor.a_noConn)
                    APPNETWORK = NetworkReachabilityManager.NetworkReachabilityStatus.notReachable
                }
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                DispatchQueue.main.async {
                    if APPNETWORK == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi) {return}
                    CRToastManager.dismissAllNotifications(false)
                    CRToastManager.J_ShowNotification("网络恢复，查看新闻吧", tapHidden: true,backColor: UIColor.a_color2,dismiss:1)
                    APPNETWORK = NetworkReachabilityManager.NetworkReachabilityStatus.reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi)
                }

            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                DispatchQueue.main.async {
                    CRToastManager.dismissAllNotifications(false)
                    CRToastManager.J_ShowNotification("网络为移动蜂窝煤，可能会造成流量流失",tapHidden: true, backColor: UIColor.a_cellular)
                    APPNETWORK = NetworkReachabilityManager.NetworkReachabilityStatus.reachable(NetworkReachabilityManager.ConnectionType.wwan)
                }
            default:
                DispatchQueue.main.async {
                    CRToastManager.dismissAllNotifications(false)
                    CRToastManager.J_ShowNotification("未知网络，可能会造成流量流失",tapHidden: true, backColor: UIColor.a_cellular)
                    APPNETWORK = NetworkReachabilityManager.NetworkReachabilityStatus.unknown
                }
            }
        }
    }

    // 处理Split视图代理方法
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        
        guard let secondaryAsDetailController = secondaryViewController as? DetailAndCommitViewController else { return false }
        guard let _ = secondaryAsDetailController.new else {return true}
        return false
    }
    
    // 控制视图的旋转方向限制
    @objc(application:supportedInterfaceOrientationsForWindow:) func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{
        if IS_PLUS {
            return [UIInterfaceOrientationMask.landscapeLeft,UIInterfaceOrientationMask.landscapeRight,UIInterfaceOrientationMask.portrait]
        }else{
            return UIInterfaceOrientationMask.portrait
        }
    }
}



extension CRToastManager{

    fileprivate class func J_ShowNotification(_ message:String,tapHidden:Bool=false,backColor:UIColor = UIColor.red,dismiss:Double=10000){
    
        var options = [AnyHashable: Any]()
            
        options[kCRToastTextKey] = message
        options[kCRToastTextAlignmentKey] = NSTextAlignment.center.rawValue
        options[kCRToastNotificationTypeKey] = CRToastType.statusBar.rawValue
        options[kCRToastTimeIntervalKey] = dismiss
        options[kCRToastBackgroundColorKey] = backColor
        
        if tapHidden {
            let tap = CRToastInteractionResponder(interactionType: CRToastInteractionType.tap, automaticallyDismiss: true, block: { (_) in })
            options[kCRToastInteractionRespondersKey] = [tap]
        }
        
        CRToastManager.showNotification(options: options) { 
            
        }
    }
}


extension AppDelegate{

    /**
     注册当复制版发生变化时的状态
     */
    func registerPasteboardChangedNotification(){
    
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIPasteboardChanged, object: nil, queue: OperationQueue.main) { (_) in
            
            self.reloadPasteboardChange()
        }
        
        // 需要用户注册才可继续操作
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil, queue: OperationQueue.main) { (_) in
            
            if let currentViewController = UIViewController.getCurrentViewController(){
                
                let viewController = UIStoryboard.shareUserStoryBoard.get_LoginViewController()
                
                currentViewController.present(viewController, animated: true, completion: nil)
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
            
            if let str = UIPasteboard.general.string?.trimmingCharacters(in: NSCharacterSet.whitespaces).lowercased() {
                
                
//                str.grep("[a-z]*(://)?(\w.){1,}(.\w){1,}")
                
                if str.hasPrefix("http://") || str.hasPrefix("https://") || str.hasSuffix(".com") {
                    
                    let alert = UIAlertController(title: nil, message: "检测到您复制了一条链接是否打开", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "不需要", style: .cancel, handler: nil))
                    
                    alert.addAction(UIAlertAction(title: "是的", style: UIAlertActionStyle.default, handler: { (_) in
                        
                        currentViewController.goWebViewController(str)
                    }))
                    
                    currentViewController.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}




private extension UIViewController{
    class func getCurrentViewController() -> UIViewController?{
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController{
            var topViewController = rootViewController
            while let present = topViewController.presentedViewController{
                topViewController = present
            }
            return topViewController
        }
        return nil
    }
}
