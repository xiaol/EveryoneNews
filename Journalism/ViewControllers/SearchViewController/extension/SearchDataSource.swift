//
//  SearchViewControllerDataSource.swift
//  Journalism
//
//  Created by Mister on 16/6/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension SearchViewController:UITableViewDataSource{
    
    /**
     返回一共有2个section
     
     - parameter tableView: 表格
     
     - returns: section的个数
     */
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    
    /**
     返回每一个Section对象的cell的树木
     
     - parameter tableView: <#tableView description#>
     - parameter section:   <#section description#>
     
     - returns: <#return value description#>
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if section == 0 { return 1 }
        return self.results.count
    }
    
    /**
     返回每一个行
     如果section是0的话，那么返回的就是热点搜索的视图
     如果为1的话，返回的就是历史搜索的视图
     
     - parameter tableView: <#tableView description#>
     - parameter indexPath: <#indexPath description#>
     
     - returns: <#return value description#>
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "hot") as! SearchHotTableViewCell
            
            self.setHotView(cell, indexPath: indexPath)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "his") as! SearchHistoryTableViewCell
        
        cell.titleLabel.text = self.results[(indexPath as NSIndexPath).row].title
        return cell
    }
    
    /**
     设置热点搜索视图
     首先根据热点结果，进行tag的创建，将tag添加至tagView中，完成tagView的现实
     
     - parameter cell:      <#cell description#>
     - parameter indexPath: <#indexPath description#>
     */
    fileprivate func setHotView(_ cell:SearchHotTableViewCell,indexPath:IndexPath){
    
        cell.tagView.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        cell.tagView.padding = UIEdgeInsets(top: 23, left: 12, bottom: 23, right: 12)
        cell.tagView.interitemSpacing = 12
        cell.tagView.lineSpacing = 18
        
        cell.tagView.removeAllTags()
        
        hotResults.forEach { (sh) in
            
            let tag = SKTag(text: sh.title)
            tag.textColor = UIColor.a_color3
            tag.fontSize = 16
            tag.borderColor = UIColor.a_color5
            tag.cornerRadius = 17
            tag.borderWidth = 1
            tag.padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            cell.tagView.addTag(tag)
        }
        
        cell.tagView.didTapTagAtIndex = {(index) in
            let key = self.hotResults[Int(index)].title
            let search = UIStoryboard.shareStoryBoard.get_SearchListViewController(key)
            self.present(search, animated: true, completion: nil)
        }
    }
}



extension SearchViewController:UITableViewDelegate{

    /**
     设置表头视图。防止报错，需要在cell外面再套一个UIView。
     
     - parameter tableView: <#tableView description#>
     - parameter section:   <#section description#>
     
     - returns: <#return value description#>
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 && self.results.count <= 0  {return nil}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! SearchHeaderTableViewCell
        cell.setHeader(section == 0 ? HeaderStyle.hot : HeaderStyle.history)
        let containerView = UIView(frame:cell.frame)
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(cell)
        containerView.clipsToBounds = true
        
        cell.clearButton.removeActions(events: .touchUpInside)
        cell.clearButton.addAction(events: .touchUpInside) { (_) in
            
            self.alertToAskUserClearHistory()
        }
        
        return containerView
    }

    /**
     返回每一个表头的高度
     默认高度35
     
     - parameter tableView: <#tableView description#>
     - parameter section:   <#section description#>
     
     - returns: <#return value description#>
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 35
    }
    
    
    /**
     设置每一个 TablViewCell 的高度。
     热门搜索因为使用了空间，所以在具体设置的时候，需要先生成一个Cell。虽然知道这很不好，但是没办法。
     历史搜索每一个行的都是默认的 高度。54
     
     - parameter tableView: <#tableView description#>
     - parameter indexPath: <#indexPath description#>
     
     - returns: <#return value description#>
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "hot") as! SearchHotTableViewCell
            self.setHotView(cell, indexPath: indexPath)
            return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        }
        return 54
    }
    
    
    /**
     当用户点击了某一行历史搜索记录的时候，将会跳转至搜索结果视图，并将该记录传递给搜索结果界面
     
     - parameter tableView: 表哥对象
     - parameter indexPath: indexPath 对象
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {return}
        let key = self.results[(indexPath as NSIndexPath).row].title
        let search = UIStoryboard.shareStoryBoard.get_SearchListViewController(key)
        self.present(search, animated: true, completion: nil)
    }
}

extension SearchViewController{

    /**
     当用户点击了删除所有的历史搜索记录的时候，调用该方法，达到提醒用户接下来操作的作用
     */
    fileprivate func alertToAskUserClearHistory(){
        let aler = UIAlertController(title: "是否清除搜索记录", message: "清除后不可恢复", preferredStyle: UIAlertControllerStyle.alert)
        aler.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        aler.addAction(UIAlertAction(title: "清除", style: UIAlertActionStyle.destructive, handler: { (_) in
            SearchHistory.delAll()
        }))
        self.present(aler, animated: true, completion: nil)
    }
}
