//
//  CommitViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import MJRefresh
import RealmSwift

extension CommitViewController{

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setResults()
        self.setHeaderView()
        
        if let new = new {
            
            let footer = MJRefreshAutoNormalFooter {
                CommentUtil.LoadNoramlCommentsList(new, p: "\(self.currentPage++)", c: "20", finish: { (count) in
                    
                    if count < 20 {
                        
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else{
                        
                        self.tableView.mj_footer.endRefreshing()
                    }
                    
                    self.tableView.reloadData()
                    }, fail: {
                        
                        self.tableView.mj_footer.endRefreshing()
                })
            }
            
            self.tableView.mj_footer = footer
        }
    }
    
    
    // 设置数据源对象
    private func setResults(){
        
        if let new = new {
            
            let realm = try! Realm()
            
            hotResults = realm.objects(Comment.self).filter("nid = \(new.nid) AND ishot = 1")
            normalResults = realm.objects(Comment.self).filter("nid = \(new.nid)")
        }
        
        self.tableView.reloadData()
    }
    
    // 设置表头视图
    private func setHeaderView(){
        
        if let n  = new {
            
            self.newTitleLabel.text = n.title
            let comment = n.comment > 0 ? "   \(n.comment)评" : ""
            self.newInfoLabel.text = "\(n.pname)  \(n.ptime)\(comment)"
            
            tableViewHeaderView.setNeedsLayout()
            tableViewHeaderView.layoutIfNeeded()
            
            let tsize = CGSize(width: self.view.frame.width-18-18, height: 1000) // 获得标题最宽的宽度
            let titleHeight = NSString(string:self.newTitleLabel.text!).boundingRectWithSize(tsize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:self.newTitleLabel.font], context: nil).height // 获得标题所需高度
            let infoHeight = NSString(string:self.newInfoLabel.text!).boundingRectWithSize(tsize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:self.newInfoLabel.font], context: nil).height // 获得info所需高度
            
            tableViewHeaderView.frame.size.height = titleHeight+infoHeight+17+33+8
            
            tableView.tableHeaderView = self.tableViewHeaderView
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (_) in
            
            self.setHeaderView()
            
            }, completion: nil )
    }
}
