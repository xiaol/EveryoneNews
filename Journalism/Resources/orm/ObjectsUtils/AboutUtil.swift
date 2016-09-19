//
//  AboutUtil.swift
//  Journalism
//
//  Created by Mister on 16/6/6.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift
import AFDateHelper
import SwaggerClient
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class AboutUtil: NSObject {
    
    class func getAboutListArrayData(_ new:New?,p: String?=nil, c: String?="90",finish:((_ count:Int)->Void)?=nil,fail:(()->Void)?=nil){
        guard let new = new else{ fail?(); return}
        CommentAPI.nsAscGet(nid: "\(new.nid)", p: p, c: c) { (datas, error) in
            guard let da = datas,let data = da.object(forKey: "data") as? NSArray else{ fail?();return}
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    if let pubTime = (channel as AnyObject).object(forKey: "ptime") as? String,let url = (channel as AnyObject).object(forKey: "url") as? String {
                        realm.create(About.self, value: channel, update: true)
                        realm.create(About.self, value: ["url":url,"nid":new.nid,"ptimes":Date(fromString: pubTime, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"))], update: true)
                        
                        let title = (channel as AnyObject).object(forKey: "title") as! String
                        let attributed = try! NSMutableAttributedString(data: title.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                        realm.create(About.self, value: ["url":url,"title":attributed.string,"htmlTitle":title], update: true)
                    }
                }
            })
            finish?(data.count)
        }
    }
}



extension About {

    func HeightByNewConstraint(_ tableView:UITableView,hiddenY:Bool) -> CGFloat{
        
        let width = tableView.frame.width
        
        var content:CGFloat = 60
        
        if self.img?.characters.count <= 0  {
        
            let size = CGSize(width: width-17-17-7-7, height: 1000)
            
            content = NSString(string:self.title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
            
            content += NSString(string:self.pname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            content += 10
        }else{
            
            let size = CGSize(width: (width-34-14-81-15), height: 1000)
            
            content = NSString(string:self.title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
            
            content += NSString(string:self.pname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            content += 10
            
        }
        
        content = hiddenY ? content-21 : content
        
        return 10+21+17+10+7+10+content
    }
}
