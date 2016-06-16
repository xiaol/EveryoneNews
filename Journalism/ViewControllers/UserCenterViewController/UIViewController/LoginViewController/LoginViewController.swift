//
//  LoginViewController.swift
//  Journalism
//
//  Created by Mister on 16/6/15.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwaggerClient

class LoginViewController: UIViewController,UserLoginManagerDelegate {
    
    // 返回上一个视图
    @IBAction func dismissViewControllerAction(sender: AnyObject){
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 新浪登陆按钮点击事件
    @IBAction func SinaLoginButtonAction(sender: AnyObject) {
        
        UserLoginSdkApiManager.SinaLogin(self)
    }
    
    @IBAction func WeChatLoginButtonAction(sender: AnyObject) {
        
        UserLoginSdkApiManager.WeChatLogin(self, del: self)
    }
    
    func willRequestAuthorize() {
        
        SVProgressHUD.show()
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Clear)
    }
    
    func didReceiveFailResponse(message: String) {
        
        SVProgressHUD.showErrorWithStatus(message)
        
        SVProgressHUD.dismissWithDelay(1.5)
    }
    
    func willRequestUserInfo() {
        
        SVProgressHUD.showInfoWithStatus("请求用户信息中")
    }
    
    func didReceiveRequestUserFailResponse() {
        
        SVProgressHUD.showErrorWithStatus("请求用户信息失败")
        
        SVProgressHUD.dismissWithDelay(1.5)
    }
    
    // 接收到用户信息成功获取的通知
    func didReceiveRequestUserSuccessResponse(userR: AnyObject!) {
        
        SVProgressHUD.showSuccessWithStatus("完成")
        SVProgressHUD.dismissWithDelay(1.5)
        
        if let user = userR as? UserRegister{
     
            ShareLUserRequest.resigterSanFangUser(user, finish: {
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
}
