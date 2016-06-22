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
    
    class func getAboutListArrayData(new:New?,p: String?=nil, c: String?="90",finish:((count:Int)->Void)?=nil,fail:(()->Void)?=nil){
        guard let new = new else{ fail?(); return}
        CommentAPI.nsAscGet(nid: "\(new.nid)", p: p, c: c) { (datas, error) in
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

    func HeightByNewConstraint(tableView:UITableView,hiddenY:Bool) -> CGFloat{
        
        let width = tableView.frame.width
        
        var content:CGFloat = 60
        
        if self.img?.characters.count <= 0  {
        
            let size = CGSize(width: width-17-17-7-7, height: 1000)
            
            content = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
            
            content += NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            content += 10
        }else{
            
            let size = CGSize(width: (width-34-14-81-15), height: 1000)
            
            content = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
            
            content += NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            content += 10
            
        }
        
        content = hiddenY ? content-21 : content
        
        return 10+21+17+10+7+10+content
    }
}