//
//  PhotoBrowerProgressView.swift
//  PhotoBrower
//
//  Created by Mister on 16/6/28.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import DACircularProgress

class PhotoBrowerProgressView: DACircularProgressView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        thicknessRatio = 0.1
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: 40, height: 40))
        center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
}
