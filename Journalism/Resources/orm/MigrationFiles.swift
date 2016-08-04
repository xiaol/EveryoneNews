//
//  MigrationFiles.swift
//  Journalism
//
//  Created by Mister on 16/7/8.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

class RealmMigration {
    
    /**
     版本迁移
     
    V0 －> v1
    增加 New 里的 Search Title 标题
     
    */
    static func MigrationConfig(){
    
        let config = Realm.Configuration(schemaVersion: 2, migrationBlock: { (migration, oldSchemaVersion) in
            
            if oldSchemaVersion < 1 {
            
                migration.enumerate(New.className(), { (oldObject, newObject) in
                  
                    newObject!["searchTitle"] = ""
                })
            }
            
            if oldSchemaVersion < 1 {
                
                migration.enumerate(New.className(), { (oldObject, newObject) in
                    
                    newObject!["rtype"] = 0
                })
            }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
}