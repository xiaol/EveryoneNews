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
    static func returnFileSize(_ path : String) -> Double {
        let manage = FileManager.default
        var fileSize : Double = 0
        
//        do {
//            fileSize = try manage.attributesOfItem(atPath: path)["NSFileSize"] as! Double
//        } catch {
//        }
        return fileSize/1024/1024
    }
    /*
     遍历所有子目录 并计算文件大小
     folderPath 目录路径
     return 返回文件的大小
     */
    static func folderSizeAtPath(_ folderPath : String) -> Double {
        let manage = FileManager.default
        if !manage.fileExists(atPath: folderPath) {
            return 0
        }
        let childFilePath = manage.subpaths(atPath: folderPath)//遍历所有子目录
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
    static func deleteFile(_ path:String) {
        let manage = FileManager.default
        do {
            try manage.removeItem(atPath: path)
        } catch {
        }
    }
    /*
     删除文件夹下的所有文件
     folderPath 文件夹路径
     */
    static func deleteFolder(_ folderPath:String) {
        let manage = FileManager.default
        if !manage.fileExists(atPath: folderPath) {
            return
        }
        let childFilePath = manage.subpaths(atPath: folderPath)//遍历所有子目录
        for path in childFilePath! {
            let fileAbsoluePath = folderPath + "/" + path
            XCache.deleteFile(fileAbsoluePath)
        }
    }
    
}
