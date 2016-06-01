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
                
                body += "<p><img src = \"home.png\" data-original=\"\(img)\" class=\"lazy img-responsive center-block\" ></p>"
            }
            
            if let vid = conten.vid {
                body += "<p>视频链接 ＝ \(vid)</p>"
            }
            
            if let txt = conten.txt {
                body += "<p class=\"lead\">\(txt)</p>"
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
        
        tableView.tableHeaderView = self.webView
    }
    
    func fixWebViewHeight(height:CGFloat){
    
        webView.setNeedsLayout()
        webView.layoutIfNeeded()
        webView.frame.size.height = height+35
        
        tableView.tableHeaderView = self.webView
    }
}
