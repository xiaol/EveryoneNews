//
// CommentAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire



open class CommentAPI: APIBase {
    /**
     相关新闻列表
     
     - parameter nid: (query) 新闻ID 
     - parameter p: (query) 新闻ID (optional, default to 1)
     - parameter c: (query) 新闻ID (optional, default to 20)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func nsAscGet(nid: String, p: String? = nil, c: String? = nil, completion: @escaping ((_ data: AnyObject?, _ error: Error?) -> Void)) {
        nsAscGetWithRequestBuilder(nid: nid, p: p, c: c).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     相关新闻列表
     - GET /ns/asc
     - 从服务器获取 新闻相关搜索列表
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter nid: (query) 新闻ID 
     - parameter p: (query) 新闻ID (optional, default to 1)
     - parameter c: (query) 新闻ID (optional, default to 20)

     - returns: RequestBuilder<AnyObject> 
     */
    open class func nsAscGetWithRequestBuilder(nid: String, p: String? = nil, c: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/asc"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "nid": nid as Optional<AnyObject>,
            "p": p as Optional<AnyObject>,
            "c": c as Optional<AnyObject>
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     普通评论列表
     
     - parameter did: (query) 新闻 docid 
     - parameter uid: (query) 注册用户ID，提供该ID会在响应中设置该用户的点赞标记 upflag (optional)
     - parameter p: (query) 请求的页数 (optional, default to 1)
     - parameter c: (query) 每页的个数 (optional, default to 20)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func nsComsCGet(did: String, uid: String? = nil, p: String? = nil, c: String? = nil, completion: @escaping ((_ data: AnyObject?, _ error: Error?) -> Void)) {
        nsComsCGetWithRequestBuilder(did: did, uid: uid, p: p, c: c).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     普通评论列表
     - GET /ns/coms/c
     - 从服务器获取 新闻普通评论列表
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter did: (query) 新闻 docid 
     - parameter uid: (query) 注册用户ID，提供该ID会在响应中设置该用户的点赞标记 upflag (optional)
     - parameter p: (query) 请求的页数 (optional, default to 1)
     - parameter c: (query) 每页的个数 (optional, default to 20)

     - returns: RequestBuilder<AnyObject> 
     */
    open class func nsComsCGetWithRequestBuilder(did: String, uid: String? = nil, p: String? = nil, c: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/coms/c"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "did": did as Optional<AnyObject>,
            "uid": uid as Optional<AnyObject>,
            "p": p as Optional<AnyObject>,
            "c": c as Optional<AnyObject>
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     热点评论列表
     
     - parameter did: (query) 新闻 docid 
     - parameter uid: (query) 注册用户ID，提供该ID会在响应中设置该用户的点赞标记 upflag (optional)
     - parameter p: (query) 新闻ID (optional, default to 1)
     - parameter c: (query) 新闻ID (optional, default to 20)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func nsComsHGet(did: String, uid: String? = nil, p: String? = nil, c: String? = nil, completion: @escaping ((_ data: AnyObject?, _ error: Error?) -> Void)) {
        nsComsHGetWithRequestBuilder(did: did, uid: uid, p: p, c: c).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     热点评论列表
     - GET /ns/coms/h
     - 从服务器获取 新闻热点评论列表
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter did: (query) 新闻 docid 
     - parameter uid: (query) 注册用户ID，提供该ID会在响应中设置该用户的点赞标记 upflag (optional)
     - parameter p: (query) 新闻ID (optional, default to 1)
     - parameter c: (query) 新闻ID (optional, default to 20)

     - returns: RequestBuilder<AnyObject> 
     */
    open class func nsComsHGetWithRequestBuilder(did: String, uid: String? = nil, p: String? = nil, c: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/coms/h"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "did": did as Optional<AnyObject>,
            "uid": uid as Optional<AnyObject>,
            "p": p as Optional<AnyObject>,
            "c": c as Optional<AnyObject>
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     评论新闻
     
     - parameter userRegisterInfo: (body) 评论对象 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func nsComsPost(userRegisterInfo: CommectCreate, completion: @escaping ((_ error: Error?) -> Void)) {
        nsComsPostWithRequestBuilder(userRegisterInfo: userRegisterInfo).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     评论新闻
     - POST /ns/coms
     - 评论一个新闻
     
     - parameter userRegisterInfo: (body) 评论对象 

     - returns: RequestBuilder<Void> 
     */
    open class func nsComsPostWithRequestBuilder(userRegisterInfo: CommectCreate) -> RequestBuilder<Void> {
        let path = "/ns/coms"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = userRegisterInfo.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
