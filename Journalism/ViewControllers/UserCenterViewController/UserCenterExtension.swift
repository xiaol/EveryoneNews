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
    
    optional func didReceiveWeiboRequest(request: AnyObject!)
    optional func didReceiveWeiboResponse(response: AnyObject!)
    
    optional func willRequestAuthorize() // 接收到授权失败的消息
    
    optional func didReceiveFailResponse(message: String) // 接收到授权失败的消息
    optional func willRequestUserInfo() // 开始准备请求用户信息
    
    optional func didReceiveRequestUserFailResponse() // 请求用户信息失败
    optional func didReceiveRequestUserSuccessResponse(userR:AnyObject!) // 请求用户信息失败
}

extension UserLoginSdkApiManager{

    class func SinaLogin(del:UserLoginManagerDelegate){
    
        UserLoginSdkApiManager.shareWXApiManager().delegate = del
        let request = WBAuthorizeRequest()
        request.redirectURI = SINA_REDIRECTURI
        request.scope = "all"
        WeiboSDK.sendRequest(request)
        
        del.willRequestAuthorize?()
        
    }
    
    class func WeChatLogin(vc:UIViewController,del:UserLoginManagerDelegate){
    
        UserLoginSdkApiManager.shareWXApiManager().delegate = del
        
        /// 获取友盟微博
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
        
        del.willRequestAuthorize?()
        
        snsPlatform.loginClickHandler(vc, UMSocialControllerService.defaultControllerService(), true, {response in
            del.didReceiveWeiboResponse?(response) // 向用户告知，接收到了微信的回调
            switch response.responseCode {
            case UMSResponseCodeSuccess:
                del.willRequestUserInfo?() // 向用户告知，将要请求用户信息
                
                UMSocialDataService.defaultDataService().requestSnsInformation(UMShareToWechatSession, completion: { (responses) -> Void in
                    
                    if responses.responseCode != UMSResponseCodeSuccess{ del.didReceiveRequestUserFailResponse?();return}
                    
                  
                    print(response.data)
                    
                })
            case UMSResponseCodeCancel:
                del.didReceiveFailResponse?("请确认授权")
            default:
                del.didReceiveFailResponse?("未知错误")
            }
            if response.responseCode == UMSResponseCodeSuccess {
                
                UMSocialDataService.defaultDataService().requestSnsInformation(UMShareToWechatSession, completion: { (entity) -> Void in
                    
                    
                    
                    
                })
                
            }else if response.responseCode != UMSResponseCodeCancel{
                
            }
        })
    }
}


/// 模态的新浪微博管理对象
class UserLoginSdkApiManager:NSObject,WeiboSDKDelegate{

    weak var delegate: UserLoginManagerDelegate?
    
    ///单例模式下获取主人
    class func shareWXApiManager()->UserLoginSdkApiManager{
        
        struct YRSingleton{
            
            static var predicate:dispatch_once_t = 0
            
            static var meet:UserLoginSdkApiManager? = nil
        }
        
        dispatch_once(&YRSingleton.predicate,{
            
            YRSingleton.meet = UserLoginSdkApiManager()
        })
        
        return YRSingleton.meet!
    }
    
    // 接收到来自微博的请求
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
        delegate?.didReceiveWeiboRequest?(request)
    }
    
    // 接收到来自微博的回复
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        delegate?.didReceiveWeiboResponse?(response) // 向用户告知，接收到了微博的回调
        switch response.statusCode {
        case .Success:
            guard let asstoken = response.userInfo["access_token"] as? String,uid = response.userInfo["uid"] as? String,expires_in = response.userInfo["expires_in"] as? String else{fallthrough}
            delegate?.willRequestUserInfo?() // 向用户告知，将要请求用户信息
            
            let sexpires = NSDate().dateByAddingSeconds(NSString(string:expires_in).integerValue).toString(format: DateFormat.Custom("yyyy-MM-dd hh:mm:ss"))
            
            self.getSinaUserInfo(asstoken, uid: uid,sexpires:sexpires)
        case .UserCancel:
            delegate?.didReceiveFailResponse?("请确认授权")
        default:
            delegate?.didReceiveFailResponse?("未知错误")
        }
    }
}

import Alamofire

extension UserLoginSdkApiManager{

    ///  获取新浪微博的用户信息
    private func getSinaUserInfo(access_token:String,uid:String,sexpires:String){
        

        let param:[String : AnyObject] = ["access_token":access_token,"uid":uid]

        Alamofire.request(.GET, "https://api.weibo.com/2/users/show.json", parameters: param).responseJSON { (respense) -> Void in
            
            if respense.result.isFailure {
                self.delegate?.didReceiveRequestUserFailResponse?()
                return
            }
            
            guard let result = respense.result.value as? NSDictionary ,uname = result["name"] as? String,avatar = result["avatar_hd"] as? String,genders = result["gender"] as? String else{
                self.delegate?.didReceiveRequestUserFailResponse?()
                return
            }
            
            ShareUser.getSdkUserToken { (user) in
                
                let gender:Int32 = genders == "m" ? 1 :(genders == "f" ? 0 : 3)
                let userR = UserRegister(muid: Int32(user.uid), utype: 3, platform: 1, suid: uid, stoken: access_token, sexpires: sexpires, uname: uname, avatar: avatar, gender: gender)
                self.delegate?.didReceiveRequestUserSuccessResponse?(userR)
            }
        }
    }
}




