//
//  CommentUtil.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift
import AFDateHelper
import SwaggerClient

class CommentUtil: NSObject {
    
    /// 获取普通评论列表
    class func LoadNoramlCommentsList(new:New,p: String?="1", c: String?="20",finish:((count:Int)->Void)?=nil,fail:(()->Void)?=nil) {
        CommentAPI.nsComsCGet(did: new.docidBase64(), uid: "\(SDK_User.uid!)", p: p, c: c) { (datas, error) in
            if let code = datas?.objectForKey("code") as? Int{
                if code == 2002 {
                    finish?(count: 0)
                    return
                }
            }
            guard let da = datas,let data = da.objectForKey("data") as? NSArray else{ fail?();return}
            
            
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    realm.create(Comment.self, value: channel, update: true)
                    self.AnalysisComment(channel as! NSDictionary, realm: realm,new:new)
                }
            })
            finish?(count: data.count)
        }
    }
    
    /// 获取热门评论列表
    class func LoadHotsCommentsList(new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil) {
        
        CommentAPI.nsComsHGet(did: new.docidBase64()) { (datas, error) in
            
            guard let da = datas,let data = da.objectForKey("data") as? NSArray else{ fail?();return}
            
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    
                    realm.create(Comment.self, value: channel, update: true)
                    self.AnalysisComment(channel as! NSDictionary, realm: realm,new:new)
                    if let nid = channel.objectForKey("id") as? Int {
                        realm.create(Comment.self, value: ["id":nid,"ishot":1], update: true)
                    }
                }
            })
            finish?()
        }
    }
    
    // 完善新闻事件
    private class func AnalysisComment(channel:NSDictionary,realm:Realm,new:New){
        
        if let nid = channel.objectForKey("id") as? Int {
            
            var date = NSDate()
            
            if let pubTime = channel.objectForKey("ctime") as? String {
                
                date = NSDate(fromString: pubTime, format: DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))
            }
            
            realm.create(Comment.self, value: ["id":nid,"nid":new.nid,"ctimes":date], update: true)
        }
    }
}




extension Comment {
    
    func HeightByNewConstraint(tableView:UITableView) -> CGFloat{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("comments") as! CommentsTableViewCell
        
        let width = tableView.frame.width
        
        // 计算平路内容所占高度
        let contentSize = CGSize(width: width-18-38-12-18, height: 1000)
        let contentHeight = NSString(string:self.content).boundingRectWithSize(contentSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.contentLabel.font], context: nil).height
        
        // time
        let size = CGSize(width: 1000, height: 1000)
        let commentHeight = NSString(string:self.ctimes.weiboTimeDescription).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.infoLabel.font], context: nil).height
        
        // name
        let nameHeight = NSString(string:self.uname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.cnameLabel.font], context: nil).height
        
        return 21+21+nameHeight+commentHeight+contentHeight+12+8
    }
}