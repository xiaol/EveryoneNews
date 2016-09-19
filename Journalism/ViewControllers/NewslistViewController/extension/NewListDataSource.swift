//
//  NewListDataSource.swift
//  Journalism
//
//  Created by Mister on 16/6/2.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


extension NewslistViewController:UITableViewDataSource{
    
    /**
     设置表格的每一个section的表头高度为0
     
     - parameter tableView: 表格对象
     - parameter section:   当前要设置sction尾部视图的section index
     
     - returns: 返回section尾部视图的高度
     */
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    /**
     设置表格的每一个section🔍的狂的高度
     
     默认为 53
     
     - parameter tableView: 表格对象
     - parameter section:   当前要设置sction头视图的section index
     
     - returns: 返回section尾部视图的高度
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 53
    }
    
    /**
     设置搜索框的显示 获取一个cell 之后使用 一个UIView 座位容器进行显示
     这样是为了让cell在刷新的时候不会出现一个错误
     
     - parameter tableView: 表哥对象
     - parameter section:   Section Index
     
     - returns: 返回搜索框视图
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "search")! as UITableViewCell
        
        cell.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            self.fuckHeaderCellView = cell
            
            self.present(UIStoryboard.shareStoryBoard.get_SearchViewController(), animated: true, completion: nil)
        }))
        let containerView = UIView(frame:cell.frame)
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(cell)
        return containerView
    }
    
    /**
     设置新闻的个数
     
     判断当前视图没有newResults对象，如果没有 默认返回0
     有则正常返回其数目
     
     - parameter tableView: 表格对象
     - parameter section:   section index
     
     - returns: 新闻的个数
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsResults.count
    }
    
    /**
     返回每一个新闻的展示
     其中当遇到 这个新闻的 `isidentification` 的标示为 1 的时候，说明这条新闻是用来显示一个刷新视图的。
     其它的新闻会根据起 style 参数进行 没有图 一张图 两张图 三张图的 新闻展示形式进行不同形式的展示
     
     - parameter tableView: 表格对象
     - parameter indexPath: 当前新闻展示的位置
     
     - returns: 返回新闻的具体战士杨视图
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[(indexPath as NSIndexPath).row]
        
        if new.isidentification == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "refreshcell")! as UITableViewCell
            
            return cell
        }
        
        if new.style == 0 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewNormalTableViewCell") as! NewNormalTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 1 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewOneTableViewCell") as! NewOneTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 2 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewTwoTableViewCell") as! NewTwoTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 3 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewThreeTableViewCell") as! NewThreeTableViewCell
            
            cell.setNewObject(new)
        }else{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "NewTwoTableViewCell") as! NewTwoTableViewCell
            
            switch new.style-10 {
            case 1:
                cell.setNewObject(new,bigImg: 0)
            case 2:
                cell.setNewObject(new,bigImg: 1)
            default:
                cell.setNewObject(new,bigImg: 2)
            }
        }
        
        // 针对关注频道的修改
        self.SetFCell(cell, new: new)
        
        cell.noLikeButton.removeActions(events: UIControlEvents.touchUpInside)
        cell.noLikeButton.addAction(events: UIControlEvents.touchUpInside) { (_) in
            
            self.handleActionMethod(cell, indexPath: indexPath)
        }
        
        if self.channel?.id == 1 {
            
            cell.setPPPLabel(new)
        }
        
        return cell
    }
    
    
    /**
     设置关注cell的视图
     */
    fileprivate func SetFCell(_ cell:NewBaseTableViewCell,new:New){
        
        if channel?.id == 1994 {
            
            cell.pubLabel.layer.cornerRadius = 2
            cell.pubLabel.clipsToBounds = true
            cell.pubLabel.textColor = UIColor.white
            cell.pubLabel.font = UIFont.a_font6
            cell.pubLabel.text = " \(cell.pubLabel.text ?? " ") "
            cell.pubLabel.backgroundColor = Focus.gColor(new.pname)
            cell.commentCountLabel.isHidden = true
            cell.noLikeButton.isHidden = true
        }
    }
    
    /**
     处理用户的点击新闻视图中的 不喜欢按钮处理方法
     
     首先获取当前cell基于注视图的point。用于传递给上层视图进行 cell 新闻的展示
     计算cell所在的位置，之后预估起全部展开的位置大小，是否会被遮挡，如果被遮挡 ，就先进性cel的移动，使其不会被遮挡
     之后将这个cell和所在的point传递给上层视图 使用的传递工具为 delegate
     之后上层视图处理完成之后，返回是否删除动作，当前tableview进行删除或者刷新cell
     
     - parameter cell:      返回被点击的cell
     - parameter indexPath: 被点击的位置
     */
    fileprivate func handleActionMethod(_ cell :NewBaseTableViewCell,indexPath:IndexPath){
        
        var delayInSeconds = 0.0
        
        let porint = cell.convert(cell.bounds, to: self.view).origin
        
        if porint.y < 0 {
            
            delayInSeconds = 0.5
            
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        }
        
        let needHeight = porint.y+cell.frame.height+128
        
        if  needHeight > self.tableView.frame.height {
            
            delayInSeconds = 0.5
            
            let result = needHeight-self.tableView.frame.height
            
            let toPoint = CGPoint(x: 0, y: self.tableView.contentOffset.y+result)
            
            self.tableView.setContentOffset(toPoint, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { // 2
            self.delegate.ClickNoLikeButtonOfUITableViewCell?(cell, finish: { (cancel) in
                
                if !cancel {
                    
                    self.newsResults[(indexPath as NSIndexPath).row].suicide()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { // 2
                        
                        self.showNoInterest()
                        
                        self.tableView.reloadData()
                    }
                }else{
                    
                    self.tableView.reloadData()
                }
            })
        }
    }
    
}

import RealmSwift

extension NewslistViewController:UITableViewDelegate{

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY = scrollView.contentOffset.y
        
        if !decelerate && offsetY > 0 && offsetY < 53{
        
            if offsetY > 53/2 || scrollView.panGestureRecognizer.velocity(in: scrollView).y < -50{
                
                scrollView.setContentOffset(CGPoint(x: 0, y: 53), animated: true)
            }else{
            
                scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }

    /**
     点击cell 之后处理的方法
     如果是刷新的cell就进行当前新闻的刷新
     如果是新闻cell就进行
     
     - parameter tableView: tableview 对象
     - parameter indexPath: 点击的indexPath
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let new = newsResults[(indexPath as NSIndexPath).row]
        
        print(new.url)
        
        if new.isread == 0 {
            
            new.isRead() // 设置为已读
        }
    
        if new.isidentification == 1 {
            
            return self.tableView.mj_header.beginRefreshing()
        }
        
        let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
        
        if IS_PLUS {
            
            self.showDetailViewController(viewController, sender: nil)
        }else{
            
            self.show(viewController, sender: nil)
        }
    }
}
