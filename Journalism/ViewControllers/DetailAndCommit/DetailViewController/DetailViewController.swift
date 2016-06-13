//
//  DetailViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import MJRefresh
import RealmSwift
import MGTemplateEngine
import WebViewJavascriptBridge

class DetailViewController: UIViewController,WaitLoadProtcol {
    
    var new:New? // 当前要展示的新闻对象
    var currentPage = 0 // 当前页数
    var engine:MGTemplateEngine! // 当前Html解析器，生成
    var bridge:WebViewJavascriptBridge! // JS 交互侨联
    
    let realm = try! Realm()
    
    var hotResults:Results<Comment>!
    var aboutResults:Results<About>!
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.showWaitLoadView()
        
        if let new = new {
            
            aboutResults = realm.objects(About.self).filter("nid = \(new.nid)").sorted("ptimes", ascending: false)
            hotResults = realm.objects(Comment.self).filter("nid = \(new.nid) AND ishot = 1").sorted("commend", ascending: false)
            
            CommentUtil.LoadHotsCommentsList(new, finish: {
                
                self.tableView.reloadData()
                
                }, fail: {
                    
            })
            
            AboutUtil.getAboutListArrayData(new, finish: { (count) in
                
                self.tableView.reloadData()
                
                }, fail: { 
                    
            })
        }
        
        
        self.tableView.sectionFooterHeight = 0
        
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (_) in
            
            self.webViewDidFinishLoad(self.webView)
            
            }, completion: nil)
        
    }
    
}


