//
//  VisitorViewController.swift
//  Journalism
//
//  Created by Mister on 16/5/27.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class VisitorViewController: UIViewController {
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Portrait
    }
    
    var splistViewController:UISplitViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        splistViewController = UIStoryboard.shareStoryBoard.get_UISplitViewController()
        
        guard let _ = SDK_User.token else{
            return
        }
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController = splistViewController
    }
    // 随便看看
    @IBAction func casualLook(sender: AnyObject) {
        
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        SDK_User.getSdkUserToken { (token) in
            
            self.presentViewController(self.splistViewController, animated: false, completion: nil)
        }
    }
}
