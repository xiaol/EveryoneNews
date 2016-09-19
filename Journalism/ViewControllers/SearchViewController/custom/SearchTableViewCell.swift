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
    case hot
    case history
}


class SearchHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! // 标题 label 控件
    @IBOutlet var clearButton: UIButton! // 不喜欢 button 控件
    
    fileprivate var style:HeaderStyle!
    
    func setHeader(_ style:HeaderStyle) {
        
        self.style = style
        
        switch style {
        case .hot:
            self.titleLabel.text = "热门搜索"
            self.clearButton.isHidden = true
        case .history:
            self.titleLabel.text = "历史搜索"
            self.clearButton.isHidden = false
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 240/255, green:240/255, blue: 240/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 0, y: rect.height, width: rect.width, height: 1));
        
        if self.style == .history {
        
            context?.setStrokeColor(UIColor(red: 240/255, green:240/255, blue: 240/255, alpha: 1).cgColor)
            context?.stroke(CGRect(x: 0, y: 0, width: rect.width, height: 0.3));
        }
    }
}

/// 搜索视图的历史搜索表格行
class SearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! // 标题 label 控件

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 240/255, green:240/255, blue: 240/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 0, y: rect.height, width: rect.width, height: 1));
    }
}


/// 搜索视图的热门搜索表格行
class SearchHotTableViewCell: UITableViewCell {
    
    @IBOutlet var tagView: SKTagView! // 热门显示控件
}
