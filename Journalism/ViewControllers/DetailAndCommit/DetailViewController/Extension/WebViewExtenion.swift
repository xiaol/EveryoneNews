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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = UIScreen.main.bounds.height+scrollView.contentOffset.y
        
        let jsStr = "scrollMethod(\(height))"
        
        self.webView.evaluateJavaScript(jsStr, completionHandler: { (body, error) in
            
            
        })
        
        self.adaptionWebViewHeightMethod()
    }
    
    /**
     当滑动视图停止，记录滑动到达的位置 用来记录用户的赏赐查看位置
     
     - parameter scrollView: 滑动视图
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
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
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: FONTMODALSTYLEIDENTIFITER), object: nil, queue: OperationQueue.main) { (_) in
            
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
        configuration.userContentController.add(self, name: "JSBridge")
        //        configuration.allowsInlineMediaPlayback = true
        self.webView = WKWebView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 600, height: 1000)), configuration: configuration)
        
        self.webView.isHidden = true
        self.webView.navigationDelegate = self
        self.webView.scrollView.isScrollEnabled = false
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
                
//                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
                
                self.tableView.reloadData()
                
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
    func ShowNewCOntentInWebView(_ newContent:NewContent?=nil){
        
        if let newCon = newContent {
            
            self.webView.loadHTMLString(newCon.getHtmlResourcesString(), baseURL: Bundle.main.bundleURL)
        }
    }
    
    /**
     当调用到这个方法的时候，WkWebView将会调用Javascript的方法，来以此获取新闻展示页面所需要的高度
     获取高度完成之后就进行页面的重新布局以加入到tableView的表头中作为一个详情展示页
     */
    func adaptionWebViewHeightMethod(_ height:CGFloat = -1){
        
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
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.adaptionWebViewHeightMethod()
        
        self.webView.isHidden = false
        
        self.tableView.setContentOffset(CGPoint(x: 0,y: 1), animated: false)
        
        if let off = self.new?.getNewContentObject()?.scroffY {
            
            self.tableView.setContentOffset(CGPoint(x: 0, y: CGFloat(off)), animated: false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
            self.hiddenWaitLoadView() // 隐藏加载视图
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
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
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            
//            self.goWebViewController(navigationAction.request.url!.absoluteString)
            
            return decisionHandler(WKNavigationActionPolicy.cancel)
        }
        
        return decisionHandler(WKNavigationActionPolicy.allow)
    }
}


import PINCache
import PINRemoteImage

extension String {
    
    fileprivate func DownloadImageByUrl(_ progress:@escaping (Int) -> Void,finish:@escaping (String) -> Void){
        
        if let str = PINCache.shared().object(forKey: "hanle\(self)") as? String {
            
            return finish(str)
        }
        
        guard let url = URL(string: self) else { return }
        
        PINRemoteImageManager.shared().downloadImage(with: url, options: PINRemoteImageManagerDownloadOptions(), progressDownload: { (min, max) in

            if url.absoluteString.hasSuffix(".gif") {
                
                let process = Int(CGFloat(min)/CGFloat(max)*100)
                progress((process-5 < 0 ? 0 : process-5))
            }
            
        }) { (result) in
            
            self.HandlePinDownLoadResult(finish,result:result)
        }
    }
    
    /**
     处理PINRemoteImage下载完成的结果哦
     
     - parameter finish: 处理完成化后的回调
     - parameter result: Result to PINRemoteImageManagerResult
     */
    fileprivate func HandlePinDownLoadResult(_ finish:@escaping (String) -> Void,result:PINRemoteImageManagerResult){
    
        /// 含有静态图片
        if let img = result.image ,let base64 = UIImageJPEGRepresentation(img, 0.9)?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)){
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                
                let string = "data:image/jpeg;base64,\(base64)".replaceRegex("<", with: "").replaceRegex(">", with: "")
                
                DispatchQueue.main.async(execute: {
                    
                    finish(string)
                    
                    PINCache.shared().setObject(string as NSCoding, forKey: "hanle\(self)")
                })
            })
        }
        
        /// 含有动态图片
        if let img = result.animatedImage {
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                
                let base64 = img.data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
                
                let string = "data:image/gif;base64,\(base64)".replaceRegex("<", with: "").replaceRegex(">", with: "")
                
                DispatchQueue.main.async(execute: {
                    
                    finish(string)
                    
                    PINCache.shared().setObject(string as NSCoding, forKey: "hanle\(self)")
                })
            })
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
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        
        
//        guard let type = message.body["type"] as? Int else{return}
//        
//        if type == 0 { return self.adaptionWebViewHeightMethod() }
//        
//        if type == 3 {
//            
//            if let url = message.body["url"] as? String,let index = message.body["index"] as? Int {
//                
//                self.HandleUrlAndIndex(url, index: index)
//            }
//        }
//        
//        if type == 1 {
//            if let index = message.body["index"] as? Int,let res = new?.getNewContentObject()?.getSkPhotos() {
//                let browser = SKPhotoBrowser(photos: res)
//                browser.initializePageIndex(index)
//                browser.statusBarStyle = .lightContent
//                browser.displayAction = true
//                self.present(browser, animated: true, completion: nil)
//            }
//        }
    }
    
    /**
     根据提供的 URL 和 需要加载完成的 Index
     
     - parameter url:   图片URL
     - parameter index: 图片所在的Index
     */
    fileprivate func HandleUrlAndIndex(_ url:String,index:Int){
    
        url.DownloadImageByUrl({ (pro) in

            DispatchQueue.main.async(execute: { 
                
                let jsStr = "$(\"div .customProgressBar\").eq(\(index)).css(\"width\",\"\(pro)%\")"
                
                self.webView.evaluateJavaScript(jsStr, completionHandler: nil)
            })
            
            }, finish: { (base64) in
                
                let jsStr = "$(\"img\").eq(\(index)).attr(\"src\",\"\(base64)\")"
                
                self.webView.evaluateJavaScript(jsStr, completionHandler: nil)
                
                if url.hasSuffix(".gif") {
                
                    let display = "$(\"div .progress\").eq(\(index)).css(\"visibility\",\"hidden\")"
                    
                    self.webView.evaluateJavaScript(display, completionHandler: nil)
                }
        })
    }
}
