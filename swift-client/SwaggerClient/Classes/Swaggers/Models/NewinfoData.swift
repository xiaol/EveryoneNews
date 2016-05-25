//
// NewinfoData.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public class NewinfoData: JSONEncodable {

    /** \u7528\u6237\u8BC4\u8BBA\u4FE1\u606F\u5730\u5740 */
    public var docid: String?
    /** \u6765\u6E90\u540D\u79F0 */
    public var pname: String?
    /** \u65B0\u95FB\u7684ID */
    public var nid: Int?
    /** \u9891\u9053ID */
    public var channel: Int?
    /** \u65B0\u95FB\u6765\u6E90\u5730\u5740 */
    public var purl: String?
    /** \u65B0\u95FB\u6807\u9898 */
    public var title: String?
    /** \u4EC0\u4E48\u73A9\u610F\u7684\u6570\u76EE */
    public var inum: Int?
    /** \u65B0\u95FB\u7684\u539F\u5730\u5740 */
    public var url: String?
    /** \u65B0\u95FB\u7684\u5185\u5BB9 */
    public var content: [NewinfoDataContent]?
    /** \u5173\u5FC3\u6570 */
    public var concern: Int?
    /** \u65B0\u95FB\u7684\u6807\u7B7E\u5217\u8868 */
    public var tags: [String]?
    /** \u8BC4\u8BBA\u6570\u76EE */
    public var comment: Int?
    /** \u65B0\u95FB\u53D1\u751F\u65F6\u95F4 */
    public var ptime: String?
    /** \u6536\u85CF\u6570 */
    public var collect: Int?
    

    public init() {}

    // MARK: JSONEncodable
    func encodeToJSON() -> AnyObject {
        var nillableDictionary = [String:AnyObject?]()
        nillableDictionary["docid"] = self.docid
        nillableDictionary["pname"] = self.pname
        nillableDictionary["nid"] = self.nid
        nillableDictionary["channel"] = self.channel
        nillableDictionary["purl"] = self.purl
        nillableDictionary["title"] = self.title
        nillableDictionary["inum"] = self.inum
        nillableDictionary["url"] = self.url
        nillableDictionary["content"] = self.content?.encodeToJSON()
        nillableDictionary["concern"] = self.concern
        nillableDictionary["tags"] = self.tags?.encodeToJSON()
        nillableDictionary["comment"] = self.comment
        nillableDictionary["ptime"] = self.ptime
        nillableDictionary["collect"] = self.collect
        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
