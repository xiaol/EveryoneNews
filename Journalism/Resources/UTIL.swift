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



// MARK: 消息机制相关名称
let CLICKTOCOMMENTVIEWCONTROLLER = "CLICKTOCOMMENTVIEWCONTROLLER" // 用户点击想要去评论视图

let IS_PLUS = UIScreen.mainScreen().bounds.size == CGSize(width: 414,height: 736) || UIScreen.mainScreen().bounds.size == CGSize(width: 736,height: 414)

// MARK: 当前APP的网络连接情况
var APPNETWORK = Reachability.NetworkStatus.ReachableViaWiFi

// MARK: 应用所需要第三方 数据结构
var UMENG_APPKEY = "507fcab25270157b37000010"

var SINA_KEY = "2528686972"
var SINA_SECRET = "c5dc1fab025c4fb9c1ad095ed2b9ebbc"
let SINA_REDIRECTURI = "https://api.weibo.com/oauth2/default.html"

let WECHAT_APPID = "wx800e0e0ff165a7ea"
let WECHAT_APPSECRET = "6bb26f47705b33d1477d11335870d03e"

let QQ_APPID = "wx23ab83263830f459"
let QQ_APPSECRET = "5ee7ec98fde8e6f1fcfea15ddb13d865"