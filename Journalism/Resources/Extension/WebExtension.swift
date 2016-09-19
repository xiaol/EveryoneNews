//
//  WebExtension.swift
//  Journalism
//
//  Created by Mister on 16/8/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
//import JSQWebViewController

extension UIViewController {
    
    @discardableResult
    func goWebViewController(_ url:String,isTo:Bool=true) -> UIViewController{
        
        print(url)
        
        //let controller = WebViewController(url: URL(string: url)!)
        //let nav = UINavigationController(rootViewController: controller)
        //present(nav, animated: true, completion: nil)
        return UIViewController()
    }
}
