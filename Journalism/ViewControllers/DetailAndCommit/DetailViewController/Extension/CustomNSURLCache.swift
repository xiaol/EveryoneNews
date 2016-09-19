//
//  CustomNSURLCache.swift
//  Journalism
//
//  Created by Mister on 16/6/23.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class CustomNSURLCache:URLCache{

    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        
        super.storeCachedResponse(cachedResponse, for: request)
        
//        print("NSURLRequest",cachedResponse.response.MIMEType,"----",cachedResponse.response.URL)
    }
    
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for dataTask: URLSessionDataTask) {
        
        super.storeCachedResponse(cachedResponse, for: dataTask)
        
        
        
//        print("NSURLSessionDataTask",cachedResponse.response.MIMEType,"----",cachedResponse.response.URL)
    }
    
    
    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
//        
//        print("cachedResponseForRequest",request.URL)
//        
//        print("--------")
        
        return super.cachedResponse(for: request)
    }
}
