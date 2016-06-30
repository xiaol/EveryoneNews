//
//  SKZoomingScrollView.swift
//  SKViewExample
//
//  Created by suzuki_keihsi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit
import PINRemoteImage

public class SKZoomingScrollView: UIScrollView, UIScrollViewDelegate, PhotoBrowerTapViewDelegate {
    
    var captionView: SKCaptionView!
    var photo: SKPhotoProtocol!
    
    
    private(set) var photoImageView: PhotoBrowerImageView!
    private weak var photoBrowser: SKPhotoBrowser?
    private var tapView: PhotoBrowerTapView!
    private var progressView: PhotoBrowerProgressView!
    private var imageUrlString: String = ""
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(frame: CGRect, browser: SKPhotoBrowser,url:String) {
        self.init(frame: frame)
        photoBrowser = browser
        imageUrlString = url
        setup()
    }
    
    deinit {
        photoBrowser = nil
    }
    
    func setup() {
        // tap
        tapView = PhotoBrowerTapView(frame: bounds)
        tapView.delegate = self
        tapView.backgroundColor = UIColor.clearColor()
        tapView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        addSubview(tapView)
        
        // image
        photoImageView = PhotoBrowerImageView(frame: frame, url: imageUrlString)
        photoImageView.delegate = self
        photoImageView.contentMode = .ScaleAspectFill
        photoImageView.backgroundColor = .clearColor()
        addSubview(photoImageView)
        
        // indicator
        progressView = PhotoBrowerProgressView(frame: frame)
        addSubview(progressView)
        
        // self
        backgroundColor = .clearColor()
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        decelerationRate = UIScrollViewDecelerationRateFast
        autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleRightMargin, .FlexibleLeftMargin]
    }
    
    // MARK: - override
    
    public override func layoutSubviews() {
        tapView.frame = bounds
        
        super.layoutSubviews()
        
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
        if !CGRectEqualToRect(photoImageView.frame, frameToCenter) {
            photoImageView.frame = frameToCenter
        }
    }
    
    public func setMaxMinZoomScalesForCurrentBounds() {
        
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
        
        
        let scale = UIScreen.mainScreen().scale
        let deviceScreenWidth = UIScreen.mainScreen().bounds.width * scale // width in pixels. scale needs to remove if to use the old algorithm
        let deviceScreenHeight = UIScreen.mainScreen().bounds.height * scale // height in pixels. scale needs to remove if to use the old algorithm
        
        // it is the old algorithm
       /* if photoImageView.frame.width < deviceScreenWidth {
            // I think that we should to get coefficient between device screen width and image width and assign it to maxScale. I made two mode that we will get the same result for different device orientations.
            if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
                maxScale = deviceScreenHeight / photoImageView.frame.width
            } else {
                maxScale = deviceScreenWidth / photoImageView.frame.width
            }
        } else if photoImageView.frame.width > deviceScreenWidth {
            maxScale = 1.0
        } else {
            // here if photoImageView.frame.width == deviceScreenWidth
            maxScale = 2.5
        } */
        
        if photoImageView.frame.width < deviceScreenWidth {
            // I think that we should to get coefficient between device screen width and image width and assign it to maxScale. I made two mode that we will get the same result for different device orientations.
            if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
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
        
        // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
        // maximum zoom scale to 0.5
        // After changing this value, we still never use more
        /*
        maxScale = maxScale / scale 
        if maxScale < minScale {
            maxScale = minScale * 2
        }
        */
        
        // reset position
        photoImageView.frame = CGRect(x: 0, y: 0, width: photoImageView.frame.size.width, height: photoImageView.frame.size.height)
        setNeedsLayout()
    }
    
    public func prepareForReuse() {
        photo = nil
        if captionView != nil {
            captionView.removeFromSuperview()
            captionView = nil 
        }
    }
    
    // MARK: - image
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
    
    
    
    // MARK: - handle tap
    public func handleDoubleTap(touchPoint: CGPoint) {
        if let photoBrowser = photoBrowser {
            NSObject.cancelPreviousPerformRequestsWithTarget(photoBrowser)
        }
        
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
            zoomToRect(zoomRectForScrollViewWith(maximumZoomScale, touchPoint: touchPoint), animated: true)
        }
        
        // delay control
        photoBrowser?.hideControlsAfterDelay()
    }
    
    public func zoomRectForScrollViewWith(scale: CGFloat, touchPoint: CGPoint) -> CGRect {
        let w = frame.size.width / scale
        let h = frame.size.height / scale
        let x = touchPoint.x - (w / 2.0)
        let y = touchPoint.y - (h / 2.0)
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    // MARK: - UIScrollViewDelegate
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    public func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        photoBrowser?.cancelControlHiding()
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    
    // MARK: - SKDetectingViewDelegate
    func handleSingleTap(view: UIView, touch: UITouch) {
        if photoBrowser?.enableZoomBlackArea == true {
            if photoBrowser?.areControlsHidden() == false && photoBrowser?.enableSingleTapDismiss == true {
                photoBrowser?.determineAndClose()
            }
            photoBrowser?.toggleControls()
        }
    }
    
    func handleDoubleTap(view: UIView, touch: UITouch) {
        if photoBrowser?.enableZoomBlackArea == true {
            let needPoint = getViewFramePercent(view, touch: touch)
            handleDoubleTap(needPoint)
        }
    }
    
    private func getViewFramePercent(view: UIView, touch: UITouch) -> CGPoint {
        let oneWidthViewPercent = view.bounds.width / 100
        let viewTouchPoint = touch.locationInView(view)
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
}

// MARK: - PhotoBrowerImageViewDelegate 图片相关代理方法
extension SKZoomingScrollView:PhotoBrowerImageViewDelegate{
    
    /**
     <#Description#>
     
     - parameter touchPoint: <#touchPoint description#>
     */
    func handleImageViewDoubleTap(touchPoint: CGPoint) {
        
        handleDoubleTap(touchPoint)
    }
    
    func handleImageViewSingleTap(touchPoint: CGPoint) {
        if photoBrowser!.enableSingleTapDismiss {
            photoBrowser?.determineAndClose()
        } else {
            photoBrowser?.toggleControls()
        }
    }
    
    func downloadImageError(error: NSError) {
        
        self.progressView.hidden = true
    }
    
    func downloadImageProgress(pregress: CGFloat) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.progressView.setProgress(pregress, animated: true)
        }
    }
    
    func downloadImageFinish(result: PINRemoteImageManagerResult) {
        
        self.progressView.hidden = true
        
        self.displayImage(complete: result)
    }
}