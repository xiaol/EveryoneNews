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
        
        let height = UIScreen.mainScreen().bounds.height+scrollView.contentOffset.y
        
        let jsStr = "scrollMethod(\(height))"
        
        self.webView.evaluateJavaScript(jsStr, completionHandler: { (body, error) in
            
            
        })
        
        self.adaptionWebViewHeightMethod()
    }
    
    /**
     当滑动视图停止，记录滑动到达的位置 用来记录用户的赏赐查看位置
     
     - parameter scrollView: 滑动视图
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        new?.getNewContentObject()?.scroffY(scrollView.contentOffset.y)
    }
    
    /**
     整合方法
     完成webview的初始化 
     完成新闻详情页面的加载方法
     监听字体变化的方法
     */
    func integrationMethod(){
    
        self.initWebViewInit()
        
        self.loadContentObjects()
        
        /**
         *  该方法会检测用户设置字体大小的方法
         *  当用户设置字体后，会发起该通知。
         *
         *  @param FONTMODALSTYLEIDENTIFITER  用户发起的通知的名称
         *  @param nil                        所携带的数据
         *  @param NSOperationQueue.mainQueue 需要执行接下来操作的县城
         *
         *  @return 所需要完成的操作
         */
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
        configuration.allowsInlineMediaPlayback = true
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
                
                self.newCon = newCon
                
                self.ShowNewCOntentInWebView(newCon)
                
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
                
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

        self.webView.evaluateJavaScript("document.getElementById('section').offsetHeight") { (data, _) in
            
            if let height = data as? CGFloat{
                
                if self.webView.frame.size.height != height+35 {
                
                    self.webView.layoutIfNeeded()
                    self.webView.frame.size.height = height+35
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
        

        self.webView.hidden = false
        
        self.tableView.setContentOffset(CGPoint(x: 0,y: 1), animated: false)
        
        if let off = new?.getNewContentObject()?.scroffY {
            
            self.tableView.setContentOffset(CGPoint(x: 0, y: CGFloat(off)), animated: false)
        }
        
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


import PINRemoteImage

extension String {

    private func DownloadImageByUrl(progress:(Int) -> Void,finish:(String) -> Void){
    
        guard let url = NSURL(string: self) else { return }
        
        PINRemoteImageManager.sharedImageManager().downloadImageWithURL(url, options: .DownloadOptionsNone, progressDownload: { (min, max) in
            
            let process = Int(CGFloat(min)/CGFloat(max)*100)
            
            progress((process-5 < 0 ? 0 : process-5))
            
            }) { (result) in
                
                if let img = result.image ,base64 = UIImagePNGRepresentation(img)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0)){
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        
                        let string = "data:image/jpeg;base64,\(base64)".replaceRegex("<", with: "").replaceRegex(">", with: "")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            progress(98)
                            
                            finish(string)
                        })
                    })
                }
                
                if let img = result.animatedImage {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        
                        let base64 = img.data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
                        
                        let string = "data:image/gif;base64,\(base64)".replaceRegex("<", with: "").replaceRegex(">", with: "")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            progress(98)
                            
                            finish(string)
                        })
                    })
                }
        }
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
        
        if type == 3 {
        
            if let url = message.body["url"] as? String,index = message.body["index"] as? Int {
            
                url.DownloadImageByUrl({ (pro) in
                    
                    let jsStr = "$(\"div .customProgressBar\").eq(\(index)).css(\"width\",\"\(pro)%\")"
                    
                    self.webView.evaluateJavaScript(jsStr, completionHandler: nil)
                    
                    }, finish: { (base64) in
                        
                        let download = "$(\"div .customProgressBar\").eq(\(index)).css(\"width\",\"100%\")"
                        
                        self.webView.evaluateJavaScript(download, completionHandler: { (_, _) in
                            
                            let jsStr = "$(\"img\").eq(\(index)).attr(\"src\",\"\(base64)\")"
                            
                            self.webView.evaluateJavaScript(jsStr, completionHandler: { (_, _) in
                                
                                let display = "$(\"div .progress\").eq(\(index)).css(\"visibility\",\"hidden\")"
                                
                                self.webView.evaluateJavaScript(display, completionHandler: nil)
                            })
                        })
                })
            }
            
            return
        }
        
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