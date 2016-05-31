//
//  DetailViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import MGTemplateEngine
import WebViewJavascriptBridge

class DetailViewController: UIViewController {
    
    var new:New? // 当前要展示的新闻对象
    var engine:MGTemplateEngine! // 当前Html解析器，生成
    var bridge:WebViewJavascriptBridge! // JS 交互侨联
    
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.delegate = self
        webView.hidden = true
        webView.scrollView.scrollEnabled = false
        webView.scrollView.scrollsToTop = false
        webView.scrollView.bounces = false
        
        engine = MGTemplateEngine()
        engine.matcher = ICUTemplateMatcher(templateEngine: engine)
        
        webView.dataDetectorTypes = UIDataDetectorTypes.All
        
        self.loadContentObjects()
        
        tableView.tableHeaderView = self.webView
        
        self.setWebViewJavascriptBridge()
    }
}


extension DetailViewController:UITableViewDelegate,UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("likeandpyq")! as UITableViewCell
            
            return cell
        }else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("comments")! as UITableViewCell
            
            return cell
        }else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("morecell")! as UITableViewCell
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("likeandpyq")! as UITableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
        
            return 106
        }else if indexPath.row == 1 {
            
            return 116
        }else if indexPath.row == 2 {
            
            return 101
        }
        
        return 106
    }
}