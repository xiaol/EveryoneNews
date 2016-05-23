//
//  UIImageExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/23.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit



extension UIImage{

    
    /// 获取单例模式下的UIStoryBoard对象
    class var sharePlaceholderImage:UIImage!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:UIImage? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = imageWithColor(UIColor.lightGrayColor(), size: CGSize(width: 800, height: 800))
            })
            
            return backTaskLeton.bgTask
        }
    }
    
    
    private class func imageWithColor(color:UIColor,size:CGSize) -> UIImage{
        let rect = CGRect(origin: CGPointZero, size: size)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}