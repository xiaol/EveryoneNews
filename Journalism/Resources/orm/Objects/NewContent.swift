//
//  NewContent.swift
//  Journalism
//
//  Created by Mister on 16/5/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift


///  频道的数据模型
public class Content: Object {

    /// 用于获取评论的 docid
    dynamic var txt: String? = nil

    /// 新闻Url
    dynamic var img: String? = nil

    /// 新闻标题
    dynamic var vid: String? = nil

}



///  频道的数据模型
public class NewContent: Object {
    /// 新闻ID
    dynamic var nid = 1
    /// 用于获取评论的 docid
    dynamic var docid = ""
    /// 新闻Url
    dynamic var url = ""
    /// 新闻标题
    dynamic var title = ""
    
    
    /// 新闻事件
    dynamic var ptime = ""
    dynamic var ptimes = NSDate()
    
    /// 新闻来源
    dynamic var pname = ""
    
    /// 来源地址
    dynamic var purl = ""
    
    /// 频道ID
    dynamic var channel = 0
    /// 正文图片数量
    dynamic var inum = 0
    
    /// 新闻标题
    dynamic var descr = ""

    
    /// 列表图格式，0、1、2、3
    dynamic var style = 0
    
    /// 图片具体数据
    let tagsList = List<StringObject>() // Should be declared with `let`
    let content = List<Content>() // Should be declared with `let`
    
    /// 收藏数
    dynamic var collect = 0
    /// 关心数
    dynamic var concern = 0
    /// 评论数
    dynamic var comment = 0
    
    /// 滑动的位置
    dynamic var scroffY: Double = 0
    /// 滑动的位置
    dynamic var height: Double = 0
    
    override public static func primaryKey() -> String? {
        return "nid"
    }
    
}

import MGTemplateEngine

extension MGTemplateEngine{

    /// 获取单例模式下的UIStoryBoard对象
    class var shareTemplateEngine:MGTemplateEngine!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:MGTemplateEngine? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = MGTemplateEngine()
                backTaskLeton.bgTask!.matcher = ICUTemplateMatcher(templateEngine: backTaskLeton.bgTask)
            })
            
            return backTaskLeton.bgTask
        }
    }
}


extension NewContent{

    func heights(h:CGFloat){
        let realm = try! Realm()
        try! realm.write {
            self.height = Double(h)
        }
    }
    
    func scroffY(y:CGFloat){
        let realm = try! Realm()
        try! realm.write {
            self.scroffY = Double(y)
        }
    }
    
    func getHtmlResourcesString() -> String{
    
        var body = ""
        
        let title = "#title{font-size:\(UIFont.a_font9.pointSize)px;}"
        let subtitle = "#subtitle{font-size:\(UIFont.a_font8.pointSize)px;}"
        let bodysection = "#body_section{font-size:\(UIFont.a_font3.pointSize)px;}"
        
        for conten in self.content{
            
            if let img = conten.img {
                
//                
//                let res = img.grep("_(\\d+)X(\\d+).")
//                
//                let width = res.captures[1]
//                let height = res.captures[2]
////
//                
//                body += "<p><img data-src=\"\(img)\"  style = \"display:block;width:\(width);height:\(height);background-color:#f6f6f6;\" class=\"lazyload  img-responsive center-block\"  ></p>"
                
//                print(res)
                
                body += "<p><img data-src=\"\(img)\" class=\"lazyload img-responsive center-block\"src=\"home.png\" ></p>"
            }
            
            if let vid = conten.vid {
                
                var str = vid
                
                if str.containsString(" src=\"https://v.qq.com/iframe/preview.html") {
                
                    let rand = NSString(string: str).rangeOfString(" src=\"https://v.qq.com/iframe/preview.html")
                    
                    str = NSString(string: str).stringByReplacingCharactersInRange(rand, withString: " src=\"http://v.qq.com/iframe/player.html")
                }
                
                if str.containsString("allowfullscreen=\"\"") {
                    
                    let rand = NSString(string: str).rangeOfString("allowfullscreen=\"\"")
                    
                    str = NSString(string: str).stringByReplacingCharactersInRange(rand, withString: "allowfullscreen=\"\"")
                }
                
                while str.containsString("width=") {
                    
                    let rand = NSString(string: str).rangeOfString("width=")
                    
                    str = NSString(string: str).stringByReplacingCharactersInRange(rand, withString: "")
                }
                while str.containsString("height=") {
                    
                    let rand = NSString(string: str).rangeOfString("height=")
                    
                    str = NSString(string: str).stringByReplacingCharactersInRange(rand, withString: "")
                }
                
                body += "<div id=\"video\">\(str)</div>"
            }
            
            if let txt = conten.txt {
                body += "<p>\(txt)</p>"
            }
        }
        
        
        body+="<p style=\"font-size:13px;\" align=\"right\"><span><a href =\"\(self.purl)\">原文链接</a></span></p>"
        
        let templatePath = NSBundle.mainBundle().pathForResource("content_template", ofType: "html")
        
        let comment = self.comment > 0 ? "   \(self.comment)评" : ""
        
        let variables = ["title":self.title,"source":self.pname,"ptime":self.ptime,"theme":"normal","body":body,"comment":comment,"titleStyle":title,"subtitleStyle":subtitle,"bodysectionStyle":bodysection]
        
        let result = MGTemplateEngine.shareTemplateEngine.processTemplateInFileAtPath(templatePath, withVariables: variables)
        
        return result
    }
    
    
    func getSkPhotos() -> [SKPhoto]{
    
        var res = [SKPhoto]()
        
        for conten in self.content{
        
            if let img = conten.img {
                
                res.append(SKPhoto.photoWithImageURL(img))
            }
        }
        
        return res
    }
}