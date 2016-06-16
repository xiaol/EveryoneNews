//
//  VisitorViewController.swift
//  Journalism
//
//  Created by Mister on 16/5/27.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SwaggerClient

class VisitorViewController: UIViewController {
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Portrait
    }
    
    var splistViewController:UISplitViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        splistViewController = UIStoryboard.shareStoryBoard.get_UISplitViewController()
        
        if ShareLUser.islogin { // 如果用户已经登陆
        
            (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController = splistViewController
        }
    }
    
    // 随便看看
    @IBAction func casualLook(sender: AnyObject) {
        
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        ShareLUser.getSdkUserToken { (user) in
            
            self.presentViewController(self.splistViewController, animated: false, completion: nil)
        }
    }
    

    @IBAction func WeChatLoginButtonAction(sender: AnyObject) {
        
        UserLoginSdkApiManager.WeChatLogin(self, del: self)
    }
}



extension VisitorViewController:UserLoginManagerDelegate{


    // 新浪登陆按钮点击事件
    @IBAction func SinaLoginButtonAction(sender: AnyObject) {
        
        UserLoginSdkApiManager.SinaLogin(self)
    }
    
    func didReceiveRequestUserSuccessResponse(userR: AnyObject!) {
        if let user = userR as? UserRegister{
            
            ShareLUserRequest.resigterSanFangUser(user, finish: {
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController = self.splistViewController
            })
        }
    }
}