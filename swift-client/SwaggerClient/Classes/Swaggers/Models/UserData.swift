//
// UserData.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public class UserData: JSONEncodable {
    /** 用户的类型 */
    public var utype: Int32?
    /** 用户的id 唯一标示 */
    public var uid: Int32?
    /** 用户名称 */
    public var uname: String?
    /** 用户头像 */
    public var avatar: String?
    /** 用户的 token */
    public var password: String?
    /** 用户的频道列表 */
    public var channel: [String]?

    public init() {}

    // MARK: JSONEncodable
    func encodeToJSON() -> AnyObject {
        var nillableDictionary = [String:AnyObject?]()
        nillableDictionary["utype"] = self.utype?.encodeToJSON()
        nillableDictionary["uid"] = self.uid?.encodeToJSON()
        nillableDictionary["uname"] = self.uname
        nillableDictionary["avatar"] = self.avatar
        nillableDictionary["password"] = self.password
        nillableDictionary["channel"] = self.channel?.encodeToJSON()
        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}