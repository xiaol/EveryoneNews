//
//  PhotoBrowerZoomScrollView.swift
//  PhotoBrower
//
//  Created by Mister on 16/6/28.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import PINRemoteImage


class PhotoBrowerZoomScrollView: UIScrollView,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    
    var urlString:String!
    
    fileprivate var tapView: PhotoBrowerTapView!
    fileprivate var photoImageView:PhotoBrowerImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(frame: CGRect,urlStr:String) {
        super.init(frame: frame)
        setup(urlStr)
    }
    
    func setup(_ urlStr:String?=nil) {
        
        guard let url = urlStr else {return}
        
        panGestureRecognizer.delegate = self
        
        // tap
        tapView = PhotoBrowerTapView(frame: bounds)
        tapView.delegate = self
        tapView.backgroundColor = UIColor.clear
        tapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(tapView)
        
        // image
        photoImageView = PhotoBrowerImageView(frame: frame, url: url)
        photoImageView.delegate = self
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.backgroundColor = .clear
        addSubview(photoImageView)

        
        // self
        delegate = self
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        decelerationRate = UIScrollViewDecelerationRateFast
        autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        
//        let maxW = self.contentSize.width
//        let currX = self.contentOffset.x
//        
//        return currX>maxW
//        
//        print(self.contentSize.width)
//        
//        print(self.contentOffset.x)
        
        return true
    }
    
    
    // MARK: - override
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        bounces = true
        alwaysBounceVertical = true
        alwaysBounceHorizontal = true
        
        let boundsSize = bounds.size
        var frameToCenter = photoImageView.frame
        
        // horizon
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2)
        } else {
            frameToCenter.origin.x = 0
        }
        // vertical
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2)
        } else {
            frameToCenter.origin.y = 0
        }
        
        // Center
        if !photoImageView.frame.equalTo(frameToCenter) {
            photoImageView.frame = frameToCenter
        }
    }
    
    func setMaxMinZoomScalesForCurrentBounds() {
        
        maximumZoomScale = 1
        minimumZoomScale = 1
        zoomScale = 1
        
        guard let photoImageView = photoImageView else {
            return
        }
        
        let boundsSize = bounds.size
        let imageSize = photoImageView.frame.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale: CGFloat = min(xScale, yScale)
        var maxScale: CGFloat!
        
        
        let scale = UIScreen.main.scale
        let deviceScreenWidth = UIScreen.main.bounds.width * scale // width in pixels. scale needs to remove if to use the old algorithm
        let deviceScreenHeight = UIScreen.main.bounds.height * scale // height in pixels. scale needs to remove if to use the old algorithm

        if photoImageView.frame.width < deviceScreenWidth {
            // I think that we should to get coefficient between device screen width and image width and assign it to maxScale. I made two mode that we will get the same result for different device orientations.
            if UIApplication.shared.statusBarOrientation.isPortrait {
                maxScale = deviceScreenHeight / photoImageView.frame.width
            } else {
                maxScale = deviceScreenWidth / photoImageView.frame.width
            }
        } else if photoImageView.frame.width > deviceScreenWidth {
            maxScale = 1.0
        } else {
            // here if photoImageView.frame.width == deviceScreenWidth
            maxScale = 2.5
        }
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
        zoomScale = minScale

        // reset position
        photoImageView.frame = CGRect(x: 0, y: 0, width: photoImageView.frame.size.width, height: photoImageView.frame.size.height)
        setNeedsLayout()
    }
    
    func zoomRectForScrollViewWith(_ scale: CGFloat, touchPoint: CGPoint) -> CGRect {
        let w = frame.size.width / scale
        let h = frame.size.height / scale
        let x = touchPoint.x - (w / 2.0)
        let y = touchPoint.y - (h / 2.0)
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        //        photoBrowser?.cancelControlHiding()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - image
    func displayImage(complete result: PINRemoteImageManagerResult) {
        // reset scale
        maximumZoomScale = 1
        minimumZoomScale = 1
        zoomScale = 1
        contentSize = CGSize.zero
        
         var photoImageViewFrame = CGRect.zero
        
        if let image = result.image {
            
            photoImageView.image = image
            photoImageViewFrame.origin = CGPoint.zero
            photoImageViewFrame.size = image.size
        }
        
        if let image = result.animatedImage {
            
            photoImageView.animatedImage = image
            photoImageViewFrame.origin = CGPoint.zero
            photoImageViewFrame.size = image.size
        }
        
        photoImageView.frame = photoImageViewFrame
        
        contentSize = photoImageViewFrame.size
        
        setMaxMinZoomScalesForCurrentBounds()
        
        setNeedsLayout()
    }
    
    

    
    fileprivate func getViewFramePercent(_ view: UIView, touch: UITouch) -> CGPoint {
        let oneWidthViewPercent = view.bounds.width / 100
        let viewTouchPoint = touch.location(in: view)
        let viewWidthTouch = viewTouchPoint.x
        let viewPercentTouch = viewWidthTouch / oneWidthViewPercent
        
        let photoWidth = photoImageView.bounds.width
        let onePhotoPercent = photoWidth / 100
        let needPoint = viewPercentTouch * onePhotoPercent
        
        var Y: CGFloat!
        
        if viewTouchPoint.y < view.bounds.height / 2 {
            Y = 0
        } else {
            Y = photoImageView.bounds.height
        }
        let allPoint = CGPoint(x: needPoint, y: Y)
        return allPoint
    }
    
    // MARK: - handle tap
    func handleDoubleTap(_ touchPoint: CGPoint) {
        
        
        if zoomScale > minimumZoomScale {
            // zoom out
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            // zoom in
            // I think that the result should be the same after double touch or pinch
            /* var newZoom: CGFloat = zoomScale * 3.13
             if newZoom >= maximumZoomScale {
             newZoom = maximumZoomScale
             }
             */
            zoom(to: zoomRectForScrollViewWith(maximumZoomScale, touchPoint: touchPoint), animated: true)
        }
        
        // delay control
    }
}


extension PhotoBrowerZoomScrollView:PhotoBrowerTapViewDelegate{

    // MARK: - SKDetectingViewDelegate
    func handleSingleTap(_ view: UIView, touch: UITouch) {
        
    }
    
    func handleDoubleTap(_ view: UIView, touch: UITouch) {
        let needPoint = getViewFramePercent(view, touch: touch)
        handleDoubleTap(needPoint)
    }
}

// MARK: - PhotoBrowerImageViewDelegate 图片相关代理方法
extension PhotoBrowerZoomScrollView:PhotoBrowerImageViewDelegate{

    /**
     <#Description#>
     
     - parameter touchPoint: <#touchPoint description#>
     */
    func handleImageViewDoubleTap(_ touchPoint: CGPoint) {
        
        handleDoubleTap(touchPoint)
    }
    
    func handleImageViewSingleTap(_ touchPoint: CGPoint) {
        
    }
    
    func downloadImageError(_ error: NSError) {
        
    }
    
    func downloadImageProgress(_ pregress: CGFloat) {
        

    }
    
    func downloadImageFinish(_ result: PINRemoteImageManagerResult) {
        
        self.displayImage(complete: result)
    }
}
