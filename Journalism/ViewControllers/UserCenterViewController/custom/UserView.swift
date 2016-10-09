//
//  UserView.swift
//  Journalism
//
//  Created by Mister on 16/6/16.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import PINRemoteImage

///圆形图片
class HeadPhotoView:UIImageView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).CGColor
        self.layer.borderWidth = 1
        
        self.clipsToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HeadPhotoView.setHeadphoto), name: USERLOGINCHANGENOTIFITION, object: nil)
        
        self.setHeadphoto()
    }
    
    func setHeadphoto(){
        
        if ShareLUser.avatar.characters.count <= 0 {
        
            self.layer.borderWidth = 0
            
            return self.image = UIImage(named: "home-个人头像")
        }
        
        if let url = NSURL(string: ShareLUser.avatar) {
            
            self.layer.borderWidth = 1
            
            self.pin_setImageFromURL(url)
        }
    }
}


///圆形图片
class HeadPhotoView1:UIImageView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).CGColor
        self.layer.borderWidth = 0
        
        self.clipsToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HeadPhotoView.setHeadphoto), name: USERLOGINCHANGENOTIFITION, object: nil)
        
        self.setHeadphoto()
    }
    
    func setHeadphoto(){
        
        if ShareLUser.avatar.characters.count <= 0 {
            
            return self.image = UIImage(named: "home_login")
        }
        
        if let url = NSURL(string: ShareLUser.avatar) {
            
            self.pin_setImageFromURL(url)
        }
    }
}

///圆形图片
class UserNameLabel:UILabel{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserNameLabel.setUserName), name: USERLOGINCHANGENOTIFITION, object: nil)
        self.setUserName()
    }
    
    func setUserName(){
        
        self.text = ShareLUser.uname
    }
}
