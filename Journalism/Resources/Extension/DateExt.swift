//
//  DateExt.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//
import Foundation

public extension NSDate {
    
    //    /**
    //     Date year
    //     */
    //    public var year : Int {
    //        get {
    //            return getComponent(NSCalendarUnit.Year)
    //        }
    //    }
    //
    //    /**
    //     Date month
    //     */
    //    public var month : Int {
    //        get {
    //            return getComponent(NSCalendarUnit.Month)
    //        }
    //    }
    
    /**
     English form of the month
     */
    //    enum Mouth: Int {
    //        case January = 1, February, March, April, May, June, July, August, September, October, November, December
    //    }
    public var en_month : String {
        get {
            let month = getComponent(NSCalendarUnit.Month)
            
            switch month {
            case 1:
                return "January"
            case 2:
                return "February"
            case 3:
                return "March"
            case 4:
                return "April"
            case 5:
                return "May"
            case 6:
                return "June"
            case 7:
                return "July"
            case 8:
                return "August"
            case 9:
                return "September"
            case 10:
                return "October"
            case 11:
                return "November"
            case 12:
                return "December"
            default:
                return "\(month) not one month"
            }
        }
    }
    
    /**
     Date days
     */
    public var days : Int {
        get {
            return getComponent(NSCalendarUnit.Day)
        }
    }
    
    /**
     Date hours
     */
    public var hours : Int {
        
        get {
            return getComponent(NSCalendarUnit.Hour)
        }
    }
    
    /**
     Date minuts
     */
    public var minutes : Int {
        get {
            return getComponent(NSCalendarUnit.Minute)
        }
    }
    
    /**
     Date seconds
     */
    public var seconds : Int {
        get {
            return getComponent(NSCalendarUnit.Second)
        }
    }
    
    /**
     Returns the value of the NSDate component
     
     :param: component NSCalendarUnit
     :returns: the value of the component
     */
    
    public func getComponent (component : NSCalendarUnit) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(component, fromDate: self)
        
