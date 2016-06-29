//
// SearchAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire



public class SearchAPI: APIBase {
    /**
     搜索新闻
     
     - parameter keywords: (query) 搜搜新闻关键字 
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter l: (query) 条数 (optional, default to 20)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsEsSGet(keywords keywords: String, p: String? = nil, l: String? = nil, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        nsEsSGetWithRequestBuilder(keywords: keywords, p: p, l: l).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     搜索新闻
     - GET /ns/es/s
     - 搜索一个新闻
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter keywords: (query) 搜搜新闻关键字 
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter l: (query) 条数 (optional, default to 20)

     - returns: RequestBuilder<AnyObject> 
     */
    public class func nsEsSGetWithRequestBuilder(keywords keywords: String, p: String? = nil, l: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/es/s"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "keywords": keywords,
            "p": p,
            "l": l
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

}
