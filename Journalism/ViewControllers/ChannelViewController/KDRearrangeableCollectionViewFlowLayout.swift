//
//  KDRearrangeableCollectionViewFlowLayout.swift
//  KDRearrangeableCollectionViewFlowLayout
//
//  Created by Michael Michailidis on 16/03/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit

@objc protocol KDRearrangeableCollectionViewDelegate : UICollectionViewDelegate {
    func moveDataItem(fromIndexPath : NSIndexPath, toIndexPath: NSIndexPath) -> Void
    @objc optional func ChannelManagerBeginDraggind() // 开始
    @objc optional func ChannelManagerEndDraggind() // 结束
}

enum KDDraggingAxis {
    case Free
    case X
    case Y
    case XY
}

class KDRearrangeableCollectionViewFlowLayout: UICollectionViewFlowLayout, UIGestureRecognizerDelegate {
    
    var animating : Bool = false
    
    var draggable : Bool = true
    
    var CollectionViewDragIng : Bool = false
    
    var delegate:KDRearrangeableCollectionViewDelegate!
    
    var collectionViewFrameInCanvas : CGRect = CGRect.zero
    
    var hitTestRectagles = [String:CGRect]()
  
    var canvas : UIView? {
        didSet {
            if canvas != nil {
                self.calculateBorders()
            }
        }
    }
    
    var axis : KDDraggingAxis = .Free
    
