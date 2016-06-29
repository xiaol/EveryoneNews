//
//  DetailViewControllerWebViewExtenion.swift
//  Journalism
//
//  Created by Mister on 16/5/31.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import WebKit

extension DetailViewController:WKNavigationDelegate{

    /**
     主要是为了针对于党图片延时加载之后的webvView高度问题
     
     - parameter scrollView: 滑动视图
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        self.adaptionWebViewHeightMethod()
    }
    
    /**
     当滑动视图停止，记录滑动到达的位置 用来记录用户的赏赐查看位置
     
     - parameter scrollView: 滑动视图
     */
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        
//        new?.getNewContentObject()?.scroffY(scrollView.contentOffset.y)
//    }
    
    /**
     整合方法
     完成webview的初始化 
     完成新闻详情页面的加载方法
     监听字体变化的方法
     */
    func integrationMethod(){
    
        self.initWebViewInit()
        
        self.loadContentObjects()
        
        // 获得字体变化通知，完成刷新字体大小方法
        NSNotificationCenter.defaultCenter().addObserverForName(FONTMODALSTYLEIDENTIFITER, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            
            self.tableView.reloadData()
            
            let jsStr = "document.getElementById('body_section').style.fontSize=\(UIFont.a_font3.pointSize);document.getElementById('subtitle').style.fontSize=\(UIFont.a_font8.pointSize);document.getElementById('title').style.fontSize=\(UIFont.a_font9.pointSize);"
            
            self.webView.evaluateJavaScript(jsStr, completionHandler: { (body, error) in
                
                self.adaptionWebViewHeightMethod()
            })
        }
    }
    
    
    /**
      初始化 WKWebView
     设置webview可以使用javascript
     设置webview播放视频时可以使用html5 自带的播放器，播放
     设置webview的JSBridge对象
     
     - returns: null
     */
    func initWebViewInit(){
    
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addScriptMessageHandler(self, name: "JSBridge")
//        configuration.allowsInlineMediaPlayback = true        
        self.webView = WKWebView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 600, height: 1000)), configuration: configuration)
        self.webView.hidden = true
        self.webView.navigationDelegate = self
        self.webView.scrollView.scrollEnabled = false
        self.webView.scrollView.scrollsToTop = false
        self.webView.scrollView.bounces = false
        self.tableView.tableHeaderView = self.webView
        self.showWaitLoadView()
        
        self.tableView.sectionFooterHeight = 0
    }
    
    /**
     读取新闻详情对象
     经过改版后。原方法在数据库中直接获取详情的代码已经被删除。
     主要是为了针对新闻发生品论或者新欢收藏后，完成新闻内容的及时刷新
     */
    func loadContentObjects(){
        
        if let n = new {
            
            NewContentUtil.LoadNewsContentData(n.nid, finish: { (newCon) in
                
                self.ShowNewCOntentInWebView(newCon)
                }, fail: { 
                    
                    self.waitView.setNoNetWork {
                        
                        self.loadContentObjects()
                    }
            })
        }
    }

    /**
     根据用户提供的新闻详情，进行网页上新闻详情的展示
     在这例用户可以提供一个不存在的新闻详情，这个主要是为了针对当用户刚进入页面或者没有网络的时候进行数据加载的情况
     
     - parameter newContent: 新闻详情 NewContent 类型
     */
    func ShowNewCOntentInWebView(newContent:NewContent?=nil){
    
        if let newCon = newContent {
        
            self.webView.loadHTMLString(newCon.getHtmlResourcesString(), baseURL: NSBundle.mainBundle().bundleURL)
        }
    }
    
    /**
     当调用到这个方法的时候，WkWebView将会调用Javascript的方法，来以此获取新闻展示页面所需要的高度
     获取高度完成之后就进行页面的重新布局以加入到tableView的表头中作为一个详情展示页
     */
    func adaptionWebViewHeightMethod(height:CGFloat = -1){
        
//        if height > 0 {
//        
//            self.webView.frame.size.height = height
//            self.tableView.tableHeaderView = self.webView
//            
//            return
//        }
        
        self.webView.evaluateJavaScript("document.getElementById('section').offsetHeight") { (data, _) in
            
            if let height = data as? CGFloat{
                
                if self.webView.frame.size.height != height+35 {
                
                    self.webView.layoutIfNeeded()
                    self.webView.frame.size.height = height+35
//                    self.new?.getNewContentObject()?.heights(height+35)
                    self.tableView.tableHeaderView = self.webView
                }
            }
        }
    }
    
    /**
     当webview全部加载完成之后
     
     完成之后，设置webview的高度。让其适配于页面
     之后显示webview并且将正在加载的等待视图进行隐藏
     
     - parameter webView:    webview
     - parameter navigation: 什么玩意？
     */
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        self.adaptionWebViewHeightMethod()
//        if let off = new?.getNewContentObject()?.scroffY,height = new?.getNewContentObject()?.height {
//            
//            self.adaptionWebViewHeightMethod(CGFloat(height))
//            self.tableView.setContentOffset(CGPoint(x: 0, y: CGFloat(off)), animated: false)
//        }
        self.webView.hidden = false
        self.hiddenWaitLoadView() // 隐藏加载视图
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        
        self.waitView.setNoNetWork {
            
            self.loadContentObjects()
        }
    }
    
    /**
     当webview中发生了一些链接的变化 将会调用该方法
     该方法主要针对于用户点击了页面中的超链接后。将会交由另一个webview进行处理，不再本webview中直接展示。为了布局
     
     - parameter webView:          webview
     - parameter navigationAction: 发生的链接变化
     - parameter decisionHandler:  处理方式
     */
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == WKNavigationType.LinkActivated {
            
            self.goWebViewController(navigationAction.request.URL!.URLString)
            
            return decisionHandler(WKNavigationActionPolicy.Cancel)
        }
        
        return decisionHandler(WKNavigationActionPolicy.Allow)
    }
}



extension DetailViewController :WKScriptMessageHandler{

    /**
     当客户端即收到来自于javascript的消息请求之后，将会调用到该方法。
     比如用户点击图片之后所调用的方法
     比如图片加载完成后展示将会调用该方法
     
     - parameter userContentController: userContentController
     - parameter message:               javascript 所发出的消息体
     */
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        
        guard let type = message.body["type"] as? Int else{return}
        
        if type == 0 { return self.adaptionWebViewHeightMethod() }
        
        
        if let index = message.body["index"] as? Int,let res = new?.getNewContentObject()?.getSkPhotos() {
        
            let browser = SKPhotoBrowser(photos: res)
            
            browser.initializePageIndex(index)
            browser.statusBarStyle = .LightContent
            
            // Can hide the action button by setting to false
            browser.displayAction = true
            
            self.presentViewController(browser, animated: true, completion: nil)
        }
    }
}