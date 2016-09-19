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
    
    override var shouldAutorotate : Bool {
        
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
    
    // 返回上一个视图
    @IBAction func dismissViewControllerAction(_ sender: AnyObject){
    
        self.dismiss(animated: true, completion: nil)
    }
    
    // 新浪登陆按钮点击事件
    @IBAction func SinaLoginButtonAction(_ sender: AnyObject) {
        
        UserLoginSdkApiManager.SinaLogin(self)
    }
    
    @IBAction func WeChatLoginButtonAction(_ sender: AnyObject) {
        
        UserLoginSdkApiManager.WeChatLogin(self, del: self)
    }
    
    func willRequestAuthorize() {
        
        SVProgressHUD.show()
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
    }
    
    func didReceiveFailResponse(_ message: String) {
        
        SVProgressHUD.showError(withStatus: message)
        
        SVProgressHUD.dismiss(withDelay: 1.5)
    }
    
    func willRequestUserInfo() {
        
        SVProgressHUD.showInfo(withStatus: "请求用户信息中")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
    }
    
    func didReceiveRequestUserFailResponse() {
        
        SVProgressHUD.showError(withStatus: "请求用户信息失败")
        
        SVProgressHUD.dismiss(withDelay: 1.5)
    }
    
    // 接收到用户信息成功获取的通知
    func didReceiveRequestUserSuccessResponse(_ userR: AnyObject!) {
        
        SVProgressHUD.show(withStatus: "完成授权 ")
        SVProgressHUD.dismiss(withDelay: 1.5)
        
        if let user = userR as? UserRegister{
     
            ShareLUserRequest.resigterSanFangUser(user, finish: { 
                
                self.dismiss(animated: true, completion: nil)
                
                }, fail: { 
                    
                    SVProgressHUD.showError(withStatus: "注册失败")
                    SVProgressHUD.dismiss(withDelay: 1.5)
            })
        }
    }
}
