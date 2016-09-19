//
//  UserCenterExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/15.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import AFDateHelper
import SwaggerClient

@objc protocol UserLoginManagerDelegate:NSObjectProtocol{
    
    @objc optional func didReceiveWeiboRequest(_ request: AnyObject!)
    @objc optional func didReceiveWeiboResponse(_ response: AnyObject!)
    
    @objc optional func willRequestAuthorize() // 接收到授权失败的消息
    
    @objc optional func didReceiveFailResponse(_ message: String) // 接收到授权失败的消息
    @objc optional func willRequestUserInfo() // 开始准备请求用户信息
    
    @objc optional func didReceiveRequestUserFailResponse() // 请求用户信息失败
    @objc optional func didReceiveRequestUserSuccessResponse(_ userR:AnyObject!) // 请求用户信息失败
}

extension UserLoginSdkApiManager{

    class func SinaLogin(_ del:UserLoginManagerDelegate){
    
        UserLoginSdkApiManager.shareWXApiManager().delegate = del
        let request = WBAuthorizeRequest()
        request.redirectURI = SINA_REDIRECTURI
        request.scope = "all"
        WeiboSDK.send(request)
        
        del.willRequestAuthorize?()
        
    }
    
    class func WeChatLogin(_ vc:UIViewController,del:UserLoginManagerDelegate){
    
        UserLoginSdkApiManager.shareWXApiManager().delegate = del
        
        /// 获取友盟微博
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatform(withName: UMShareToWechatSession)
        
        del.willRequestAuthorize?()
        snsPlatform?.loginClickHandler(vc, UMSocialControllerService.default(), true, {response in
            del.didReceiveWeiboResponse?(response) // 向用户告知，接收到了微信的回调
            
            switch response!.responseCode {
                
            case UMSResponseCodeSuccess:
                
                self.getWeChatUserInfo(response!)
            case UMSResponseCodeCancel:
                del.didReceiveFailResponse?("请确认授权")
            default:
                del.didReceiveFailResponse?("未知错误")
            }
        })
    }
}


/// 模态的新浪微博管理对象
class UserLoginSdkApiManager:NSObject,WeiboSDKDelegate{

    weak var delegate: UserLoginManagerDelegate?
    
    ///单例模式下获取主人
    static func shareWXApiManager()->UserLoginSdkApiManager{
        
        return UserLoginSdkApiManager()
    }
    
    // 接收到来自微博的请求
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
        delegate?.didReceiveWeiboRequest?(request)
    }
    
    // 接收到来自微博的回复
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        delegate?.didReceiveWeiboResponse?(response) // 向用户告知，接收到了微博的回调
        switch response.statusCode {
        case .success:
            guard let asstoken = response.userInfo["access_token"] as? String,let uid = response.userInfo["uid"] as? String,let expires_in = response.userInfo["expires_in"] as? String else{fallthrough}
            delegate?.willRequestUserInfo?() // 向用户告知，将要请求用户信息
            
            let sexpires = Date().dateByAddingSeconds(NSString(string:expires_in).integerValue).toString(DateFormat.custom("yyyy-MM-dd hh:mm:ss"))
            
            self.getSinaUserInfo(asstoken, uid: uid,sexpires:sexpires)
        case .userCancel:
            delegate?.didReceiveFailResponse?("请确认授权")
        default:
            delegate?.didReceiveFailResponse?("未知错误")
        }
    }
}

import Alamofire
import AFDateHelper

extension UserLoginSdkApiManager{

    
    fileprivate class func getWeChatUserInfo(_ respones:UMSocialResponseEntity){
    
        guard let wxsession = respones.data["wxsession"] as? [String:Any],let accessToken = wxsession["accessToken"] as? String ,let username = wxsession["username"] as? String ,let usid = wxsession["usid"] as? String else{
            
            UserLoginSdkApiManager.shareWXApiManager().delegate?.didReceiveRequestUserFailResponse?()
            
            return
        }
        
        guard let profile = respones.thirdPlatformUserProfile as? [String:Any],let avatar = profile["headimgurl"] as? String,let genders = profile["sex"] as? Int else{
        
            UserLoginSdkApiManager.shareWXApiManager().delegate?.didReceiveRequestUserFailResponse?()
            
            return
        }
        
        ShareLUser.uname = username
        ShareLUser.avatar = avatar
        
        /// 设置存储
        ShareLUser.s_uid = usid
        ShareLUser.s_token = accessToken
        ShareLUser.s_sexpires = Date().dateByAddingDays(7).toString(DateFormat.custom("yyyy-MM-dd hh:mm:ss"))
        ShareLUser.s_uname = username
        ShareLUser.s_avatar = avatar
        ShareLUser.s_gender = genders == 0 ? 3 : (genders == 2 ? 0 : 1)

        ShareLUser.getSdkUserToken { (user) in
            UserLoginSdkApiManager.shareWXApiManager().delegate?.didReceiveRequestUserSuccessResponse?(UserRegister(utype: 3))
        }
    }
    
    ///  获取新浪微博的用户信息
    fileprivate func getSinaUserInfo(_ access_token:String,uid:String,sexpires:String){
        let param:[String : AnyObject] = ["access_token":access_token as AnyObject,"uid":uid as AnyObject]
        Alamofire.request( "https://api.weibo.com/2/users/show.json",method:.get, parameters: param).responseJSON { (respense) -> Void in
            if respense.result.isFailure {
                self.delegate?.didReceiveRequestUserFailResponse?()
                return
            }
            guard let result = respense.result.value as? NSDictionary ,let uname = result["name"] as? String,let avatar = result["avatar_hd"] as? String,let genders = result["gender"] as? String else{
                self.delegate?.didReceiveRequestUserFailResponse?()
                return
            }
            
            ShareLUser.uname = uname
            ShareLUser.avatar = avatar
            
            /// 设置存储
            ShareLUser.s_uid = uid
            ShareLUser.s_token = access_token
            ShareLUser.s_sexpires = sexpires
            ShareLUser.s_uname = uname
            ShareLUser.s_avatar = avatar
            ShareLUser.s_gender = genders == "m" ? 1 :(genders == "f" ? 0 : 3)
            
            ShareLUser.getSdkUserToken { (user) in
                self.delegate?.didReceiveRequestUserSuccessResponse?(UserRegister(utype: 3))
            }
        }
    }
}
