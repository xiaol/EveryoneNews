//
// NewAndUser.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public class NewAndUser: JSONEncodable {
    /** 用户的ID */
    public var uid: String?
    /** 新闻ID */
    public var nid: String?

    public init() {}

    // MARK: JSONEncodable
    func encodeToJSON() -> AnyObject {
        var nillableDictionary = [String:AnyObject?]()
        nillableDictionary["uid"] = self.uid
        nillableDictionary["nid"] = self.nid
        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}