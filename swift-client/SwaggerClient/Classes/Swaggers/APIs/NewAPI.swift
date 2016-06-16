//
// NewAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire



public class NewAPI: APIBase {
    /**
     新闻收藏列表
     
     - parameter uid: (query) 注册用户ID，提供该ID会在响应中设置该用户的点赞标记 upflag (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsAuColsGet(uid uid: String? = nil, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        nsAuColsGetWithRequestBuilder(uid: uid).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     新闻收藏列表
     - GET /ns/au/cols
     - 获取用户收藏列表
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter uid: (query) 注册用户ID，提供该ID会在响应中设置该用户的点赞标记 upflag (optional)

     - returns: RequestBuilder<AnyObject> 
     */
    public class func nsAuColsGetWithRequestBuilder(uid uid: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/au/cols"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "uid": uid
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     取消关心新闻
     
     - parameter userRegisterInfo: (body) 用户取消点赞信息 
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsCocsDelete(userRegisterInfo userRegisterInfo: NewAndUser, completion: ((data: InlineResponse200?, error: ErrorType?) -> Void)) {
        nsCocsDeleteWithRequestBuilder(userRegisterInfo: userRegisterInfo).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     取消关心新闻
     - DELETE /ns/cocs
     - 对某一个新闻评论取消收藏
     - examples: [{contentType=application/json, example={
  "code" : 123,
  "data" : 123
}}]
     
     - parameter userRegisterInfo: (body) 用户取消点赞信息 

     - returns: RequestBuilder<InlineResponse200> 
     */
    public class func nsCocsDeleteWithRequestBuilder(userRegisterInfo userRegisterInfo: NewAndUser) -> RequestBuilder<InlineResponse200> {
        let path = "/ns/cocs"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = userRegisterInfo.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<InlineResponse200>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     关心新闻
     
     - parameter userRegisterInfo: (body) 用户取消点赞信息 
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsCocsPost(userRegisterInfo userRegisterInfo: NewAndUser, completion: ((data: InlineResponse200?, error: ErrorType?) -> Void)) {
        nsCocsPostWithRequestBuilder(userRegisterInfo: userRegisterInfo).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     关心新闻
     - POST /ns/cocs
     - 对某一个新闻表示关心
     - examples: [{contentType=application/json, example={
  "code" : 123,
  "data" : 123
}}]
     
     - parameter userRegisterInfo: (body) 用户取消点赞信息 

     - returns: RequestBuilder<InlineResponse200> 
     */
    public class func nsCocsPostWithRequestBuilder(userRegisterInfo userRegisterInfo: NewAndUser) -> RequestBuilder<InlineResponse200> {
        let path = "/ns/cocs"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = userRegisterInfo.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<InlineResponse200>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     取消收藏新闻
     
     - parameter userRegisterInfo: (body) 用户取消点赞信息 
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsColsDelete(userRegisterInfo userRegisterInfo: NewAndUser, completion: ((data: InlineResponse2001?, error: ErrorType?) -> Void)) {
        nsColsDeleteWithRequestBuilder(userRegisterInfo: userRegisterInfo).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     取消收藏新闻
     - DELETE /ns/cols
     - 对某一个新闻评论取消收藏
     - examples: [{contentType=application/json, example={
  "code" : 123,
  "data" : 123
}}]
     
     - parameter userRegisterInfo: (body) 用户取消点赞信息 

     - returns: RequestBuilder<InlineResponse2001> 
     */
    public class func nsColsDeleteWithRequestBuilder(userRegisterInfo userRegisterInfo: NewAndUser) -> RequestBuilder<InlineResponse2001> {
        let path = "/ns/cols"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = userRegisterInfo.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<InlineResponse2001>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     收藏新闻
     
     - parameter userRegisterInfo: (body) 用户取消点赞信息 
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsColsPost(userRegisterInfo userRegisterInfo: NewAndUser, completion: ((data: InlineResponse2001?, error: ErrorType?) -> Void)) {
        nsColsPostWithRequestBuilder(userRegisterInfo: userRegisterInfo).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     收藏新闻
     - POST /ns/cols
     - 对某一个新闻评论进行收藏
     - examples: [{contentType=application/json, example={
  "code" : 123,
  "data" : 123
}}]
     
     - parameter userRegisterInfo: (body) 用户取消点赞信息 

     - returns: RequestBuilder<InlineResponse2001> 
     */
    public class func nsColsPostWithRequestBuilder(userRegisterInfo userRegisterInfo: NewAndUser) -> RequestBuilder<InlineResponse2001> {
        let path = "/ns/cols"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = userRegisterInfo.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<InlineResponse2001>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     新闻详情页
     
     - parameter nid: (query) 新闻ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsConGet(nid nid: String, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        nsConGetWithRequestBuilder(nid: nid).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     新闻详情页
     - GET /ns/con
     - 从服务器获取 新闻详情页
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter nid: (query) 新闻ID 

     - returns: RequestBuilder<AnyObject> 
     */
    public class func nsConGetWithRequestBuilder(nid nid: String) -> RequestBuilder<AnyObject> {
        let path = "/ns/con"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "nid": nid
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     新闻列表页加载
     
     - parameter cid: (query) 频道id 
     - parameter tcr: (query) 起始时间，13位时间戳 
     - parameter tmk: (query) 是(1)否(0)模拟实时发布时间(部分新闻的发布时间修改为5分钟以内) (optional, default to 1)
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter c: (query) 条数 (optional, default to 20)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsFedLGet(cid cid: String, tcr: String, tmk: String? = nil, p: String? = nil, c: String? = nil, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        nsFedLGetWithRequestBuilder(cid: cid, tcr: tcr, tmk: tmk, p: p, c: c).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     新闻列表页加载
     - GET /ns/fed/l
     - 从服务器获取 新闻-列表页加载
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter cid: (query) 频道id 
     - parameter tcr: (query) 起始时间，13位时间戳 
     - parameter tmk: (query) 是(1)否(0)模拟实时发布时间(部分新闻的发布时间修改为5分钟以内) (optional, default to 1)
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter c: (query) 条数 (optional, default to 20)

     - returns: RequestBuilder<AnyObject> 
     */
    public class func nsFedLGetWithRequestBuilder(cid cid: String, tcr: String, tmk: String? = nil, p: String? = nil, c: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/fed/l"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "cid": cid,
            "tcr": tcr,
            "tmk": tmk,
            "p": p,
            "c": c
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     新闻列表页刷新
     
     - parameter cid: (query) 频道id 
     - parameter tcr: (query) 起始时间，13位时间戳 
     - parameter tmk: (query) 是(1)否(0)模拟实时发布时间(部分新闻的发布时间修改为5分钟以内) (optional, default to 1)
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter c: (query) 条数 (optional, default to 20)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsFedRGet(cid cid: String, tcr: String, tmk: String? = nil, p: String? = nil, c: String? = nil, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        nsFedRGetWithRequestBuilder(cid: cid, tcr: tcr, tmk: tmk, p: p, c: c).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     新闻列表页刷新
     - GET /ns/fed/r
     - 从服务器获取 新闻-列表页刷新
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter cid: (query) 频道id 
     - parameter tcr: (query) 起始时间，13位时间戳 
     - parameter tmk: (query) 是(1)否(0)模拟实时发布时间(部分新闻的发布时间修改为5分钟以内) (optional, default to 1)
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter c: (query) 条数 (optional, default to 20)

     - returns: RequestBuilder<AnyObject> 
     */
    public class func nsFedRGetWithRequestBuilder(cid cid: String, tcr: String, tmk: String? = nil, p: String? = nil, c: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/fed/r"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "cid": cid,
            "tcr": tcr,
            "tmk": tmk,
            "p": p,
            "c": c
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

}
