//
//  CustomNSURLCache.swift
//  Journalism
//
//  Created by Mister on 16/6/23.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class CustomNSURLCache:NSURLCache{

    override func storeCachedResponse(cachedResponse: NSCachedURLResponse, forRequest request: NSURLRequest) {
        
        super.storeCachedResponse(cachedResponse, forRequest: request)
        
//        print("NSURLRequest",cachedResponse.response.MIMEType,"----",cachedResponse.response.URL)
    }
    
    override func storeCachedResponse(cachedResponse: NSCachedURLResponse, forDataTask dataTask: NSURLSessionDataTask) {
        
        super.storeCachedResponse(cachedResponse, forDataTask: dataTask)
        
        
        
//        print("NSURLSessionDataTask",cachedResponse.response.MIMEType,"----",cachedResponse.response.URL)
    }
    
    
    override func cachedResponseForRequest(request: NSURLRequest) -> NSCachedURLResponse? {
//        
//        print("cachedResponseForRequest",request.URL)
//        
//        print("--------")
        
        return super.cachedResponseForRequest(request)
    }
}