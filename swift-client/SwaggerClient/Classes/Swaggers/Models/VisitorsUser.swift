//
// VisitorsUser.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public class VisitorsUser: JSONEncodable {

    /** \u8FD4\u56DE\u8BF7\u6C42\u72B6\u6001\u7801 */
    public var code: Int?
    public var data: VisitorsUserData?
    

    public init() {}

    // MARK: JSONEncodable
    func encodeToJSON() -> AnyObject {
        var nillableDictionary = [String:AnyObject?]()
        nillableDictionary["code"] = self.code
        nillableDictionary["data"] = self.data?.encodeToJSON()
        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
