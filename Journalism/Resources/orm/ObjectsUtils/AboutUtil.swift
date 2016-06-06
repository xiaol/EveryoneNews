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