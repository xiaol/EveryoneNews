//
//  UTIL.swift
//  Journalism
//
//  Created by Mister on 16/6/14.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import Alamofire
import Foundation



// MARK: 消息机制相关名称
let CLICKTOCOMMENTVIEWCONTROLLER = "CLICKTOCOMMENTVIEWCONTROLLER" // 用户点击想要去评论视图
let USERCOMMENTNOTIFITION = "USERCOMMENTNOTIFITION" // 成功评论
let USERNEDDLOGINTHENCANDOSOMETHING = "USERNEDDLOGINTHENCANDOSOMETHING" // 用户必须注册才可以继续一些操作
let COLLECTEDNEWORNOCOLLECTEDNEW = "COLLECTEDNEWORNOCOLLECTEDNEW" // 改变新闻的收藏状态
let CONCERNNEWORNOCOLLECTEDNEW = "CONCERNNEWORNOCOLLECTEDNEW" // 改变新闻的关心状态concern
let CHANNELONEISREFRESHFINISH = "CHANNELONEISREFRESHFINISH" // 起点频道刷新完成
let USERFOCUSPNAMENOTIFITION = "USERFOCUSPNAMENOTIFITION" // 用户关注某一个频道发生的事

let IS_PLUS = UIScreen.main.bounds.size == CGSize(width: 414,height: 736) || UIScreen.main.bounds.size == CGSize(width: 736,height: 414)

// MARK: 当前APP的网络连接情况
var APPNETWORK = NetworkReachabilityManager.NetworkReachabilityStatus.reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi)

// MARK: 应用所需要第三方 数据结构
var UMENG_APPKEY = "57761ecbe0f55a40b400151e"

var SINA_KEY = "2528686972"
var SINA_SECRET = "c5dc1fab025c4fb9c1ad095ed2b9ebbc"
let SINA_REDIRECTURI = "https://api.weibo.com/oauth2/default.html"

let WECHAT_APPID = "wx800e0e0ff165a7ea"
let WECHAT_APPSECRET = "6bb26f47705b33d1477d11335870d03e"

let QQ_APPID = "987333155"
let QQ_APPSECRET = "558b2ec267e58e64a00009db"
