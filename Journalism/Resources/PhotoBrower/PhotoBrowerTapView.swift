//
//  PhotoBrowerTapView.swift
//  PhotoBrower
//
//  Created by Mister on 16/6/28.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

@objc protocol PhotoBrowerTapViewDelegate {
    func handleSingleTap(view: UIView, touch: UITouch)
    func handleDoubleTap(view: UIView, touch: UITouch)
}


class PhotoBrowerTapView: UIView {
    weak var delegate: PhotoBrowerTapViewDelegate?
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let touch = touches.first!
        switch touch.tapCount {
        case 1 : handleSingleTap(touch)
        case 2 : handleDoubleTap(touch)
        default: break
        }
        nextResponder()
    }
    
    func handleSingleTap(touch: UITouch) {
        delegate?.handleSingleTap(self, touch: touch)
    }
    
    func handleDoubleTap(touch: UITouch) {
        delegate?.handleDoubleTap(self, touch: touch)
    }
}