        return components.valueForComponent(component)
    }
    
    /// 将微博日期格式的字符串转换成 NSDate
    class func weiboTime(weiboTimeFormat: String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        return formatter.dateFromString(weiboTimeFormat)
    }
    
    
    /**
     根据当前日期，返回对应的格式描述文字
     
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    var weiboTimeDescription: String {
        
        let canlender = NSCalendar.currentCalendar()
        // 当天
        if canlender.isDateInToday(self) {
            // 时间差
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            return "\(delta / 3600) 小时前"
        }
        
        // 往日
        var fmt = " HH:mm"
        
        if canlender.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            
            fmt = "MM-dd" + fmt
            // 判断两个日期之间是否有一个完整的`年度`差
            let coms = canlender.components(.Year, fromDate: self, toDate: NSDate(), options: [])
            
            if coms.year != 0 {
                fmt = "yyyy-" + fmt
            }
        }
        // 日期转换
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en")
        df.dateFormat = fmt
        
        return df.stringFromDate(self)
    }
    
}

func NSDateTimeAgoLocalizedStrings(key: String) -> String {
    
    let resourceURL = NSBundle.mainBundle().resourceURL
    let URL = resourceURL?.URLByAppendingPathComponent("NSDateTimeAgo.bundle")
    let bundle = NSBundle(URL: URL!)
    
    //    let resourcePath = NSBundle.mainBundle().resourcePath
    //    let path = resourcePath?.stringByAppendingPathComponent("NSDateTimeAgo.bundle")
    //    let bundle = NSBundle(path: path!)
    
    return NSLocalizedString(key, tableName: "NSDateTimeAgo", bundle: bundle!, comment: "")
}


let kMinute = 60
let kDay = kMinute * 24
let kWeek = kDay * 7
let kMonth = kDay * 31
let kYear = kDay * 365

extension NSDate {
    
    // shows 1 or two letter abbreviation for units.
    // does not include 'ago' text ... just {value}{unit-abbreviation}
    // does not include interim summary options such as 'Just now'
    var timeAgoSimple: String {
        
        let now = NSDate()
        let deltaSeconds = Int(fabs(timeIntervalSinceDate(now)))
        let deltaMinutes = deltaSeconds / 60
        
        var value: Int!
        
        if deltaSeconds < kMinute {
            // Seconds
            return stringFromFormat("%%d%@s", withValue: deltaSeconds)
        } else if deltaMinutes < kMinute {
            // Minutes
            return stringFromFormat("%%d%@m", withValue: deltaMinutes)
        } else if deltaMinutes < kDay {
            // Hours
            value = Int(floor(Float(deltaMinutes / kMinute)))
            return stringFromFormat("%%d%@h", withValue: value)
        } else if deltaMinutes < kWeek {
            // Days
            value = Int(floor(Float(deltaMinutes / kDay)))
            return stringFromFormat("%%d%@d", withValue: value)
        } else if deltaMinutes < kMonth {
            // Weeks
            value = Int(floor(Float(deltaMinutes / kWeek)))
            return stringFromFormat("%%d%@w", withValue: value)
        } else if deltaMinutes < kYear {
            // Month
            value = Int(floor(Float(deltaMinutes / kMonth)))
            return stringFromFormat("%%d%@mo", withValue: value)
        }
        
        // Years
        value = Int(floor(Float(deltaMinutes / kYear)))
        return stringFromFormat("%%d%@yr", withValue: value)
    }
    
    var timeAgo: String {
        
        let now = NSDate()
        let deltaSeconds = Int(fabs(timeIntervalSinceDate(now)))
        let deltaMinutes = deltaSeconds / 60
        
        var value: Int!
        
        if deltaSeconds < 5 {
            // Just Now
            return NSDateTimeAgoLocalizedStrings("Just now")
        } else if deltaSeconds < kMinute {
            // Seconds Ago
            return stringFromFormat("%%d %@seconds ago", withValue: deltaSeconds)
        } else if deltaSeconds < 120 {
            // A Minute Ago
            return NSDateTimeAgoLocalizedStrings("A minute ago")
        } else if deltaMinutes < kMinute {
            // Minutes Ago
            return stringFromFormat("%%d %@minutes ago", withValue: deltaMinutes)
        } else if deltaMinutes < 120 {
            // An Hour Ago
            return NSDateTimeAgoLocalizedStrings("An hour ago")
        } else if deltaMinutes < kDay {
            // Hours Ago
            value = Int(floor(Float(deltaMinutes / kMinute)))
            return stringFromFormat("%%d %@hours ago", withValue: value)
        } else if deltaMinutes < (kDay * 2) {
            // Yesterday
            return NSDateTimeAgoLocalizedStrings("Yesterday")
        } else if deltaMinutes < kWeek {
            // Days Ago
            value = Int(floor(Float(deltaMinutes / kDay)))
            return stringFromFormat("%%d %@days ago", withValue: value)
        } else if deltaMinutes < (kWeek * 2) {
            // Last Week
            return NSDateTimeAgoLocalizedStrings("Last week")
        } else if deltaMinutes < kMonth {
            // Weeks Ago
            value = Int(floor(Float(deltaMinutes / kWeek)))
            return stringFromFormat("%%d %@weeks ago", withValue: value)
        } else if deltaMinutes < (kDay * 61) {
            // Last month
            return NSDateTimeAgoLocalizedStrings("Last month")
        } else if deltaMinutes < kYear {
            // Month Ago
            value = Int(floor(Float(deltaMinutes / kMonth)))
            return stringFromFormat("%%d %@months ago", withValue: value)
        } else if deltaMinutes < (kDay * (kYear * 2)) {
            // Last Year
            return NSDateTimeAgoLocalizedStrings("Last Year")
        }
        
        // Years Ago
        value = Int(floor(Float(deltaMinutes / kYear)))
        return stringFromFormat("%%d %@years ago", withValue: value)
        
    }
    
    func stringFromFormat(format: String, withValue value: Int) -> String {
        
        let localeFormat = String(format: format, getLocaleFormatUnderscoresWithValue(Double(value)))
        
        return String(format: NSDateTimeAgoLocalizedStrings(localeFormat), value)
    }
    
    func getLocaleFormatUnderscoresWithValue(value: Double) -> String {
        
        let localeCode = NSLocale.preferredLanguages().first
        
        if localeCode == "ru" {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10
            
            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            
            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        
        return ""
    }
    
}