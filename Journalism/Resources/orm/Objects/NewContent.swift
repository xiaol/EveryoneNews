//
//  NewContent.swift
//  Journalism
//
//  Created by Mister on 16/5/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
open class Content: Object {

    /// 用于获取评论的 docid
    dynamic var txt: String? = nil

    /// 新闻Url
    dynamic var img: String? = nil

    /// 新闻标题
    dynamic var vid: String? = nil

}



///  频道的数据模型
open class NewContent: Object {
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
    dynamic var ptimes = Date()
    
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
    
    override open static func primaryKey() -> String? {
        return "nid"
    }
    
}

import MGTemplateEngine

extension MGTemplateEngine{

    /// 获取单例模式下的UIStoryBoard对象
    static var shareTemplateEngine:MGTemplateEngine!{
        
        let templateEngine = MGTemplateEngine()
        
        templateEngine.matcher = ICUTemplateMatcher(templateEngine: templateEngine)
        
        return templateEngine
    }
}

import Alamofire
import PINRemoteImage

extension String{

    /**
     处理视频文件
     
     - returns: 处理完成的视频文件
     */
    fileprivate func HandleForVideoHtml() -> String{
    
        return self.replaceRegex("(preview.html)", with: "player.html")
            .replaceRegex("(allowfullscreen=\"\")", with: "")
            .replaceRegex("(class=\"video_iframe\")", with: "")
            .replaceRegex("(width=[0-9]+&)", with: "")
            .replaceRegex("(height=[0-9]+&)", with: "")
            .replaceRegex("(height=\"[0-9]+\")", with: "")
            .replaceRegex("(width=\"[0-9]+\")", with: "")
            .replaceRegex("(&?amp;)", with: "")
            .replaceRegex("(auto=0)", with: "")
//            .replaceRegex("(frameborder=\"[0-9]+\")", with: "")
    }
    
    
    
    fileprivate func tryToDownloadImageUrl(){
    
        guard let url = URL(string: self) else {return}
        
        if APPNETWORK == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi) {

            PINRemoteImageManager.shared().downloadImage(with: url,options: PINRemoteImageManagerDownloadOptions.downloadOptionsIgnoreGIFs, completion: { (result) in
                
//                PINRemoteImageManager.sharedImageManager().cache.diskCache.setObject(<#T##object: NSCoding##NSCoding#>, forKey: <#T##String#>)
                
                
                PINRemoteImageManager.shared().cache.object(forKey: self, block: { (cache, str, img) in
                    
                    
                    print(cache,"=asxasxasx=",str,"===-====",img)
                })
                
                
//                PINRemoteImageManager.sharedImageManager().cache.diskCache.fileURLForKey(self, block: { (cache, str, cod, url) in
//                    
//                    print(str,"---",cod,"---",url)
//                })
                
//                print(PINRemoteImageManager.sharedImageManager().cache.diskCache.fileURLForKey(url.absoluteString))
            })
        }
    }
}


extension NewContent{
    
    func scroffY(_ y:CGFloat){
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
                
                var str = "<div class = \"imgDiv\">&img&</div>"
                
//                var
                
                let res = img.grep("_(\\d+)X(\\d+).").captures
                
                if img.hasSuffix(".gif") {
                    
                    str = "<div class = \"imgDiv\">&span&&img&</div>" // 进度条
                }
                
                if res.count > 0 {
                    
                    if img.hasSuffix(".gif") {

                        str = str.replaceRegex("(&span&)",  with: "<div style=\"height:2px;width:\(res[1])px\" class=\"progress img-responsive center-block customProgress\"><div class=\"progress-bar customProgressBar\" role=\"progressbar\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 0%;\"> <span class=\"sr-only\">40% 完成</span> </div> </div>")
                        
                    }
                    
                    str = str.replaceRegex("(&img&)", with: "<img style=\"display: flex; \" data-src=\"\(img)\" w=\(res[1]) h=\(res[2]) class=\"img-responsive center-block\">")
                    
                }else{
                    
                    str = str.replaceRegex("(&img&)", with: "<img style=\"display: flex; \" data-src=\"\(img)\" class=\"img-responsive center-block\">")
                    
                    str = str.replaceRegex("(&span&)", with: "<div style=\"height:2px;\" class=\"progress customProgress\"><div class=\"progress-bar customProgressBar\" role=\"progressbar\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 0%;\"> </div> </div>")
                }
                
                body += str
            }
            
            if let vid = conten.vid {
                
                print("之前：",vid)
                
                let str = vid.HandleForVideoHtml()
                
                print("之后：",str)
                
                body += "<div id=\"video\">\(str)</div>"
            }
            
            if let txt = conten.txt {
                
                body += "<p>\(txt)</p>"
            }
        }
        
        
//        body+="<br/><hr style=\"height:1.5px;border:none;border-top:1px dashed #999999;\" />"
//        body+="<p style=\"font-size:12px;color:#999999\" align=\"center\" color＝\"#999999\"><span>原网页由 奇点资讯 转码以便移动设备阅读</span></p>"
//        body+="<p style=\"font-size:12px;\" align=\"center\"><span><a style=\"color:#999999;text-decoration:underline\" href =\"\(self.purl)\">查看原文</a></span></p>"
        
        let templatePath = Bundle.main.path(forResource: "content_template", ofType: "html")
        
        let comment = self.comment > 0 ? "   \(self.comment)评" : ""
        
        let variables = ["title":self.title,"source":self.pname,"ptime":self.ptime,"theme":"normal","body":body,"comment":comment,"titleStyle":title,"subtitleStyle":subtitle,"bodysectionStyle":bodysection]
        
        let result = MGTemplateEngine.shareTemplateEngine.processTemplateInFile(atPath: templatePath, withVariables: variables)
        
        return result!
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
