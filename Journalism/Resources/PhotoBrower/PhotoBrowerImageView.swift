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
    func handleImageViewSingleTap(_ touchPoint: CGPoint)
    func handleImageViewDoubleTap(_ touchPoint: CGPoint)
    
    func downloadImageProgress(_ pregress: CGFloat)
    func downloadImageError(_ error: NSError)
    func downloadImageFinish(_ result: PINRemoteImageManagerResult)
}

class PhotoBrowerImageView: FLAnimatedImageView {
    weak var delegate: PhotoBrowerImageViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var progressView: PhotoBrowerProgressView!
    
    init(frame: CGRect,url:String) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(doubleTap)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        singleTap.require(toFail: doubleTap)
        self.addGestureRecognizer(singleTap)
        
        
        // indicator
        progressView = PhotoBrowerProgressView(frame: frame)
        addSubview(progressView)
        
        progressView.isHidden = true
        
        self.donwloadImage(url)
    }
    
    func handleDoubleTap(_ recognizer:UITapGestureRecognizer) {
        delegate?.handleImageViewDoubleTap(recognizer.location(in: self))
    }
    
    func handleSingleTap(_ recognizer:UITapGestureRecognizer) {
        delegate?.handleImageViewSingleTap(recognizer.location(in: self))
    }
    
    
    // Download
    fileprivate func donwloadImage(_ urlStr:String){
    
        guard let url = URL(string: urlStr) else {return}
        
        PINRemoteImageManager.shared().downloadImage(with: url, options: PINRemoteImageManagerDownloadOptions(), progressDownload: { (completed, total) in
            
            let process = CGFloat(completed)/CGFloat(total)
            
            DispatchQueue.main.async(execute: {
  
                self.progressView.isHidden = false
                
                self.progressView.setProgress(process, animated: true)
                
                if process == 1 {
                
                    self.progressView.isHidden = true
                    
                    self.progressView.removeFromSuperview()
                }
            })

        }) { (result) in
            
            DispatchQueue.main.async(execute: { 
                if let error = result.error {
                    
                    self.delegate?.downloadImageError(error as NSError)
                }else{
                    self.delegate?.downloadImageFinish(result)
                }
            })
        }
    }
}
