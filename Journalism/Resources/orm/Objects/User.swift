//
//  User.swift
//  Journalism
//
//  Created by Mister on 16/5/27.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SwaggerClient

class ShareUser:NSObject{
    
    var token:String!
    var password:String!
    var uid:Int!
    var utype:Int!
    
    init(token:String,password:String,uid:Int,utype:Int){
        
        self.token = token
        self.password = password
        self.uid = uid
        self.utype = utype
    }
    
    // 用户Token
    class var token:String?{
    
     return NSUserDefaults.standardUserDefaults().stringForKey(USER_TOKEN)
    }
    
    // 用户密码
    class var password:String?{
        
        return NSUserDefaults.standardUserDefaults().stringForKey(USER_PASSWORD)
    }
    
    // 用户ID
    class var uid:Int?{
        
        return NSUserDefaults.standardUserDefaults().integerForKey(USER_UID)
    }
    
    // 用户类型 1本地注册用户	2 游客用户 3 微博三方用户 4 微信三方用户
    class var utype:Int?{
        
        return NSUserDefaults.standardUserDefaults().integerForKey(USER_TYPE)
    }
    
    // 用户名称
    class var uname:String?{
        
        return NSUserDefaults.standardUserDefaults().stringForKey(USER_NAME)
    }
    
    // 用户头像链接
    class var uavatar:String?{
        
        return NSUserDefaults.standardUserDefaults().stringForKey(USER_AVATAR)
    }
    
    // 获得用户的Token
    class func getSdkUserToken(finish:((user:ShareUser)->Void)?){
        
        let token = NSUserDefaults.standardUserDefaults().stringForKey(USER_TOKEN)
        let password = NSUserDefaults.standardUserDefaults().stringForKey(USER_PASSWORD)
        let uid = NSUserDefaults.standardUserDefaults().integerForKey(USER_UID)
        let utype = NSUserDefaults.standardUserDefaults().integerForKey(USER_TYPE)
        
        guard let t = token,p = password else{
            
            return SDK_UserRequest.getUserTokenByRequest({ (user) in
                
                finish?(user: user)
            })
        }
        
        let user = ShareUser(token: t, password: p, uid: uid, utype: utype)
        
        finish?(user: user)
    }
}


class SDK_UserRequest: NSObject {
    
    /// 向服务器注册一个游客 并且将游客的验证信息 填入到 应用 NSUserDefaults 中，key 为 SDK_SHANGHAIUSERTOKEN 的值
    class func getUserTokenByRequest(finish:((user:ShareUser)->Void),fail:(()->Void)?=nil){
        
        let requestBuder = UserAPI.auSinGPostWithRequestBuilder(userRegisterInfo: VisitorsRegister(utype: 2, platform: 1))
        
        requestBuder.execute { (response, error) in
            
            guard let token =  response?.header["Authorization"],let data = response?.body.objectForKey("data"),uid = data.objectForKey("uid") as? Int,utype = data.objectForKey("utype") as? Int,password = data.objectForKey("password") as? String else{
                fail?()
                return
            }
            
            NSUserDefaults.standardUserDefaults().setObject(uid, forKey: USER_UID) 
            NSUserDefaults.standardUserDefaults().setObject(utype, forKey: USER_TYPE)
            NSUserDefaults.standardUserDefaults().setObject(password, forKey: USER_PASSWORD)
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: USER_TOKEN)
            
            
            let user = ShareUser(token: token, password: password, uid: uid, utype: utype)
            
            finish(user: user)
        }
    }
    
    // 注册第三方用户
    class func resigterSanFangUser(user:UserRegister,finish:((user:ShareUser)->Void),fail:(()->Void)?=nil){
    
        let requestBuder = UserAPI.auSinSPostWithRequestBuilder(userRegisterInfo: user)
        
        requestBuder.addHeader(name: "Content-Type", value: "application/json")
        
        requestBuder.execute { (response, error) in
            
            guard let token =  response?.header["Authorization"],let data = response?.body.objectForKey("data"),uid = data.objectForKey("uid") as? Int,utype = data.objectForKey("utype") as? Int else{
                fail?()
                return
            }
            
            if let value = response?.body.objectForKey("uname") {
                NSUserDefaults.standardUserDefaults().setObject(value, forKey: USER_NAME)
            }
            
            if let value = response?.body.objectForKey("avatar") {
                NSUserDefaults.standardUserDefaults().setObject(value, forKey: USER_AVATAR)
            }
            
            NSUserDefaults.standardUserDefaults().setObject(uid, forKey: USER_UID)
            NSUserDefaults.standardUserDefaults().setObject(utype, forKey: USER_TYPE)
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: USER_TOKEN)
            
            
            let user = ShareUser(token: token, password: "", uid: uid, utype: utype)
            
            finish(user: user)
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



extension UserRegister{
    
    convenience public init(muid: Int32,utype: Int32 = 1,platform:Int32=1,suid:String,stoken:String,sexpires:String,uname:String,avatar:String,gender:Int32){
        self.init()
        self.muid = muid
        self.utype = utype
        self.platform = platform
        self.suid = suid
        self.stoken = stoken
        self.sexpires = sexpires
        self.uname = uname
        self.avatar = avatar
        self.gender = gender
    }
}
