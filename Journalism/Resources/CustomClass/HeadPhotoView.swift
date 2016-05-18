//
//  HeadPhotoView.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

///按钮扩展类
@IBDesignable
class HeadPhotoView:UIImageView{
    
    @IBInspectable var cornerRadius:CGFloat = 0{
        
        didSet{
            
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
}