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

class AboutUtil: NSObject {
    
    class func getAboutListArrayData(new:New?,finish:((count:Int)->Void)?=nil,fail:(()->Void)?=nil){
        guard let new = new else{ fail?(); return}
        CommentAPI.nsAscGet(nid: "\(new.nid)") { (datas, error) in
            guard let da = datas,let data = da.objectForKey("data") as? NSArray else{ fail?();return}
            let realm = try! Realm()
            try! realm.write({
                for channel in data {
                    if let pubTime = channel.objectForKey("ptime") as? String,url = channel.objectForKey("url") as? String {
                        realm.create(About.self, value: channel, update: true)
                        realm.create(About.self, value: ["url":url,"nid":new.nid,"ptimes":NSDate(fromString: pubTime, format: DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))], update: true)
                    }
                }
            })
            finish?(count: data.count)
        }
    }
}



extension About {

    func HeightByNewConstraint(tableView:UITableView) -> CGFloat{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("aboutcell") as! AboutTableViewCell
        
        let width = tableView.frame.width
        
        var content:CGFloat = 60
        
        if self.img == nil  {
        
            let size = CGSize(width: width-17-17-7, height: 1000)
            
            content = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.contentLabel.font], context: nil).height
        }
        
//        if self.style == 0 {
//            
//            let size = CGSize(width: width-24, height: 1000)
////            
//            let titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.titleLabel.font], context: nil).height
//
//            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)], context: nil).height
//            
//            return 15+18+17+pubHeight+titleHeight
//        }else if self.style == 1{
//            
//            
//            return 15+77+17
//        }else if self.style == 2{
//            
//            let size = CGSize(width: width-24, height: 1000)
//            
//            let titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.titleLabel.font], context: nil).height
//            
//            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)], context: nil).height
//            
//            return titleHeight+15+17+8+183+pubHeight+7
//            
//        }else if self.style == 3{
//            
//            let size = CGSize(width: width-24, height: 1000)
//            
//            let titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.titleLabel.font], context: nil).height
//            
//            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)], context: nil).height
//            
//            return 77+15+7+8+titleHeight+pubHeight+17
//        }
        
        return 10+21+21+10+10+content
    }
}