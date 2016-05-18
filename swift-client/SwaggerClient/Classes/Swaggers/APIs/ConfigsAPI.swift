//
// ConfigsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire



public class ConfigsAPI: APIBase {
    /**
     
     \u83B7\u53D6\u9891\u9053
     
     - parameter online: (query) \u6807\u793A\u6240\u8BF7\u6C42\u7684\u9891\u9053\u662F\u4E0D\u662F\u4E0A\u7EBF\u7684 (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func channelsGet(online online: String?, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        channelsGetWithRequestBuilder(online: online).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     
     \u83B7\u53D6\u9891\u9053
     
     - GET /channels
     - \u9891\u9053\u5217\u8868\u67E5\u8BE2
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter online: (query) \u6807\u793A\u6240\u8BF7\u6C42\u7684\u9891\u9053\u662F\u4E0D\u662F\u4E0A\u7EBF\u7684 (optional)

     - returns: RequestBuilder<AnyObject> 
     */
    public class func channelsGetWithRequestBuilder(online online: String?) -> RequestBuilder<AnyObject> {
        let path = "/channels"
        let URLString = SwaggerClientAPI.basePath + path
        
        let nillableParameters: [String:AnyObject?] = [
            "online": online
        ]
        let parameters = APIHelper.rejectNil(nillableParameters)

        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: parameters, isBody: false)
    }

}