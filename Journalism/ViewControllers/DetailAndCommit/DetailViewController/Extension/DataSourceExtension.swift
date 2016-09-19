//
//  DetailViewControllerDataSource.swift
//  Journalism
//
//  Detail VC 关于表格的数据源处理的相关扩展
//
//  Created by Mister on 16/6/12.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


extension DetailViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 4 } // 无论如何都需要现实三个section。只是有没有内容，再根据具体情况决定
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0 } // 隐藏所有的尾部视图
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return getHeaderHeightForSection(section) }// 生成头视图
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return getRowCountForSection(section) } // 确定每一个section的数目
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return getCellForRowAtIndexPath(indexPath) }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return getHeightForRowAtIndexPath(indexPath)}
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return getViewForHeaderInSection(section) }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section != 3 { return }
        
        let about = self.aboutResults[(indexPath as NSIndexPath).row]
        
        if about.isread == 0 {
            
            about.isRead() // 标记为已读
        }
        
        self.goWebViewController(about.url)
        self.tableView.reloadData()
    }
}


extension DetailViewController{
    
    fileprivate func ShareMethod(_ type:String=UMShareToWechatTimeline,content:String,img:UIImage?=nil,resource:UMSocialUrlResource?=nil){
        
        UMSocialDataService.default().postSNS(withTypes: [type], content: content, image: img, location: nil, urlResource: resource, presentedController: self) { (response) -> Void in
            
            //            self.shreContentViewMethod(true, animate: true)
        }
    }

    
    fileprivate func getCellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
    
        if (indexPath as NSIndexPath).section == 0 { // 如果是第一个section 则返回喜欢喝朋友圈分享的Cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "likeandpyq") as! LikeAndPYQTableViewCell
            
            if let n = self.new {
                
                cell.setNew(n)
            }
            
            
            cell.weChatCriButton.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
                guard let n = self.new else{ return }
                
                let title = n.title
                
                let resource = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: n.shareUrl())
                
