//
//  VisitorViewController.swift
//  Journalism
//
//  Created by Mister on 16/5/27.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class VisitorViewController: UIViewController,UISplitViewControllerDelegate {
    
    var splistViewController:UISplitViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        splistViewController = UIStoryboard.shareStoryBoard.get_UISplitViewController()
        
        splistViewController.delegate = self
        
        guard let _ = SDK_User.token else{
            return
        }
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController = splistViewController
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsDetailController = secondaryViewController as? DetailAndCommitViewController else { return false }
        if let _ = secondaryAsDetailController.new {return true}
        return true
    }
    
    // 随便看看
    @IBAction func casualLook(sender: AnyObject) {
        
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        SDK_User.getSdkUserToken { (token) in
            
            self.presentViewController(self.splistViewController, animated: false, completion: nil)
        }
    }
}