    struct Bundle {
        var offset : CGPoint = .zero
        var sourceCell : ChannelCollectionViewCell
        var representationImageView : UIView
        var currentIndexPath : NSIndexPath
    }
    var bundle : Bundle?
    
    
    override init() {
        super.init()
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
        
        if let collectionView = self.collectionView {

            let longPressGestureRecogniser = UILongPressGestureRecognizer(target: self, action: Selector(("handleGesture:")))
        
            longPressGestureRecogniser.minimumPressDuration = 0.2
            longPressGestureRecogniser.delegate = self

            collectionView.addGestureRecognizer(longPressGestureRecogniser)
            
            let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: Selector(("handleGesture:")))
            
            panGestureRecogniser.delegate = self
            
            collectionView.addGestureRecognizer(panGestureRecogniser)
            
            
            if self.canvas == nil {
                
                self.canvas = self.collectionView!.superview
                
            }
            
            
        }
    }
    
    override func prepare() {
        super.prepare()
        self.calculateBorders()
    }
    
    private func calculateBorders() {
        
        if let collectionView = self.collectionView {
            
            collectionViewFrameInCanvas = collectionView.frame
            
            
            if self.canvas != collectionView.superview {
                collectionViewFrameInCanvas = self.canvas!.convert(collectionViewFrameInCanvas, from: collectionView)
            }
            
            
            var leftRect : CGRect = collectionViewFrameInCanvas
            leftRect.size.width = 20.0
            hitTestRectagles["left"] = leftRect
            
            var topRect : CGRect = collectionViewFrameInCanvas
            topRect.size.height = 20.0
            hitTestRectagles["top"] = topRect
            
            var rightRect : CGRect = collectionViewFrameInCanvas
            rightRect.origin.x = rightRect.size.width - 20.0
            rightRect.size.width = 20.0
            hitTestRectagles["right"] = rightRect
            
            var bottomRect : CGRect = collectionViewFrameInCanvas
            bottomRect.origin.y = bottomRect.origin.y + rightRect.size.height - 20.0
            bottomRect.size.height = 20.0
            hitTestRectagles["bottom"] = bottomRect
            
           
            
            
        }
        
        
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
   
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UIPanGestureRecognizer && self.CollectionViewDragIng == false{
        
            return false
        }
        
        if draggable == false {
            return false
        }
        
        if  let ca = self.canvas,
            let cv = self.collectionView {
                
                let pointPressedInCanvas = gestureRecognizer.location(in: ca)
                
                for cell in cv.visibleCells {
                    
                    let cellInCanvasFrame = ca.convert(cell.frame, from: cv)
                    
                    guard let cell = cell as? ChannelCollectionViewCell,let indexPath : NSIndexPath = cv.indexPath(for: cell) as NSIndexPath? else{ break }
                    
                    if cellInCanvasFrame.contains(pointPressedInCanvas ) {
                        
                        if let begin = self.delegate.ChannelManagerBeginDraggind{
                            
                            self.CollectionViewDragIng = true
                            
                            begin() // 开始拖拽
                        }
                        
                        cell.channelStateImageView.isHidden = true
                        
                        cell.clipsToBounds = true
                        
                        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0)
                        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
                        let img = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                        let representationImage = UIImageView(image: img)
                        
                        representationImage.frame = cellInCanvasFrame
                        
                        let offset = CGPoint(x: pointPressedInCanvas.x - cellInCanvasFrame.origin.x, y: pointPressedInCanvas.y - cellInCanvasFrame.origin.y)
                        
                        
                        self.bundle = Bundle(offset: offset, sourceCell: cell, representationImageView:representationImage, currentIndexPath: indexPath)
                        
                        break
                    }
                    
                }
            
        }
        
        return (self.bundle != nil)
    }
    
    
    
    func checkForDraggingAtTheEdgeAndAnimatePaging(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if self.animating == true {
            return
        }
        
        if let bundle = self.bundle {
            
           
            var nextPageRect : CGRect = self.collectionView!.bounds
            
            if self.scrollDirection == UICollectionViewScrollDirection.horizontal {
                
                if bundle.representationImageView.frame.intersects(hitTestRectagles["left"]!) {
                   
                    nextPageRect.origin.x -= nextPageRect.size.width
                    
                    if nextPageRect.origin.x < 0.0 {
                        
                        nextPageRect.origin.x = 0.0
                        
                    }
                    
                }
                else if bundle.representationImageView.frame.intersects(hitTestRectagles["right"]!) {
                  
                    nextPageRect.origin.x += nextPageRect.size.width
                    
                    if nextPageRect.origin.x + nextPageRect.size.width > self.collectionView!.contentSize.width {
                        
                        nextPageRect.origin.x = self.collectionView!.contentSize.width - nextPageRect.size.width
                        
                    }
                }
                
                
            }
            else if self.scrollDirection == UICollectionViewScrollDirection.vertical {
                
                
                if bundle.representationImageView.frame.intersects(hitTestRectagles["top"]!) {
                    
                    
                    nextPageRect.origin.y -= nextPageRect.size.height
                    
                    if nextPageRect.origin.y < 0.0 {
                        
                        nextPageRect.origin.y = 0.0
                        
                    }
                    
                }
                else if bundle.representationImageView.frame.intersects(hitTestRectagles["bottom"]!) {
                   
                    nextPageRect.origin.y += nextPageRect.size.height
                    
                    
                    if nextPageRect.origin.y + nextPageRect.size.height > self.collectionView!.contentSize.height {
                        
                        nextPageRect.origin.y = self.collectionView!.contentSize.height - nextPageRect.size.height
                        
                    }
                }
                
                
            }
            
            if !nextPageRect.equalTo(self.collectionView!.bounds){
                
                
                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    self.animating = false
                    
                    self.handleGesture(gesture: gestureRecognizer)
                })
                

                
                self.animating = true
                
                
                self.collectionView!.scrollRectToVisible(nextPageRect, animated: true)
                
            }
        }
    }
    
    func handleGesture(gesture: UILongPressGestureRecognizer) -> Void {
        
    
        guard let bundle = self.bundle else {
            return
        }

        
        func endDraggingAction(bundle: Bundle) {
            
            if let begin = self.delegate.ChannelManagerEndDraggind{
                
                begin() // 开始拖拽
            }
            
            let frame = bundle.sourceCell.convert(bundle.sourceCell.bounds, to: self.collectionView?.superview)
            
            UIView.animate(withDuration: 0.3, animations: { 
                
                bundle.representationImageView.frame = frame
                
                }) { (_) in
                    
                    bundle.representationImageView.removeFromSuperview()
                    bundle.sourceCell.clipsToBounds = false
                    bundle.sourceCell.channelStateImageView.isHidden = false
                    bundle.sourceCell.isHidden = false
            }
            
            
            
            // if we have a proper data source then we can reload and have the data displayed correctly
//            if let cv = self.collectionView where cv.delegate is KDRearrangeableCollectionViewDelegate {
//                
//                cv.reloadData()
//            }
            
            self.bundle = nil
        }
        
        let dragPointOnCanvas = gesture.location(in: self.canvas)
        
        
        switch gesture.state {
            
            
        case .began:
            
            let indexPath = self.collectionView?.indexPath(for: bundle.sourceCell)
            
            if indexPath?.section != 0 || (indexPath?.section == 0 && indexPath?.item == 0 ){
                
                self.bundle = nil
            
                return
            }
            
            bundle.sourceCell.isHidden = true
            self.canvas?.addSubview(bundle.representationImageView)
            
            var imageViewFrame = bundle.representationImageView.frame
            var point = CGPoint.zero
            point.x = dragPointOnCanvas.x - bundle.offset.x
            point.y = dragPointOnCanvas.y - bundle.offset.y
            
            imageViewFrame.origin = point
            bundle.representationImageView.frame = imageViewFrame
            
            break
            
        case .changed:
            
            // Update the representation image
            var imageViewFrame = bundle.representationImageView.frame
            var point = CGPoint(x: dragPointOnCanvas.x - bundle.offset.x, y: dragPointOnCanvas.y - bundle.offset.y)
            if self.axis == .X {
                point.y = imageViewFrame.origin.y
            }
            if self.axis == .Y {
                point.x = imageViewFrame.origin.x
            }
            
            
            imageViewFrame.origin = point
            bundle.representationImageView.frame = imageViewFrame
            
            
            var dragPointOnCollectionView = gesture.location(in: self.collectionView)
            
            if self.axis == .X {
                dragPointOnCollectionView.y = bundle.representationImageView.center.y
            }
            if self.axis == .Y {
                dragPointOnCollectionView.x = bundle.representationImageView.center.x
            }
            
            
            
            
            if let indexPath : NSIndexPath = self.collectionView?.indexPathForItem(at: dragPointOnCollectionView) as NSIndexPath? {
                
                self.checkForDraggingAtTheEdgeAndAnimatePaging(gestureRecognizer: gesture)
                
                if indexPath.isEqual(bundle.currentIndexPath) == false && indexPath.section == 0 && (indexPath.section != 0 || indexPath.item != 0 ){
                    
                    DispatchQueue.main.async {
                        // If we have a collection view controller that implements the delegate we call the method first
                        self.delegate.moveDataItem(fromIndexPath: bundle.currentIndexPath, toIndexPath: indexPath)
                    }
                    

                    self.collectionView!.moveItem(at: bundle.currentIndexPath as IndexPath, to: indexPath as IndexPath)
                    self.bundle!.currentIndexPath = indexPath
                    
                }
                
            }
            break
            
            
        case .ended,.failed,.cancelled:
            endDraggingAction(bundle: bundle)
            
            break
            
            
        case .possible:
            break
            
            
        }
        
    }
    
}





