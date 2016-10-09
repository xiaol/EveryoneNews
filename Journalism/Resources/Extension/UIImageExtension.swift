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
                
                backTaskLeton.bgTask = imageWithColor(UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1), size: CGSize(width: 800, height: 800))
            })
            
            return backTaskLeton.bgTask
        }
    }
    
    
    class func imageWithColor(color:UIColor,size:CGSize) -> UIImage{
        let rect = CGRect(origin: CGPointZero, size: size)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}


extension UIImage{
    
    
    class func makeTextImage(text:String) -> UIImage{
    
        let image = self.imageWithColor(UIColor.a_color9, size: CGSize(width: 80, height: 80))
        
        return image.waterMarkedImage(text,waterMarkTextColor:UIColor.whiteColor())
    }
    
    
    //水印位置枚举
    enum WaterMarkCorner{
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    
    //添加水印方法
    func waterMarkedImage(waterMarkText:String, corner:WaterMarkCorner = .BottomRight,
                          margin:CGPoint = CGPoint(x: 20, y: 20), waterMarkTextColor:UIColor = UIColor.whiteColor(),
                          waterMarkTextFont:UIFont = UIFont.systemFontOfSize(20),
                          backgroundColor:UIColor = UIColor.clearColor()) -> UIImage{
        
        let textAttributes = [NSForegroundColorAttributeName:waterMarkTextColor,
                              NSFontAttributeName:waterMarkTextFont]
        let textSize = NSString(string: waterMarkText).sizeWithAttributes(textAttributes)
        var textFrame = CGRectMake(0, 0, textSize.width, textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
            textFrame.origin = margin
        case .TopRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .BottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                                       y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        NSString(string: waterMarkText).drawInRect(textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return waterMarkedImage!
    }
}
