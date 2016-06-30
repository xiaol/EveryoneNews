//
//  PhotoBrowerImageView.swift
//  PhotoBrower
//
//  Created by Mister on 16/6/28.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import PINRemoteImage

@objc protocol PhotoBrowerImageViewDelegate {
    func handleImageViewSingleTap(touchPoint: CGPoint)
    func handleImageViewDoubleTap(touchPoint: CGPoint)
    
    func downloadImageProgress(pregress: CGFloat)
    func downloadImageError(error: NSError)
    func downloadImageFinish(result: PINRemoteImageManagerResult)
}

class PhotoBrowerImageView: FLAnimatedImageView {
    weak var delegate: PhotoBrowerImageViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var progressView: PhotoBrowerProgressView!
    
    init(frame: CGRect,url:String) {
        super.init(frame: frame)
        userInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(doubleTap)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        singleTap.requireGestureRecognizerToFail(doubleTap)
        self.addGestureRecognizer(singleTap)
        
        
        // indicator
        progressView = PhotoBrowerProgressView(frame: frame)
        addSubview(progressView)
        
        progressView.hidden = true
        
        self.donwloadImage(url)
    }
    
    func handleDoubleTap(recognizer:UITapGestureRecognizer) {
        delegate?.handleImageViewDoubleTap(recognizer.locationInView(self))
    }
    
    func handleSingleTap(recognizer:UITapGestureRecognizer) {
        delegate?.handleImageViewSingleTap(recognizer.locationInView(self))
    }
    
    
    // Download
    private func donwloadImage(urlStr:String){
    
        guard let url = NSURL(string: urlStr) else {return}
        
        PINRemoteImageManager.sharedImageManager().downloadImageWithURL(url, options: .DownloadOptionsNone, progressDownload: { (completed, total) in
            
            let process = CGFloat(completed)/CGFloat(total)
            
            dispatch_async(dispatch_get_main_queue(), {
  
                self.progressView.hidden = false
                
                self.progressView.setProgress(process, animated: true)
                
                if process == 1 {
                
                    self.progressView.hidden = true
                    
                    self.progressView.removeFromSuperview()
                }
            })

        }) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { 
                if let error = result.error {
                    
                    self.delegate?.downloadImageError(error)
                }else{
                    self.delegate?.downloadImageFinish(result)
                }
            })
        }
    }
}
