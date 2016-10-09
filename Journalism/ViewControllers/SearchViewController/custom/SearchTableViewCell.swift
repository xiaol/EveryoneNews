//
//  CustomTableViewCell.swift
//  Journalism
//
//  Created by Mister on 16/6/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

/**
 表格的类型
 
 - Hot:     热点搜索类型
 - History: 历史搜索类型
 */
enum HeaderStyle{
    case Hot
    case History
}


class SearchHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! // 标题 label 控件
    @IBOutlet var clearButton: UIButton! // 不喜欢 button 控件
    
    private var style:HeaderStyle!
    
    func setHeader(style:HeaderStyle) {
        
        self.style = style
        
        switch style {
        case .Hot:
            self.titleLabel.text = "热门搜索"
            self.clearButton.hidden = true
        case .History:
            self.titleLabel.text = "历史搜索"
            self.clearButton.hidden = false
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()! // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(red: 240/255, green:240/255, blue: 240/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(0, rect.height, rect.width, 1));
        
        if self.style == .History {
        
            CGContextSetStrokeColorWithColor(context, UIColor(red: 240/255, green:240/255, blue: 240/255, alpha: 1).CGColor)
            CGContextStrokeRect(context, CGRectMake(0, 0, rect.width, 0.3));
        }
    }
}

/// 搜索视图的历史搜索表格行
class SearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! // 标题 label 控件

    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()! // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(red: 240/255, green:240/255, blue: 240/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(0, rect.height, rect.width, 1));
    }
}


/// 搜索视图的热门搜索表格行
class SearchHotTableViewCell: UITableViewCell {
    
    @IBOutlet var tagView: SKTagView! // 热门显示控件
}
