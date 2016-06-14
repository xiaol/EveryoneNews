//
//  UIColorExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/14.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension UIColor{

    /// 频道字颜色
    class var a_color1:UIColor{  return UIColor.hexStringToColor("#333333")}
    /// 产品主颜色
    class var a_color2:UIColor{  return UIColor.hexStringToColor("#0091fa")}
    /// 新闻标题颜色
    class var a_color3:UIColor{  return UIColor.hexStringToColor("#1a1a1a")}
    /// 频新闻来源颜色
    class var a_color4:UIColor{  return UIColor.hexStringToColor("#999999")}
    /// 分割线颜色
    class var a_color5:UIColor{  return UIColor.hexStringToColor("#e4e4e4")}
    /// 置顶颜色
    class var a_color6:UIColor{  return UIColor.hexStringToColor("#bb1c1c")}
    /// 提示颜色
    class var a_color7:UIColor{  return UIColor.hexStringToColor("#666666")}
    /// 加载条颜色
    class var a_color8:UIColor{  return UIColor.hexStringToColor("#d9effe")}
    /// 背景颜色
    class var a_color9:UIColor{  return UIColor.hexStringToColor("#f6f6f6")}
    /// 分割线颜色
    class var a_color10:UIColor{  return UIColor.hexStringToColor("#c0c0c0")}
    
    /// 评论按钮背景颜色
    class var a_color11:UIColor{  return UIColor.hexStringToColor("#eaeaea")}
}




extension UIColor{
    public class func hexStringToColor(hexString: String) -> UIColor{
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if cString.characters.count < 6 {return UIColor.blackColor()}
        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
        if cString.characters.count != 6 {return UIColor.blackColor()}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substringWithRange(range)
        range.location = 2
        let gString = (cString as NSString).substringWithRange(range)
        range.location = 4
        let bString = (cString as NSString).substringWithRange(range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        NSScanner.init(string: rString).scanHexInt(&r)
        NSScanner.init(string: gString).scanHexInt(&g)
        NSScanner.init(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
}