//
//  User.swift
//  Journalism
//
//  Created by Mister on 16/5/27.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SwaggerClient

class SDK_User:NSObject{
    
    class var token:String?{
    
     return NSUserDefaults.standardUserDefaults().stringForKey(SDK_SHANGHAIUSERTOKEN)
    }
    
    class var uid:Int?{
        
        return NSUserDefaults.standardUserDefaults().integerForKey(SDK_SHANGHAIUSERUID)
    }
    // 获得用户的Token
    class func getSdkUserToken(finish:((token:String)->Void)?){
        
        guard let token = NSUserDefaults.standardUserDefaults().stringForKey(SDK_SHANGHAIUSERTOKEN) else{
            
            return SDK_UserRequest.getUserTokenByRequest({ (token) in
                
                finish?(token: token)
            })
        }
        finish?(token: token)
    }
}


public class SDK_UserRequest: NSObject {
    
    /// 向服务器注册一个游客 并且将游客的验证信息 填入到 应用 NSUserDefaults 中，key 为 SDK_SHANGHAIUSERTOKEN 的值
    public class func getUserTokenByRequest(finish:((token:String)->Void),fail:(()->Void)?=nil){
        
        let requestBuder = UserAPI.auSinGPostWithRequestBuilder(userRegisterInfo: VisitorsRegister(utype: 2, platform: 1))
        
        requestBuder.execute { (response, error) in
            
            guard let token =  response?.header["Authorization"] else{
                fail?()
                return
            }
            
            if let data = response?.body,uid = data.objectForKey("data")?.objectForKey("uid") as? Int {
                
                NSUserDefaults.standardUserDefaults().setObject(uid, forKey: SDK_SHANGHAIUSERUID)
            }
            
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: SDK_SHANGHAIUSERTOKEN)
            finish(token: token)
        }
    }
}


extension VisitorsRegister{
    
    convenience public init(utype: Int32,platform: Int32){
        self.init()
        self.utype = utype
        self.platform = platform
    }
}
