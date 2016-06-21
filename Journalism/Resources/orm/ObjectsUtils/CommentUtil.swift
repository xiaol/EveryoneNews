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
        
        CommentAPI.nsComsCGet(did: new.docidBase64(), uid: "\(ShareLUser.uid)", p: p, c: c) { (datas, error) in
            
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
        
        CommentAPI.nsComsHGet(did: new.docidBase64(), uid: "\(ShareLUser.uid)") { (datas, error) in
            
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
    
    /**
     创建评论
     
     - parameter content: 评论内容
     - parameter new:     新闻对象
     - parameter finish:  完成回调
     - parameter fail:    失败回调
     */
    class func CreateCommentMethod(content:String,new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil) {

        guard let token = ShareLUser.token else{ fail?();return }

        let time = NSDate()
        let timeStr = time.toString(format: DateFormat.Custom("yyyy-MM-dd hh:mm:ss"))
        
        let cc = CommectCreate()
        cc.content = content
        cc.docid = new.docid
        cc.ctime = timeStr
        cc.commend = 0
        cc.uid = Int32(ShareLUser.uid)
        cc.uname = ShareLUser.uname
        cc.avatar = ShareLUser.avatar
        
        let requestBudile = CommentAPI.nsComsPostWithRequestBuilder(userRegisterInfo: cc)
        requestBudile.addHeaders(["Authorization":token,"X-Requested-With":"*"])
        
        requestBudile.execute { (response, error) in
            
            guard let code = response?.body.code,id = response?.body.data else {fail?();return}
            if code != 2000 {fail?();return}
            
            let comment = Comment()
            comment.id = Int(id)
            comment.nid = new.nid
            comment.uid = ShareLUser.uid
            comment.ctime = timeStr
            comment.content = content
            comment.uname = ShareLUser.uname
            comment.avatar = ShareLUser.avatar
            comment.docid = new.docid
            comment.ctimes = time
            
            let realm = try! Realm()
            try! realm.write({
                
                new.comment += 1
                realm.add(comment)
            })
            
            finish?()
        }
    }
}

extension CommentUtil{
    // 完善评论对象
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
        
        let width = tableView.frame.width
        
        // 计算平路内容所占高度
        let contentSize = CGSize(width: width-18-38-12-18, height: CGFloat(MAXFLOAT))
        let contentHeight = NSString(string:self.content).boundingRectWithSize(contentSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font3], context: nil).height
        
        // time
        let size = CGSize(width: 1000, height: 1000)
        let commentHeight = NSString(string:self.ctimes.weiboTimeDescription).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
        
        // name
        let nameHeight = NSString(string:self.uname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font4], context: nil).height
        
        return 21+21+nameHeight+commentHeight+contentHeight+12+8
    }
}


extension CommentAndUser {

    
    convenience public init(uid: String,cid: String){
        self.init()
        self.uid = uid
        self.cid = cid
    }
}