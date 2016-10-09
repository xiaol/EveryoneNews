//
//  ChannelManager.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension HomeViewController{
    
    @IBAction func ClickManagerChannelButton(sender: AnyObject) {
        
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChannelViewController") as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
        
//        self.HandleChannelManagerStatus()
    }
    
    }
