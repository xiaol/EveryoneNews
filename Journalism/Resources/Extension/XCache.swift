//
//  XCache.swift
//  SwiftCache
//
//  Created by 赵晓东 on 16/6/8.
//  Copyright © 2016年 ZXD. All rights reserved.
//

import UIKit

class XCache: NSObject {
    /*
     读取缓存大小
     */
    static func returnCacheSize() -> String {
        return String(format: "%.2f", XCache.folderSizeAtPath(NSHomeDirectory()  + "/Library/Caches"))
    }
    /*
     计算单个文件的大小 单位MB
     path 文件的路径
     return 返回文件的大小
     */
    static func returnFileSize(path : String) -> Double {
        let manage = NSFileManager.defaultManager()
        var fileSize : Double = 0
        
        do {
            fileSize = try manage.attributesOfItemAtPath(path)["NSFileSize"] as! Double
        } catch {
        }
        return fileSize/1024/1024
    }
    /*
     遍历所有子目录 并计算文件大小
     folderPath 目录路径
     return 返回文件的大小
     */
    static func folderSizeAtPath(folderPath : String) -> Double {
        let manage = NSFileManager.defaultManager()
        if !manage.fileExistsAtPath(folderPath) {
            return 0
        }
        let childFilePath = manage.subpathsAtPath(folderPath)//遍历所有子目录
        var fileSize : Double = 0
        for path in childFilePath! {
            let fileAbsoluePath = folderPath + "/" + path
            fileSize += XCache.returnFileSize(fileAbsoluePath)
        }
        return fileSize
    }
    /*
     清除缓存
     
     */
    static func cleanCache() {
        XCache.deleteFolder(NSHomeDirectory()  + "/Library/Caches")
    }
    /*
     删除单个文件
     
     */
    static func deleteFile(path:String) {
        let manage = NSFileManager.defaultManager()
        do {
            try manage.removeItemAtPath(path)
        } catch {
        }
    }
    /*
     删除文件夹下的所有文件
     folderPath 文件夹路径
     */
    static func deleteFolder(folderPath:String) {
        let manage = NSFileManager.defaultManager()
        if !manage.fileExistsAtPath(folderPath) {
            return
        }
        let childFilePath = manage.subpathsAtPath(folderPath)//遍历所有子目录
        for path in childFilePath! {
            let fileAbsoluePath = folderPath + "/" + path
            XCache.deleteFile(fileAbsoluePath)
        }
    }
    
}
