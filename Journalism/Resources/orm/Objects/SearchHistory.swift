//
//  SearchHistory.swift
//  Journalism
//
//  Created by Mister on 16/6/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
open class SearchHistory: Object {
    
    dynamic var title = "" // 相关新闻标题
    dynamic var ctimes = Date() //创建时间
    
    override open static func primaryKey() -> String? {
        return "title"
    }
}


extension SearchHistory{

    class func delAll(){
        
        let realm = try! Realm()
        
        try! realm.write {
            
            realm.delete(realm.objects(SearchHistory.self))
        }
    }
    
    class func create(_ key:String){
        
        let realm = try! Realm()
        
        try! realm.write {
            
            realm.create(SearchHistory.self, value: ["title":key,"ctimes":Date()], update: true)
        }
    }
    
    class func getList() -> Results<SearchHistory>{
    
        let realm = try! Realm()
        
        return realm.objects(SearchHistory.self).sorted(byProperty: "ctimes", ascending: false)
    }
}
