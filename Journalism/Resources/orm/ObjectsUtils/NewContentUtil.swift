//
//  NewContentUtil.swift
//  Journalism
//
//  Created by Mister on 16/5/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift
import SwaggerClient

class NewContentUtil: NSObject {
    
    class func LoadNewsContentData(_ nid:Int,finish:((_ newCon:NewContent)->Void)?=nil,fail:(()->Void)?=nil){
        
        let realm = try! Realm()
        
        NewAPI.nsConGet(nid: "\(nid)") { (data, error) in
            
            guard let da = data, let datas = da.object(forKey: "data") as? NSDictionary else{  fail?();return}
            
            try! realm.write({
                
                realm.create(NewContent.self, value: datas, update: true)
                
                self.AnalysisPutTimeAndImageList(datas, realm: realm)
            })
            
            let newContengt = realm.objects(NewContent.self).filter("nid = \(nid)").first
            
            finish?(newContengt!)
        }
    }
    
    
    fileprivate class func AnalysisPutTimeAndImageList(_ channel:NSDictionary,realm:Realm){
        
        if let nid = channel.object(forKey: "nid") as? Int {

            if let imageList = channel.object(forKey: "tags") as? NSArray {
                
                var array = [StringObject]()
                
                imageList.enumerateObjects({ (imageUrl, _, _) in
                    
                    let sp = StringObject()
                    sp.value = imageUrl as! String
                    array.append(sp)
                })
                
                realm.create(NewContent.self, value: ["nid":nid,"tags":array], update: true)
            }
        }
    }
}



