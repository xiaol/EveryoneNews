//
//  DetailViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip
import MGTemplateEngine

class DetailViewController: UIViewController,IndicatorInfoProvider,UIWebViewDelegate {
    
    var new:New?
    
    @IBOutlet var tableView: UITableView!
    
    private var engine:MGTemplateEngine!
    
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var webViewHeightConstraint: NSLayoutConstraint!
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: "评论")
        
        return info
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        webView.scrollView.scrollsToTop = false
        
        engine = MGTemplateEngine()
        engine.matcher = ICUTemplateMatcher(templateEngine: engine)
        
        self.loadContentObjects()
        
    }
    
    
    private func loadContentObjects(){
    
        if let n = new {
            
            NewContentUtil.LoadNewsContentData(n.nid, finish: { (newCon) in
                
                self.initWebViewString(newCon)
                
            }) {
                
            }
        }
    }
    
    private func initWebViewString(newCon:NewContent){
    
        var body = ""
        
        for conten in newCon.content{
        
            if let img = conten.img {
            
                body += "<p><img data-src=\"\(img)\" width=\"100%\"></p>"
            }
            
            
            if let vid = conten.vid {
                body += "<p>\(vid)</p>"
            }
            
            
            if let txt = conten.txt {
                body += "<p>\(txt)</p>"
            }
            
        }
        
        
        let templatePath = NSBundle.mainBundle().pathForResource("content_template", ofType: "html")
        
        let variables = ["title":newCon.title,"source":newCon.pname,"ptime":newCon.ptime,"theme":"normal","body":body]
        
        let result = engine.processTemplateInFileAtPath(templatePath, withVariables: variables)
        
        print(result)
        
        webView.loadHTMLString(result, baseURL: NSBundle.mainBundle().bundleURL)
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        webView.setNeedsLayout()
        webView.layoutIfNeeded()

        
        let string = webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"container\").offsetHeight;")
        
        let con = CGFloat((string! as NSString).floatValue)
        
        print("高度",con)
        
        webView.frame.size.height = con+35
        
        tableView.tableHeaderView = self.webView
    }
    
    
    
}


extension DetailViewController:UITableViewDelegate,UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 200
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
}