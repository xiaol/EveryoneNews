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
    
    override var shouldAutorotate : Bool {
        
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if ShareLUser.islogin { // 如果用户已经登陆
            let splistViewController = UIStoryboard.shareStoryBoard.get_UISplitViewController()
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = splistViewController
        }
    }
    
    // 随便看看
    @IBAction func casualLook(_ sender: UIButton) {
        
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        sender.isEnabled = false
        
        ShareLUser.getSdkUserToken({ (token) in
            
            let splistViewController = UIStoryboard.shareStoryBoard.get_UISplitViewController()
            self.present(splistViewController, animated: false, completion: nil)
            
        }) {
                
                sender.isEnabled = true
        }
    }
    

    @IBAction func WeChatLoginButtonAction(_ sender: AnyObject) {
        
        UserLoginSdkApiManager.WeChatLogin(self, del: self)
    }
}



extension VisitorViewController:UserLoginManagerDelegate{


    // 新浪登陆按钮点击事件
    @IBAction func SinaLoginButtonAction(_ sender: AnyObject) {
        
        UserLoginSdkApiManager.SinaLogin(self)
    }
    
    func didReceiveRequestUserSuccessResponse(_ userR: AnyObject!) {
        if let user = userR as? UserRegister{
            
            ShareLUserRequest.resigterSanFangUser(user, finish: {
                let splistViewController = UIStoryboard.shareStoryBoard.get_UISplitViewController()
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = splistViewController
            })
        }
    }
}
