//
//  New.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift


public class StringObject: Object {
    dynamic var value = ""
}


///  频道的数据模型
public class New: Object {
    
    dynamic var nid = 1 /// 新闻ID
    dynamic var url = ""  /// 新闻Url
    dynamic var docid = "" /// 用于获取评论的 docid
    dynamic var title = "" /// 新闻标题
    dynamic var ptime = ""  /// 新闻事件
    dynamic var ptimes = NSDate()
    dynamic var pname = ""  /// 新闻来源
    dynamic var purl = "" /// 来源地址
    dynamic var channel = 0 /// 频道ID
    dynamic var collect = 0 /// 收藏数
    dynamic var concern = 0 /// 关心数
    dynamic var comment = 0 /// 评论数
    dynamic var style = 0 /// 列表图格式，0、1、2、3
    let imgsList = List<StringObject>() /// 图片具体数据
    
    
    dynamic var province = "" // 省
    dynamic var city = "" // 城市
    dynamic var district = "" // 区
    
    dynamic var isdelete = 0 // 区
    
    /**
     标识 新闻是不是被阅读 0 未阅读 1 已经阅读
     如果该新闻已经被阅读，那么在展示他的时候，就应该对其标题的色值进行浅色处理
     */
    dynamic var isread = 0 // 是否阅读
    
    /**
     标识 新闻是不是热点新闻， 0 为非热点新闻 1是热点新闻 默认为非热点新闻
     如果该新闻是一个假的新闻，那么在这个新闻应该被展示的UItablVIewCell 就应该显示为对应的 点击刷新新闻 Cell
     */
    dynamic var ishotnew = 0 /// 是不是热点新闻
    
    /**
     标识 该新闻是不是 加的数据，0 不是。 1 是。 默认为 不是假新闻 即 0
     如果该新闻是一个假的新闻，那么在这个新闻应该被展示的UItablVIewCell 就应该显示为对应的 点击刷新新闻 Cell
     
     在用户进行数据刷新的时候，首先会删除所有的假新闻。之后判断用户是否需要生成假新闻，如果需要那么在判断所加载的新闻的个数
     如果个数符合要求，那么就会加入一个假新闻。假新闻要在数据加载前的那一条数据之前添加，所以要判断好时间。
     默认的区分假新闻的id为频道id 但是如果频道为  奇点 那么他的ID 为…………  忘却了。。。大概是－1
     这样在展示的时候就可以做到有假新闻的展示了
     */
    dynamic var isidentification = 0 /// 是不是热点新闻
    
    /**
     标识 新闻的收藏状态。 0 未收藏 1 已收藏 默认为 未收藏
     新闻的是否收藏状态，如果是0 的话，说明该新闻没有被收藏。如果已经被收藏，这也没什么影响
     */
    dynamic var iscollected = 0 // 是否收藏
    
    /**
     标识 是不是搜索出来的。 0 不是 1 是 默认为 不是
     首先我们要做的就是在搜索之前，将所有搜索状态未 1 的，设置为 0.
     但是如果用户在上拉刷新的时候是不需要进行这个设置的。
     */
    dynamic var issearch = 0 // 是否收藏
    
    override public static func primaryKey() -> String? {
        return "nid"
    }
}

import PINRemoteImage

extension New{

    
    class func deleSearch(){
    
        let realm = try! Realm()
        
        try! realm.write({
            realm.objects(New).filter("issearch = 1").forEach({ (new) in
                new.issearch = 0
            })
        })
    }
    
    
    /**
     获取搜素新闻
     
     - returns: <#return value description#>
     */
    class func searchArray() -> Results<New>{
        
        let realm = try! Realm()
        
        return realm.objects(New.self).filter("issearch = 1").sorted("ptimes", ascending: false)
    }
    
    /**
     获取当前新闻的详情对象
     
     - returns: 新闻详情
     */
    func getNewContentObject() -> NewContent?{
    
        let realm = try! Realm()
        
        return realm.objects(NewContent.self).filter("nid = \(self.nid)").first
    }
    
    /**
     讲新闻设置为已读
     */
    func isRead(){
        
        let realm = try! Realm()
        
        try! realm.write {
            
            self.isread = 1
        }
    }
    
    /**
     获取新闻的分享链接
     
     - returns: <#return value description#>
     */
    func shareUrl() -> String{
    
        return "http://deeporiginalx.com/news.html?type=0&nid=\(self.nid)"
    }
    
    /**
      获取新闻的第一张图片
     
     - parameter finish: 完成回调
     */
    func firstImage(finish:((image:UIImage)->Void)) {
        
        let realm = try! Realm()
        
        let newContengt = realm.objects(NewContent.self).filter("nid = \(self.nid)").first
        
        guard let cons = newContengt?.content else {return finish(image: UIImage(named: "占位字符")!)}
        
        for con in cons{
        
            if let img = con.img,let url = NSURL(string: img) {
            
                PINRemoteImageManager.sharedImageManager().downloadImageWithURL(url, completion: { (result) in
                    
                    if result.image == nil {
                    
                        return finish(image: UIImage(named: "占位字符")!)
                    }
                    
                    return finish(image: result.image!)
                })
                
                return
            }
        }
        
        return finish(image: UIImage(named: "占位字符")!)
    }
}