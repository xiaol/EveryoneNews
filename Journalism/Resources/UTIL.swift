//
//  UTIL.swift
//  Journalism
//
//  Created by Mister on 16/6/14.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import Foundation
import ReachabilitySwift

// MARK: NSUSer 存储信息名称
let SDK_SHANGHAIUSERUID = "SHANGHAISDKUSERUID" // 存储的用户Id
let SDK_SHANGHAIUSERTOKEN = "SHANGHAISDKUSERTOKEN" //  存储的用户token

// MARK: 消息机制相关名称
let CLICKTOCOMMENTVIEWCONTROLLER = "CLICKTOCOMMENTVIEWCONTROLLER" // 用户点击想要去评论视图

let IS_PLUS = UIScreen.mainScreen().bounds.size == CGSize(width: 414,height: 736) || UIScreen.mainScreen().bounds.size == CGSize(width: 736,height: 414)

// MARK: 当前APP的网络连接情况
var APPNETWORK = Reachability.NetworkStatus.ReachableViaWiFi

// MARK: 应用所需要第三方 数据结构
var UMENG_APPKEY = ""

var SINA_KEY = "2528686972"
var SINA_SECRET = "c5dc1fab025c4fb9c1ad095ed2b9ebbc"

let WECHAT_APPID = "wx23ab83263830f459"
let WECHAT_APPSECRET = "5ee7ec98fde8e6f1fcfea15ddb13d865"

let QQ_APPID = "wx23ab83263830f459"
let QQ_APPSECRET = "5ee7ec98fde8e6f1fcfea15ddb13d865"