//
//  UserSettingViewController.swift
//  Journalism
//
//  Created by Mister on 16/5/25.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController {
    
    // 清理缓存
    @IBAction func ClearCacher(sender: AnyObject) {
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
}