                n.firstImage { (image) in
                    
                    self.ShareMethod(content:title,img:image,resource:resource)
                }
            }))
            
            self.adaptionWebViewHeightMethod()
            return cell
        }
        
        /**
         *   如果是第二个seciton 则回事关注独享的视图
         */
        if (indexPath as NSIndexPath).section == 1 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "fouces") as! DetailFoucesCell
            
            if let nc = self.new {
            
                cell.setNewContent(nc.pname)
                
                cell.fButton.removeActions(events: UIControlEvents.touchUpInside)
                cell.fButton.addAction(events: .touchUpInside, closure: { (_) in
                    
                    if cell.fButton.exiter {
                    
                        return self.toFocusViewController()
                    }
                    
                    if ShareLUser.utype == 2 {
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
                    }else{
                        
                        cell.fButton.loading()
                        
                        Focus.focusPub(nc.pname, finish: { 
                            
                            cell.fButton.refresh()
                            
                            self.ShowF.ShowFouceView()
                            
                            }, fail: {
                                
                                cell.fButton.refresh()
                                
                                self.ShowF.ShowFouceView(.fail)
                        })
                    }
                })
            }
            
            cell.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in

                self.toFocusViewController()
            }))
            
            return cell
        }
        
        if (indexPath as NSIndexPath).section == 2 { // 如果是第三section 则会热门评论的cell
            
            if (indexPath as NSIndexPath).row == 3 { return self.getMoreTableViewCell(indexPath) }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "comments") as! CommentsTableViewCell
            
            let comment = hotResults[(indexPath as NSIndexPath).row]
            
            cell.setCommentMethod(comment, tableView: tableView, indexPath: indexPath)
            
            return cell
        }
        
        let about = self.aboutResults[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutcell") as! AboutTableViewCell
        
        cell.backgroundColor = UIColor.red
        
        cell.isHeader = (indexPath as NSIndexPath).row == 0
        
        cell.setAboutMethod(about,hiddenY: self.getIsHeaderYear(indexPath))
        
        cell.contentLabel.attributedText = about.htmlTitle.toAttributedString()
        
        return cell
    }
    
    fileprivate func toFocusViewController(){
    
        if self.fdismiss {
            
            return self.dismiss(animated: true, completion: nil)
        }
        
        let viewC = UIStoryboard.shareStoryBoard.get_FocusViewController(self.newCon.pname)
        
        viewC.dismiss = self.dismiss
        
        self.present(viewC, animated: true, completion: nil)
    }
    
    // 获取查看全部评论的视图
    fileprivate func getMoreTableViewCell(_ indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "morecell")! as UITableViewCell
        
        /****************	点击按钮活着点击整个cell 发送前往评论视图的消息	****************/
        
        if let button = cell.viewWithTag(10) as? UIButton {
            button.removeActions(events: UIControlEvents.touchUpInside)
            button.addAction(events: .touchUpInside, closure: { (_) in
                NotificationCenter.default.post(name: Notification.Name(rawValue: CLICKTOCOMMENTVIEWCONTROLLER), object: nil)
            })
        }
        cell.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: CLICKTOCOMMENTVIEWCONTROLLER), object: nil)
        }))
        
        return cell
    }
    
    // 根据section 返回每一个section 的 头视图
    fileprivate func getViewForHeaderInSection(_ section: Int) -> UIView?{
        if section == 0 || section == 1{return nil}
        if (self.hotResults == nil || self.hotResults.count == 0 ) && section == 2 {return nil}
        if (self.aboutResults == nil || self.aboutResults.count == 0 ) && section == 3 {return nil}
        let cell = tableView.dequeueReusableCell(withIdentifier: "newcomments") as! CommentsTableViewHeader
        if section == 2 { // 如果是第一个 则是 最热评论相关视图
            let text = hotResults.count > 0 ? "(\(hotResults.count))" : ""
            cell.titleLabel.text = "最热评论\(text)"
        }else{ // 如果是其他，也就是直邮第二个section 说明就是 相关新闻 视图
            cell.titleLabel.text = "相关观点"
        }
        
        let containerView = UIView(frame:cell.bounds)
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(cell)
        return containerView
    }
    
    // 返回每一个Row的高度
    fileprivate func getHeightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat{
        if (indexPath as NSIndexPath).section == 0 { return 66 } // 如果是一section 是 喜欢喝朋友圈，固定高度
        
        if (indexPath as NSIndexPath).section == 2 {
            if (indexPath as NSIndexPath).row == 3 { return 101 } // 如果是第三行，则固定高度 更多评论
            return hotResults[(indexPath as NSIndexPath).row].HeightByNewConstraint(tableView) // 根据评论内容返回高度
        }
        
        if (indexPath as NSIndexPath).section == 3 {
            return aboutResults[(indexPath as NSIndexPath).row].HeightByNewConstraint(tableView,hiddenY: self.getIsHeaderYear(indexPath)) // 根据相关内容返回高度
        }
        return 99
    }
    
    // 获取每一个sction的行的数目
    func getRowCountForSection(_ section:Int) -> Int{
        
        if section == 0 || section == 1{return 1} // 如果是第一个则固定返回一行，用于现实喜欢朋友圈
        if section == 2 && (hotResults != nil && hotResults.count > 0 ){ return hotResults.count > 3 ? 4 : hotResults.count } // 如果是第一个，人们评论相关的section
        if section == 3 && (aboutResults != nil && aboutResults.count > 0 ){ return aboutResults.count } // 相关新闻的section
        return 0
    }
    
    // 获取每一个Section头视图的高度的方法
    fileprivate func getHeaderHeightForSection(_ section:Int) -> CGFloat{
        if section == 0 || section == 1 {return 0} // 如果是第一个section，那么它是因为是喜欢 朋友圈相的所以不需要头视图
        if (hotResults == nil || hotResults.count == 0 ) && section == 2 {return 0} // 如果是第二个section，是热门评论，所以需要热门评论的头视图
        if (aboutResults == nil || aboutResults.count == 0 ) && section == 3 {return 0} // 如果是第三个section 因为是相关观点，判断相关观点的数目之后，决定是否显示相关观点
        return 40
    }
    
    // 获取头视图是不是隐藏文件
    fileprivate func getIsHeaderYear(_ indexPath:IndexPath) -> Bool{
        if (indexPath as NSIndexPath).row == 0 { return true }
        let before = self.aboutResults[(indexPath as NSIndexPath).row-1]
        let current = self.aboutResults[(indexPath as NSIndexPath).row]
        return before.ptimes.year() == current.ptimes.year()
    }
}
