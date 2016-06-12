//
//  DetailViewControllerWebViewExtenion.swift
//  Journalism
//
//  Created by Mister on 16/5/31.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import WebViewJavascriptBridge

extension DetailViewController:UIWebViewDelegate{

    func setWebViewJavascriptBridge(){
    
        self.bridge = WebViewJavascriptBridge(forWebView: webView)
        self.bridge.setWebViewDelegate(self)
        
        self.bridge.registerHandler("testObjcCallback") { (data, block) in
            
            if let height = data.objectForKey("height") as? CGFloat {
            
                self.fixWebViewHeight(height)
            }
        }
    }
    
    /// 获取内容的对象
    func loadContentObjects(){
        
        if let n = new {
            
            NewContentUtil.LoadNewsContentData(n.nid, finish: { (newCon) in
                
                self.initWebViewString(newCon)
                }, fail: { 
                    
                    print("失败")
            })
        }
    }
    
    private func initWebViewString(newCon:NewContent){
        
        var body = ""
        
        for conten in newCon.content{
            
            if let img = conten.img {
                
                body += "<p><img  data-original=\"\(img)\" class=\"lazy img-responsive center-block\"src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyBpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNSBXaW5kb3dzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOkJDQzA1MTVGNkE2MjExRTRBRjEzODVCM0Q0NEVFMjFBIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOkJDQzA1MTYwNkE2MjExRTRBRjEzODVCM0Q0NEVFMjFBIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6QkNDMDUxNUQ2QTYyMTFFNEFGMTM4NUIzRDQ0RUUyMUEiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6QkNDMDUxNUU2QTYyMTFFNEFGMTM4NUIzRDQ0RUUyMUEiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz6p+a6fAAAAD0lEQVR42mJ89/Y1QIABAAWXAsgVS/hWAAAAAElFTkSuQmCC\" ></p>"
            }
            
            if let vid = conten.vid {
                
                body += "<div class = \"video\">\(vid)</div>"
            }
            
            if let txt = conten.txt {
                body += "<p>\(txt)</p>"
            }
        }
        
        let templatePath = NSBundle.mainBundle().pathForResource("content_template", ofType: "html")
        
        let comment = newCon.comment > 0 ? "   \(newCon.comment)评" : ""
        
        let variables = ["title":newCon.title,"source":newCon.pname,"ptime":newCon.ptime,"theme":"normal","body":body,"comment":comment]
        
        let result = engine.processTemplateInFileAtPath(templatePath, withVariables: variables)
        
        webView.loadHTMLString(result, baseURL: NSBundle.mainBundle().bundleURL)
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        webView.setNeedsLayout()
        webView.layoutIfNeeded()
        
        let string = webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight;")
        
        let con = CGFloat((string! as NSString).floatValue)
        self.webView.hidden = false
        webView.frame.size.height = con+35
        
        webView.scrollView.scrollsToTop = false
        
        tableView.tableHeaderView = self.webView
    }
    
    func fixWebViewHeight(height:CGFloat){
    
        webView.setNeedsLayout()
        webView.layoutIfNeeded()
//        webView.frame.size.height = height+35
//        
        webView.frame.size =  webView.sizeThatFits(CGSizeZero)
        
        webView.scrollView.scrollsToTop = false
        
        tableView.tableHeaderView = self.webView
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == UIWebViewNavigationType.LinkClicked && request.URL!.URLString.containsString("http"){
        
            self.goWebViewController(request.URL!.URLString)
            
            return false
        }
        
        return true
    }
    
}
