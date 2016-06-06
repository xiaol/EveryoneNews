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
    
    let realm = try! Realm()
    
    var hotResults:Results<Comment>!
    var aboutResults:Results<About>!
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let new = new {
            
            aboutResults = realm.objects(About.self).filter("nid = \(new.nid)")
            hotResults = realm.objects(Comment.self).filter("nid = \(new.nid) AND ishot = 1")
            
            CommentUtil.LoadHotsCommentsList(new, finish: {
                
                self.tableView.reloadData()
                
                }, fail: {
                    
            })
            
            AboutUtil.getAboutListArrayData(new, finish: { (count) in
                
                self.tableView.reloadData()
                
                }, fail: { 
                    
                    print(self.aboutResults.count)
            })
        }
        
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


extension DetailViewController:UITableViewDelegate,UITableViewDataSource {

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { // 生成头视图
        
        if section == 0 {return 0}
        if (hotResults == nil || hotResults.count <= 0 ) && section == 1 {return 0}
        if (aboutResults == nil || aboutResults.count <= 0 ) && section == 2 {return 0}
        return 26
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {return 1}
        
        if section == 1 && (hotResults != nil && hotResults.count > 0 ){
        
            return hotResults.count > 3 ? 4 : hotResults.count
        }
        
        if section == 2 && (aboutResults != nil && aboutResults.count > 0 ){
            
            return aboutResults.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("likeandpyq")! as UITableViewCell
            
            return cell
        }
        
        if indexPath.section == 1 {
        
            if indexPath.row == 3 {
            
                let cell = tableView.dequeueReusableCellWithIdentifier("morecell")! as UITableViewCell
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("comments") as! CommentsTableViewCell
            
            cell.setCommentMethod(hotResults[indexPath.row])
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("aboutcell")! as UITableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
        
            return 76
        }
        
        if indexPath.section == 1 {
        
            if indexPath.row == 3 {
                
                return 101
            }
            return hotResults[indexPath.row].HeightByNewConstraint(tableView)
        }

        
        return 116
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {return nil}
        
        let cell = tableView.dequeueReusableCellWithIdentifier("newcomments") as! CommentsTableViewHeader
        
        if section == 1 {
            
            let text = hotResults.count > 0 ? "(\(hotResults.count))" : ""
            
            cell.titleLabel.text = "最热评论\(text)"
            
        }else{
            
            cell.titleLabel.text = "相关观点"
        }
        
        return cell
        
    }
}