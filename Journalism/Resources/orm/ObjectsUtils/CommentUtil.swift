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
    class func LoadNoramlCommentsList(_ new:New,p: String?="1", c: String?="20",finish:((_ count:Int)->Void)?=nil,fail:(()->Void)?=nil) {
        
        CommentAPI.nsComsCGet(did: new.docidBase64(), uid: "\(ShareLUser.uid)", p: p, c: c) { (datas, error) in
            
            if let code = datas?.object(forKey: "code") as? Int{
                if code == 2002 {
                    finish?(0)
                    return
                }
            }
            guard let da = datas,let data = da.object(forKey: "data") as? NSArray else{ fail?();return}
            
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    realm.create(Comment.self, value: channel, update: true)
                    self.AnalysisComment(channel as! NSDictionary, realm: realm,new:new)
                }
            })
            finish?(data.count)
        }
    }
    
    /// 获取热门评论列表
    class func LoadHotsCommentsList(_ new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil) {
        
        CommentAPI.nsComsHGet(did: new.docidBase64(), uid: "\(ShareLUser.uid)") { (datas, error) in
            
            guard let da = datas,let data = da.object(forKey: "data") as? NSArray else{ fail?();return}
            
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    
                    realm.create(Comment.self, value: channel, update: true)
                    self.AnalysisComment(channel as! NSDictionary, realm: realm,new:new)
                    if let nid = (channel as AnyObject).object(forKey: "id") as? Int {
                        realm.create(Comment.self, value: ["id":nid,"ishot":1], update: true)
                    }
                }
            })
            finish?()
        }
    }
    
    
}

extension CommentUtil{
    // 完善评论对象
    fileprivate class func AnalysisComment(_ channel:NSDictionary,realm:Realm,new:New){
        
        if let nid = channel.object(forKey: "id") as? Int {
            
            var date = Date()
            
            if let pubTime = channel.object(forKey: "ctime") as? String {
                
                date = Date(fromString: pubTime, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"))
            }
            
            realm.create(Comment.self, value: ["id":nid,"nid":new.nid,"ctimes":date], update: true)
        }
    }
}


extension Comment {
    
    func HeightByNewConstraint(_ tableView:UITableView) -> CGFloat{
        
        let width = tableView.frame.width
        
        // 计算平路内容所占高度
        let contentSize = CGSize(width: width-18-38-12-18, height: CGFloat(MAXFLOAT))
        let contentHeight = NSString(string:self.content).boundingRect(with: contentSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font3], context: nil).height
        
        // time
        let size = CGSize(width: 1000, height: 1000)
        let commentHeight = NSString(string:self.ctimes.weiboTimeDescription).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
        
        // name
        let nameHeight = NSString(string:self.uname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font4], context: nil).height
        
        return 21+21+nameHeight+commentHeight+contentHeight+12+8
    }
}
