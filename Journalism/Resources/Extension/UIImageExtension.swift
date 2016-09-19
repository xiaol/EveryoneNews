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
    static var sharePlaceholderImage:UIImage!{
        
        return imageWithColor(UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1), size: CGSize(width: 800, height: 800))
    }
    
    
    class func imageWithColor(_ color:UIColor,size:CGSize) -> UIImage{
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}


extension UIImage{
    
    
    class func makeTextImage(_ text:String) -> UIImage{
    
        let image = self.imageWithColor(UIColor.a_color9, size: CGSize(width: 80, height: 80))
        
        return image.waterMarkedImage(text,waterMarkTextColor:UIColor.white)
    }
    
    
    //水印位置枚举
    enum WaterMarkCorner{
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    //添加水印方法
    func waterMarkedImage(_ waterMarkText:String, corner:WaterMarkCorner = .bottomRight,
                          margin:CGPoint = CGPoint(x: 20, y: 20), waterMarkTextColor:UIColor = UIColor.white,
                          waterMarkTextFont:UIFont = UIFont.systemFont(ofSize: 20),
                          backgroundColor:UIColor = UIColor.clear) -> UIImage{
        
        let textAttributes = [NSForegroundColorAttributeName:waterMarkTextColor,
                              NSFontAttributeName:waterMarkTextFont]
        let textSize = NSString(string: waterMarkText).size(attributes: textAttributes)
        var textFrame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .topLeft:
            textFrame.origin = margin
        case .topRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .bottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .bottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                                       y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        NSString(string: waterMarkText).draw(in: textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return waterMarkedImage!
    }
}
