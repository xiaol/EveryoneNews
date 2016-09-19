//
//  SKPhotoBrowser.swift
//  SKViewExample
//
//  Created by suzuki_keishi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

@objc public protocol SKPhotoBrowserDelegate {
    
    /**
     Tells the delegate that the browser started displaying a new photo
     
     - Parameter index: the index of the new photo
     */
    @objc optional func didShowPhotoAtIndex(_ index: Int)
    
    /**
     Tells the delegate the browser will start to dismiss
     
     - Parameter index: the index of the current photo
     */
    @objc optional func willDismissAtPageIndex(_ index: Int)
    
    /**
     Tells the delegate that the browser will start showing the `UIActionSheet`
     
     - Parameter photoIndex: the index of the current photo
     */
    @objc optional func willShowActionSheet(_ photoIndex: Int)
    
    /**
     Tells the delegate that the browser has been dismissed
     
     - Parameter index: the index of the current photo
     */
    @objc optional func didDismissAtPageIndex(_ index: Int)
    
    /**
     Tells the delegate that the browser did dismiss the UIActionSheet
     
     - Parameter buttonIndex: the index of the pressed button
     - Parameter photoIndex: the index of the current photo
     */
    @objc optional func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int)

    /**
     Tells the delegate that the browser did scroll to index

     - Parameter index: the index of the photo where the user had scroll
     */
    @objc optional func didScrollToIndex(_ index: Int)

    /**
     Tells the delegate the user removed a photo, when implementing this call, be sure to call reload to finish the deletion process
     
     - Parameter browser: reference to the calling SKPhotoBrowser
     - Parameter index: the index of the removed photo
     - Parameter reload: function that needs to be called after finishing syncing up
     */
    @objc optional func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: (() -> Void))
    
    /**
     Asks the delegate for the view for a certain photo. Needed to detemine the animation when presenting/closing the browser.
     
     - Parameter browser: reference to the calling SKPhotoBrowser
     - Parameter index: the index of the removed photo
     
     - Returns: the view to animate to
     */
    @objc optional func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView?
}

public let SKPHOTO_LOADING_DID_END_NOTIFICATION = "photoLoadingDidEndNotification"

// MARK: - SKPhotoBrowser
open class SKPhotoBrowser: UIViewController, UIScrollViewDelegate {
    
    final let pageIndexTagOffset: Int = 1000
    // animation property
    var animationDuration: TimeInterval {
        if bounceAnimation {
            return 0.5
        }
        return 0.35
    }
    var animationDamping: CGFloat {
        if bounceAnimation {
            return 0.8
        }
        return 1
    }
    
    // device property
    final let screenBounds = UIScreen.main.bounds
    var screenWidth: CGFloat { return screenBounds.size.width }
    var screenHeight: CGFloat { return screenBounds.size.height }
    var screenRatio: CGFloat { return screenWidth / screenHeight }
    
    // custom abilities
    open var displayAction: Bool = true
    open var shareExtraCaption: String? = nil
    open var actionButtonTitles: [String]?
    open var displayToolbar: Bool = true
    open var displayCounterLabel: Bool = true
    open var displayBackAndForwardButton: Bool = true
    open var disableVerticalSwipe: Bool = false
    open var displayDeleteButton = false
    open var displayCloseButton = true // default is true
    /// If it is true displayCloseButton will be false
    open var displayCustomCloseButton = false
    /// If it is true displayDeleteButton will be false
    open var displayCustomDeleteButton = false
    open var bounceAnimation = false
    open var enableZoomBlackArea = true
    open var enableSingleTapDismiss = false
    /// Set nil to force the statusbar to be hidden
    open var statusBarStyle: UIStatusBarStyle?
    
    // actions
    fileprivate var activityViewController: UIActivityViewController!
    
    // tool for controls
    fileprivate var applicationWindow: UIWindow!
    fileprivate var backgroundView: UIView!
    fileprivate var toolBar: UIToolbar!
    fileprivate var toolCounterLabel: UILabel!
    fileprivate var toolCounterButton: UIBarButtonItem!
    fileprivate var toolPreviousButton: UIBarButtonItem!
    fileprivate var toolActionButton: UIBarButtonItem!
    fileprivate var toolNextButton: UIBarButtonItem!
    fileprivate var pagingScrollView: UIScrollView!
    fileprivate var panGesture: UIPanGestureRecognizer!
    // MARK: close button
    fileprivate var closeButton: UIButton!
    fileprivate var closeButtonShowFrame: CGRect!
    fileprivate var closeButtonHideFrame: CGRect!
    // MARK: delete button
    fileprivate var deleteButton: UIButton!
    fileprivate var deleteButtonShowFrame: CGRect!
    fileprivate var deleteButtonHideFrame: CGRect!
    
    // MARK: - custom buttons
    // MARK: CustomCloseButton
    fileprivate var customCloseButton: UIButton!
    open var customCloseButtonShowFrame: CGRect!
    open var customCloseButtonHideFrame: CGRect!
    open var customCloseButtonImage: UIImage!
    open var customCloseButtonEdgeInsets: UIEdgeInsets!
    
    // MARK: CustomDeleteButton
    fileprivate var customDeleteButton: UIButton!
    open var customDeleteButtonShowFrame: CGRect!
    open var customDeleteButtonHideFrame: CGRect!
    open var customDeleteButtonImage: UIImage!
    open var customDeleteButtonEdgeInsets: UIEdgeInsets!
    
    // photo's paging
    fileprivate var visiblePages = [SKZoomingScrollView]()//: Set<SKZoomingScrollView> = Set()
    fileprivate var recycledPages = [SKZoomingScrollView]()
    
    fileprivate var initialPageIndex: Int = 0
    fileprivate var currentPageIndex: Int = 0
    
    // senderView's property
    fileprivate var senderViewForAnimation: UIView?
    fileprivate var senderViewOriginalFrame: CGRect = CGRect.zero
    fileprivate var senderOriginImage: UIImage!
    
    fileprivate var resizableImageView: UIImageView = UIImageView()
    
    // for status check property
    fileprivate var isDraggingPhoto: Bool = false
    fileprivate var isEndAnimationByToolBar: Bool = true
    fileprivate var isViewActive: Bool = false
    fileprivate var isPerformingLayout: Bool = false
    fileprivate var isStatusBarOriginallyHidden = UIApplication.shared.isStatusBarHidden
    fileprivate var originalStatusBarStyle: UIStatusBarStyle {
        return self.presentingViewController?.preferredStatusBarStyle ?? UIApplication.shared.statusBarStyle
    }
    fileprivate var buttonTopOffset: CGFloat {
        return statusBarStyle == nil ? 5 : 25
    }
    
    // scroll property
    fileprivate var firstX: CGFloat = 0.0
    fileprivate var firstY: CGFloat = 0.0
    
    // timer
    fileprivate var controlVisibilityTimer: Timer!
    
    // delegate
    open weak var delegate: SKPhotoBrowserDelegate?
    
    // helpers which often used
    fileprivate let bundle = Bundle(for: SKPhotoBrowser.self)
    
    // photos
    var photos: [SKPhotoProtocol] = [SKPhotoProtocol]()
    var numberOfPhotos: Int {
        return photos.count
    }
    // MARK - Initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    public convenience init(photos: [SKPhotoProtocol]) {
        self.init(nibName: nil, bundle: nil)
        let picutres = photos.flatMap {$0 }
        for photo in picutres {
            self.photos.append(photo)
        }
    }
    
    public convenience init(originImage: UIImage, photos: [SKPhotoProtocol], animatedFromView: UIView) {
        self.init(nibName: nil, bundle: nil)
        self.senderOriginImage = originImage
        self.senderViewForAnimation = animatedFromView
        let picutres = photos.flatMap { $0 }
        for photo in picutres {
            self.photos.append(photo)
        }
    }
    
    deinit {
        pagingScrollView = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup() {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        applicationWindow = window
        
        modalPresentationCapturesStatusBarAppearance = true
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleSKPhotoLoadingDidEndNotification(_:)), name: SKPHOTO_LOADING_DID_END_NOTIFICATION, object: nil)
    }
    
    // MARK: - override
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.isOpaque = false
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.0
        applicationWindow.addSubview(backgroundView)
        
        // setup paging
        let pagingScrollViewFrame = frameForPagingScrollView()
        pagingScrollView = UIScrollView(frame: pagingScrollViewFrame)
        pagingScrollView.isPagingEnabled = true
        pagingScrollView.delegate = self
        pagingScrollView.showsHorizontalScrollIndicator = true
        pagingScrollView.showsVerticalScrollIndicator = true
        pagingScrollView.backgroundColor = .clear
        pagingScrollView.contentSize = contentSizeForPagingScrollView()
        view.addSubview(pagingScrollView)
        
        // toolbar
        toolBar = UIToolbar(frame: frameForToolbarAtOrientation())
        toolBar.backgroundColor = .clear
        toolBar.clipsToBounds = true
        toolBar.isTranslucent = true
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        view.addSubview(toolBar)
        
        if !displayToolbar {
            toolBar.isHidden = true
        }
        
        // arrows:back
        let previousBtn = UIButton(type: .custom)
        let previousImage = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_back_wh", in: bundle, compatibleWith: nil) ?? UIImage()
        previousBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        previousBtn.imageEdgeInsets = UIEdgeInsetsMake(13.25, 17.25, 13.25, 17.25)
        previousBtn.setImage(previousImage, for: UIControlState())
        previousBtn.addTarget(self, action: #selector(self.gotoPreviousPage), for: .touchUpInside)
        previousBtn.contentMode = .center
        toolPreviousButton = UIBarButtonItem(customView: previousBtn)
        
        // arrows:next
        let nextBtn = UIButton(type: .custom)
        let nextImage = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_forward_wh", in: bundle, compatibleWith: nil) ?? UIImage()
        nextBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        nextBtn.imageEdgeInsets = UIEdgeInsetsMake(13.25, 17.25, 13.25, 17.25)
        nextBtn.setImage(nextImage, for: UIControlState())
        nextBtn.addTarget(self, action: #selector(self.gotoNextPage), for: .touchUpInside)
        nextBtn.contentMode = .center
        toolNextButton = UIBarButtonItem(customView: nextBtn)
        
        toolCounterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 95, height: 40))
        toolCounterLabel.textAlignment = .center
        toolCounterLabel.backgroundColor = .clear
        toolCounterLabel.font  = UIFont(name: "Helvetica", size: 16.0)
        toolCounterLabel.textColor = .white
        toolCounterLabel.shadowColor = .darkText
        toolCounterLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        toolCounterButton = UIBarButtonItem(customView: toolCounterLabel)
        
        // starting setting
        setCustomSetting()
        setSettingCloseButton()
        setSettingDeleteButton()
        setSettingCustomCloseButton()
        setSettingCustomDeleteButton()
        
        // action button
        toolActionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(SKPhotoBrowser.actionButtonPressed))
        toolActionButton.tintColor = .white
        
        // gesture
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(SKPhotoBrowser.panGestureRecognized(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        
        // transition (this must be last call of view did load.)
        performPresentAnimation()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadData()
        
        var i = 0
        for photo: SKPhotoProtocol in photos {
            photo.index = i
            i = i + 1
        }
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        isPerformingLayout = true
        pagingScrollView.frame = frameForPagingScrollView()
        pagingScrollView.contentSize = contentSizeForPagingScrollView()
        
        // resize frames of buttons after the device rotation
        frameForButton()
        
        // this algorithm resizes the current image after device rotation
        if visiblePages.count > 0 {
            for page in visiblePages {
                let pageIndex = page.tag - pageIndexTagOffset
                page.frame = frameForPageAtIndex(pageIndex)
                page.setMaxMinZoomScalesForCurrentBounds()
                if page.captionView != nil {
                    page.captionView.frame = frameForCaptionView(page.captionView, index: pageIndex)
                }
            }
        }

        pagingScrollView.contentOffset = contentOffsetForPageAtIndex(currentPageIndex)
        // where did start
        didStartViewingPageAtIndex(currentPageIndex)
        
        toolBar.frame = frameForToolbarAtOrientation()
        isPerformingLayout = false
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        isViewActive = true
    }
    
    override open var prefersStatusBarHidden : Bool {
        if statusBarStyle == nil {
            return true
        }
        
        if isDraggingPhoto && !areControlsHidden() {
            return isStatusBarOriginallyHidden
        }
        
        return areControlsHidden()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        recycledPages.removeAll()
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return statusBarStyle ?? super.preferredStatusBarStyle
    }
    
    // MARK: - setting of buttons
    // This function should be at the beginning of the other functions
    fileprivate func setCustomSetting() {
        if displayCustomCloseButton == true {
            displayCloseButton = false
        }
        if displayCustomDeleteButton == true {
            displayDeleteButton = false
        }
    }
    
    // MARK: - Buttons' setting
    // MARK: Close button
    fileprivate func setSettingCloseButton() {
        if displayCloseButton == true {
            let doneImage = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_close_wh", in: bundle, compatibleWith: nil) ?? UIImage()
            closeButton = UIButton(type: UIButtonType.custom)
            closeButton.setImage(doneImage, for: UIControlState())
            if UI_USER_INTERFACE_IDIOM() == .phone {
                closeButton.imageEdgeInsets = UIEdgeInsetsMake(15.25, 15.25, 15.25, 15.25)
            } else {
                closeButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
            }
            closeButton.backgroundColor = .clear
            closeButton.addTarget(self, action: #selector(self.closeButtonPressed(_:)), for: UIControlEvents.touchUpInside)
            closeButtonHideFrame = CGRect(x: 5, y: -20, width: 44, height: 44)
            closeButtonShowFrame = CGRect(x: 5, y: buttonTopOffset, width: 44, height: 44)
            view.addSubview(closeButton)
            closeButton.translatesAutoresizingMaskIntoConstraints = true
            closeButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        }
    }
    
    // MARK: Delete button
    
    fileprivate func setSettingDeleteButton() {
        if displayDeleteButton == true {
            deleteButton = UIButton(type: .custom)
            deleteButtonShowFrame = CGRect(x: view.frame.width - 44, y: buttonTopOffset, width: 44, height: 44)
            deleteButtonHideFrame = CGRect(x: view.frame.width - 44, y: -20, width: 44, height: 44)
            let image = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_delete_wh", in: bundle, compatibleWith: nil) ?? UIImage()
            if UI_USER_INTERFACE_IDIOM() == .phone {
                deleteButton.imageEdgeInsets = UIEdgeInsets(top: 15.25, left: 15.25, bottom: 15.25, right: 15.25)
            } else {
                deleteButton.imageEdgeInsets = UIEdgeInsetsMake(12.3, 12.3, 12.3, 12.3)
            }
            deleteButton.setImage(image, for: UIControlState())
            deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed(_:)), for: UIControlEvents.touchUpInside)
            deleteButton.alpha = 0.0
            view.addSubview(deleteButton)
            deleteButton.translatesAutoresizingMaskIntoConstraints = true
            deleteButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        }
    }
    
    // MARK: - Custom buttons' setting
    // MARK: Custom Close Button
    
    fileprivate func setSettingCustomCloseButton() {
        if displayCustomCloseButton == true {
            let closeImage = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_close_wh", in: bundle, compatibleWith: nil) ?? UIImage()
            customCloseButton = UIButton(type: .custom)
            customCloseButton.addTarget(self, action: #selector(self.closeButtonPressed(_:)), for: .touchUpInside)
            customCloseButton.backgroundColor = .clear
            // If another developer has not set their values
            if customCloseButtonImage != nil {
                customCloseButton.setImage(customCloseButtonImage, for: UIControlState())
            } else {
                customCloseButton.setImage(closeImage, for: UIControlState())
            }
            if customCloseButtonShowFrame == nil && customCloseButtonHideFrame == nil {
                customCloseButtonShowFrame = CGRect(x: 5, y: buttonTopOffset, width: 44, height: 44)
                customCloseButtonHideFrame = CGRect(x: 5, y: -20, width: 44, height: 44)
            }
            if customCloseButtonEdgeInsets != nil {
                customCloseButton.imageEdgeInsets = customCloseButtonEdgeInsets
            }
            
            customCloseButton.translatesAutoresizingMaskIntoConstraints = true
            view.addSubview(customCloseButton)
            customCloseButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        }
    }
    
    // MARK: Custom Delete Button
    fileprivate func setSettingCustomDeleteButton() {
        if displayCustomDeleteButton == true {
            customDeleteButton = UIButton(type: .custom)
            customDeleteButton.backgroundColor = .clear
            customDeleteButton.addTarget(self, action: #selector(self.deleteButtonPressed(_:)), for: .touchUpInside)
            // If another developer has not set their values
            if customDeleteButtonShowFrame == nil && customDeleteButtonHideFrame == nil {
                customDeleteButtonShowFrame = CGRect(x: view.frame.width - 44, y: buttonTopOffset, width: 44, height: 44)
                customDeleteButtonHideFrame = CGRect(x: view.frame.width - 44, y: -20, width: 44, height: 44)
            }
            if let _customDeleteButtonImage = customDeleteButtonImage {
                customDeleteButton.setImage(_customDeleteButtonImage, for: UIControlState())
            }
            if let _customDeleteButtonEdgeInsets = customDeleteButtonEdgeInsets {
                customDeleteButton.imageEdgeInsets = _customDeleteButtonEdgeInsets
            }
            view.addSubview(customDeleteButton)
            customDeleteButton.translatesAutoresizingMaskIntoConstraints = true
            customDeleteButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        }
    }
    

    // MARK: - initialize / setup
    open func reloadData() {
        performLayout()
        view.setNeedsLayout()
    }
    
    open func performLayout() {
        isPerformingLayout = true
        
        // for tool bar
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        if numberOfPhotos > 1 && displayBackAndForwardButton {
            items.append(toolPreviousButton)
        }
        if displayCounterLabel {
            items.append(flexSpace)
            items.append(toolCounterButton)
            items.append(flexSpace)
        } else {
            items.append(flexSpace)
        }
        if numberOfPhotos > 1 && displayBackAndForwardButton {
            items.append(toolNextButton)
        }
        items.append(flexSpace)
        if displayAction {
            items.append(toolActionButton)
        }
        toolBar.setItems(items, animated: false)
        updateToolbar()
        
        // reset local cache
        visiblePages.forEach({$0.removeFromSuperview()})
        visiblePages.removeAll()
        recycledPages.removeAll()
        
        // set content offset
        pagingScrollView.contentOffset = contentOffsetForPageAtIndex(currentPageIndex)
        
        // tile page
        tilePages()
        didStartViewingPageAtIndex(currentPageIndex)
        
        isPerformingLayout = false
        
        // add pangesture if need
        if !disableVerticalSwipe {
            view.addGestureRecognizer(panGesture)
        }
    }
    
    open func prepareForClosePhotoBrowser() {
        cancelControlHiding()
        applicationWindow.removeGestureRecognizer(panGesture)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    // MARK: - frame calculation
    open func frameForPagingScrollView() -> CGRect {
        var frame = view.bounds
        frame.origin.x -= 10
        frame.size.width += (2 * 10)
        return frame
    }
    
    open func frameForToolbarAtOrientation() -> CGRect {
        let currentOrientation = UIApplication.shared.statusBarOrientation
        var height: CGFloat = navigationController?.navigationBar.frame.size.height ?? 44
        if UIInterfaceOrientationIsLandscape(currentOrientation) {
            height = 32
        }
        return CGRect(x: 0, y: view.bounds.size.height - height, width: view.bounds.size.width, height: height)
    }
    
    open func frameForToolbarHideAtOrientation() -> CGRect {
        let currentOrientation = UIApplication.shared.statusBarOrientation
        var height: CGFloat = navigationController?.navigationBar.frame.size.height ?? 44
        if UIInterfaceOrientationIsLandscape(currentOrientation) {
            height = 32
        }
        return CGRect(x: 0, y: view.bounds.size.height + height, width: view.bounds.size.width, height: height)
    }
    
    open func frameForCaptionView(_ captionView: SKCaptionView, index: Int) -> CGRect {
        let pageFrame = frameForPageAtIndex(index)
        let captionSize = captionView.sizeThatFits(CGSize(width: pageFrame.size.width, height: 0))
        let navHeight = navigationController?.navigationBar.frame.size.height ?? 44
        return CGRect(x: pageFrame.origin.x, y: pageFrame.size.height - captionSize.height - navHeight,
            width: pageFrame.size.width, height: captionSize.height)
    }
    
    open func frameForPageAtIndex(_ index: Int) -> CGRect {
        let bounds = pagingScrollView.bounds
        var pageFrame = bounds
        pageFrame.size.width -= (2 * 10)
        pageFrame.origin.x = (bounds.size.width * CGFloat(index)) + 10
        return pageFrame
    }
    
    open func contentOffsetForPageAtIndex(_ index: Int) -> CGPoint {
        let pageWidth = pagingScrollView.bounds.size.width
        let newOffset = CGFloat(index) * pageWidth
        return CGPoint(x: newOffset, y: 0)
    }
    
    open func contentSizeForPagingScrollView() -> CGSize {
        let bounds = pagingScrollView.bounds
        return CGSize(width: bounds.size.width * CGFloat(numberOfPhotos), height: bounds.size.height)
    }
    
    /// This function changes buttons's frame after the rotation of the device
    fileprivate func frameForButton() {
        if displayDeleteButton {
            deleteButtonShowFrame = CGRect(x: view.frame.width - 44, y: buttonTopOffset, width: 44, height: 44)
            deleteButtonHideFrame = CGRect(x: view.frame.width - 44, y: -20, width: 44, height: 44)
        }
        if displayCustomDeleteButton {
            customDeleteButtonShowFrame = CGRect(x: customDeleteButtonShowFrame.origin.y, y: customDeleteButtonShowFrame.origin.x, width: customDeleteButtonShowFrame.width, height: customDeleteButtonShowFrame.height)
            customDeleteButtonHideFrame = CGRect(x: customDeleteButtonHideFrame.origin.y, y: customDeleteButtonHideFrame.origin.x, width: customDeleteButtonHideFrame.width, height: customDeleteButtonHideFrame.height)
        }
        if displayCustomCloseButton {
            customCloseButtonHideFrame = CGRect(x: customCloseButtonHideFrame.origin.y, y: customCloseButtonHideFrame.origin.x, width: customCloseButtonHideFrame.width, height: customCloseButtonHideFrame.height)
            customCloseButtonShowFrame = CGRect(x: customCloseButtonShowFrame.origin.y, y: customCloseButtonShowFrame.origin.x, width: customCloseButtonShowFrame.width, height: customCloseButtonShowFrame.height)
        }
    }
    
    // MARK: - delete function
    @objc fileprivate func deleteButtonPressed(_ sender: UIButton) {
        delegate?.removePhoto?(self, index: currentPageIndex, reload: { () -> Void in
            self.deleteImage()
        })
    }
    
    fileprivate func deleteImage() {
        if photos.count > 1 {
            // index equals 0 because when we slide between photos delete button is hidden and user cannot to touch on delete button. And visible pages number equals 0
            visiblePages[0].captionView?.removeFromSuperview()
            photos.remove(at: currentPageIndex)
            if currentPageIndex != 0 {
                gotoPreviousPage()
            }
            updateToolbar()
        } else if photos.count == 1 {
            dismissPhotoBrowser()
        }
        reloadData()
    }
    
    // MARK: - Toolbar
    open func updateToolbar() {
        if numberOfPhotos > 1 {
            toolCounterLabel.text = "\(currentPageIndex + 1) / \(numberOfPhotos)"
        } else {
            toolCounterLabel.text = nil
        }
        
        toolPreviousButton.isEnabled = (currentPageIndex > 0)
        toolNextButton.isEnabled = (currentPageIndex < numberOfPhotos - 1)
    }
    
    // MARK: - panGestureRecognized
    open func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        backgroundView.isHidden = true
        let scrollView = pageDisplayedAtIndex(currentPageIndex)
        
        let viewHeight = scrollView.frame.size.height
        let viewHalfHeight = viewHeight/2
        
        var translatedPoint = sender.translation(in: self.view)
        
        // gesture began
        if sender.state == .began {
            firstX = scrollView.center.x
            firstY = scrollView.center.y
            
            senderViewForAnimation?.isHidden = (currentPageIndex == initialPageIndex)
            
            isDraggingPhoto = true
            setNeedsStatusBarAppearanceUpdate()
        }
        
        translatedPoint = CGPoint(x: firstX, y: firstY + translatedPoint.y)
        scrollView.center = translatedPoint
        
        let minOffset = viewHalfHeight / 4
        let offset = 1 - (scrollView.center.y > viewHalfHeight ? scrollView.center.y - viewHalfHeight : -(scrollView.center.y - viewHalfHeight)) / viewHalfHeight
        view.backgroundColor = UIColor.black.withAlphaComponent(max(0.7, offset))
        
        // gesture end
        if sender.state == .ended {
            if scrollView.center.y > viewHalfHeight + minOffset || scrollView.center.y < viewHalfHeight - minOffset {
                backgroundView.backgroundColor = self.view.backgroundColor
                determineAndClose()
                return
            } else {
                // Continue Showing View
                isDraggingPhoto = false
                setNeedsStatusBarAppearanceUpdate()
                
                let velocityY: CGFloat = CGFloat(self.animationDuration) * sender.velocity(in: self.view).y
                let finalX: CGFloat = firstX
                let finalY: CGFloat = viewHalfHeight
                
                let animationDuration = Double(abs(velocityY) * 0.0002 + 0.2)
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(animationDuration)
                UIView.setAnimationCurve(UIViewAnimationCurve.easeIn)
                view.backgroundColor = UIColor.black
                scrollView.center = CGPoint(x: finalX, y: finalY)
                UIView.commitAnimations()
            }
        }
    }
    
    // MARK: - perform animation
    open func performPresentAnimation() {
        view.isHidden = true
        pagingScrollView.alpha = 0.0
        backgroundView.alpha = 0
        
        if let sender = delegate?.viewForPhoto?(self, index: initialPageIndex) ?? senderViewForAnimation {
            senderViewOriginalFrame = (sender.superview?.convert(sender.frame, to:nil))!
            sender.isHidden = true
            
            let imageFromView = (senderOriginImage ?? getImageFromView(sender)).rotateImageByOrientation()
            let imageRatio = imageFromView.size.width / imageFromView.size.height
            let finalImageViewFrame: CGRect

            resizableImageView = UIImageView(image: imageFromView)
            resizableImageView.frame = senderViewOriginalFrame
            resizableImageView.clipsToBounds = true
            resizableImageView.contentMode = .scaleAspectFill
            applicationWindow.addSubview(resizableImageView)
            
            if screenRatio < imageRatio {
                let width = applicationWindow.frame.width
                let height = width / imageRatio
                let yOffset = (applicationWindow.frame.height - height) / 2
                finalImageViewFrame = CGRect(x: 0, y: yOffset, width: width, height: height)
            } else {
                let height = applicationWindow.frame.height
                let width = height * imageRatio
                let xOffset = (applicationWindow.frame.width - width) / 2
                finalImageViewFrame = CGRect(x: xOffset, y: 0, width: width, height: height)
            }
            
            if sender.layer.cornerRadius != 0 {
                let duration = (animationDuration * Double(animationDamping))
                self.resizableImageView.layer.masksToBounds = true
                self.resizableImageView.addCornerRadiusAnimation(sender.layer.cornerRadius, to: 0, duration: duration)
            }
            
            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping:animationDamping, initialSpringVelocity:0, options:UIViewAnimationOptions(), animations: { () -> Void in
                
                    self.backgroundView.alpha = 1.0
                    self.resizableImageView.frame = finalImageViewFrame
                
                    if self.displayCloseButton {
                        self.closeButton.alpha = 1.0
                        self.closeButton.frame = self.closeButtonShowFrame
                    }
                    if self.displayDeleteButton {
                        self.deleteButton.alpha = 1.0
                        self.deleteButton.frame = self.deleteButtonShowFrame
                    }
                    if self.displayCustomCloseButton {
                        self.customCloseButton.alpha = 1.0
                        self.customCloseButton.frame = self.customCloseButtonShowFrame
                    }
                    if self.displayCustomDeleteButton {
                        self.customDeleteButton.alpha = 1.0
                        self.customDeleteButton.frame = self.customDeleteButtonShowFrame
                    }
                },
                completion: { (Bool) -> Void in
                    self.view.isHidden = false
                    self.backgroundView.isHidden = true
                    self.pagingScrollView.alpha = 1.0
                    self.resizableImageView.alpha = 0.0
            })
        } else {
            UIView.animate(withDuration: animationDuration, delay:0, usingSpringWithDamping:animationDamping, initialSpringVelocity:0, options:UIViewAnimationOptions(), animations: { () -> Void in
                    self.backgroundView.alpha = 1.0
                    if self.displayCloseButton {
                        self.closeButton.alpha = 1.0
                        self.closeButton.frame = self.closeButtonShowFrame
                    }
                    if self.displayDeleteButton {
                        self.deleteButton.alpha = 1.0
                        self.deleteButton.frame = self.deleteButtonShowFrame
                    }
                    if self.displayCustomCloseButton {
                        self.customCloseButton.alpha = 1.0
                        self.customCloseButton.frame = self.customCloseButtonShowFrame
                    }
                    if self.displayCustomDeleteButton {
                        self.customDeleteButton.alpha = 1.0
                        self.customDeleteButton.frame = self.customDeleteButtonShowFrame
                    }
                },
                completion: { (Bool) -> Void in
                    self.view.isHidden = false
                    self.pagingScrollView.alpha = 1.0
                    self.backgroundView.isHidden = true
            })
        }
    }
    
    open func performCloseAnimationWithScrollView(_ scrollView: SKZoomingScrollView) {
        view.isHidden = true
        backgroundView.isHidden = false
        backgroundView.alpha = 1
        
        statusBarStyle = isStatusBarOriginallyHidden ? nil : originalStatusBarStyle
        setNeedsStatusBarAppearanceUpdate()
        
        if let sender = senderViewForAnimation {
            senderViewOriginalFrame = (sender.superview?.convert(sender.frame, to:nil))!
        }
        
        let contentOffset = scrollView.contentOffset
        let scrollFrame = scrollView.photoImageView.frame
        let offsetY = scrollView.center.y - (scrollView.bounds.height/2)
        
        let frame = CGRect(
            x: scrollFrame.origin.x - contentOffset.x,
            y: scrollFrame.origin.y + contentOffset.y + offsetY,
            width: scrollFrame.width,
            height: scrollFrame.height)
        
        resizableImageView.image = scrollView.photo?.underlyingImage?.rotateImageByOrientation() ?? resizableImageView.image
        resizableImageView.frame = frame
        resizableImageView.alpha = 1.0
        resizableImageView.clipsToBounds = true
        resizableImageView.contentMode = .scaleAspectFill
        applicationWindow.addSubview(resizableImageView)
        
        if let view = senderViewForAnimation , view.layer.cornerRadius != 0 {
            let duration = (animationDuration * Double(animationDamping))
            self.resizableImageView.layer.masksToBounds = true
            self.resizableImageView.addCornerRadiusAnimation(0, to: view.layer.cornerRadius, duration: duration)
        }
        
        UIView.animate(withDuration: animationDuration, delay:0, usingSpringWithDamping:animationDamping, initialSpringVelocity:0, options:UIViewAnimationOptions(), animations: { () -> () in
                self.backgroundView.alpha = 0.0
                self.resizableImageView.layer.frame = self.senderViewOriginalFrame
            },
            completion: { (Bool) -> () in
                self.resizableImageView.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
                self.dismissPhotoBrowser()
        })
    }
    
    open func dismissPhotoBrowser() {
        modalTransitionStyle = .crossDissolve
        senderViewForAnimation?.isHidden = false
        prepareForClosePhotoBrowser()
        
        dismiss(animated: true) {
            self.delegate?.didDismissAtPageIndex?(self.currentPageIndex)
        }
    }

    open func determineAndClose() {
        delegate?.willDismissAtPageIndex?(currentPageIndex)
        let scrollView = pageDisplayedAtIndex(currentPageIndex)
        
        if currentPageIndex == initialPageIndex {
            performCloseAnimationWithScrollView(scrollView)
            
        } else if let sender = delegate?.viewForPhoto?(self, index: currentPageIndex), let image = photoAtIndex(currentPageIndex).underlyingImage {
            senderViewForAnimation = sender
            resizableImageView.image = image
            performCloseAnimationWithScrollView(scrollView)
            
        } else {
            dismissPhotoBrowser()
        }
    }
    
    //MARK: - image
    fileprivate func getImageFromView(_ sender: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(sender.frame.size, true, 0.0)
        sender.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    // MARK: - paging
    open func initializePageIndex(_ index: Int) {
        var i = index
        if index >= numberOfPhotos {
            i = numberOfPhotos - 1
        }
        
        initialPageIndex = i
        currentPageIndex = i
        
        if isViewLoaded {
            jumpToPageAtIndex(index)
            if !isViewActive {
                tilePages()
            }
        }
    }
    
    open func jumpToPageAtIndex(_ index: Int) {
        if index < numberOfPhotos {
            if !isEndAnimationByToolBar {
                return
            }
            isEndAnimationByToolBar = false
            let pageFrame = frameForPageAtIndex(index)
            pagingScrollView.setContentOffset(CGPoint(x: pageFrame.origin.x - 10, y: 0), animated: true)
            updateToolbar()
        }
        hideControlsAfterDelay()
    }
    
    open func photoAtIndex(_ index: Int) -> SKPhotoProtocol {
        return photos[index]
    }
    
    open func gotoPreviousPage() {
        jumpToPageAtIndex(currentPageIndex - 1)
    }
    
    open func gotoNextPage() {
        jumpToPageAtIndex(currentPageIndex + 1)
    }
    
    open func tilePages() {
        let visibleBounds = pagingScrollView.bounds
        
        var firstIndex = Int(floor((visibleBounds.minX + 10 * 2) / visibleBounds.width))
//        var lastIndex  = Int(floor((visibleBounds.maxX - 10 * 2 - 1) / visibleBounds.width))
        var lastIndex  = 0
        if firstIndex < 0 {
            firstIndex = 0
        }
        if firstIndex > numberOfPhotos - 1 {
            firstIndex = numberOfPhotos - 1
        }
        if lastIndex < 0 {
            lastIndex = 0
        }
        if lastIndex > numberOfPhotos - 1 {
            lastIndex = numberOfPhotos - 1
        }
        
        for page in visiblePages {
            let newPageIndex = page.tag - pageIndexTagOffset
            if newPageIndex < firstIndex || newPageIndex > lastIndex {
                recycledPages.append(page)
                page.prepareForReuse()
                page.removeFromSuperview()
            }
        }
        
        let visibleSet = Set(visiblePages)
        visiblePages = Array(visibleSet.subtracting(recycledPages))
        
        while recycledPages.count > 2 {
            recycledPages.removeFirst()
        }
        
        for index in firstIndex...lastIndex {
            if isDisplayingPageForIndex(index) {
                continue
            }
            
            let page = SKZoomingScrollView(frame: view.frame, browser: self,url:(photoAtIndex(index) as! SKPhoto).photoURL)
            page.frame = frameForPageAtIndex(index)
            page.tag = index + pageIndexTagOffset
            page.photo = photoAtIndex(index)
            
            visiblePages.append(page)
            pagingScrollView.addSubview(page)
            // if exists caption, insert
            if let captionView = captionViewForPhotoAtIndex(index) {
                captionView.frame = frameForCaptionView(captionView, index: index)
                pagingScrollView.addSubview(captionView)
                // ref val for control
                page.captionView = captionView
            }
        }
    }
    
    fileprivate func didStartViewingPageAtIndex(_ index: Int) {
        delegate?.didShowPhotoAtIndex?(index)
    }
    
    fileprivate func captionViewForPhotoAtIndex(_ index: Int) -> SKCaptionView? {
        let photo = photoAtIndex(index)
        if let _ = photo.caption {
            let captionView = SKCaptionView(photo: photo)
            captionView.alpha = areControlsHidden() ? 0.0 : 1.0
            return captionView
        }
        return nil
    }
    
    open func isDisplayingPageForIndex(_ index: Int) -> Bool {
        for page in visiblePages {
            if page.tag - pageIndexTagOffset == index {
                return true
            }
        }
        return false
    }
    
    open func pageDisplayedAtIndex(_ index: Int) -> SKZoomingScrollView {
        var thePage = SKZoomingScrollView()
        for page in visiblePages {
            if page.tag - pageIndexTagOffset == index {
                thePage = page
                break
            }
        }
        return thePage
    }
    
    open func pageDisplayingAtPhoto(_ photo: SKPhotoProtocol) -> SKZoomingScrollView {
        var thePage = SKZoomingScrollView()
        for page in visiblePages {
            if page.photo === photo {
                thePage = page
                break
            }
        }
        return thePage
    }
    
    // MARK: - Control Hiding / Showing
    open func cancelControlHiding() {
        if controlVisibilityTimer != nil {
            controlVisibilityTimer.invalidate()
            controlVisibilityTimer = nil
        }
    }
    
    open func hideControlsAfterDelay() {
        // reset
        cancelControlHiding()
        // start
        controlVisibilityTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(SKPhotoBrowser.hideControls(_:)), userInfo: nil, repeats: false)
    }
    
    open func hideControls(_ timer: Timer) {
        setControlsHidden(true, animated: true, permanent: false)
    }
    
    open func toggleControls() {
        setControlsHidden(!areControlsHidden(), animated: true, permanent: false)
    }
    
    open func setControlsHidden(_ hidden: Bool, animated: Bool, permanent: Bool) {
        cancelControlHiding()
        var captionViews = Set<SKCaptionView>()
        for page in visiblePages {
            if page.captionView != nil {
                captionViews.insert(page.captionView)
            }
        }
        
        UIView.animate(withDuration: animationDuration,
            animations: { () -> Void in
                let alpha: CGFloat = hidden ? 0.0 : 1.0
                self.toolBar.alpha = alpha
                self.toolBar.frame = hidden ? self.frameForToolbarHideAtOrientation() : self.frameForToolbarAtOrientation()
                if self.displayCloseButton {
                    self.closeButton.alpha = alpha
                    self.closeButton.frame = hidden ? self.closeButtonHideFrame : self.closeButtonShowFrame
                }
                if self.displayDeleteButton {
                    self.deleteButton.alpha = alpha
                    self.deleteButton.frame = hidden ? self.deleteButtonHideFrame : self.deleteButtonShowFrame
                }
                if self.displayCustomCloseButton {
                    self.customCloseButton.alpha = alpha
                    self.customCloseButton.frame = hidden ? self.customCloseButtonHideFrame : self.customCloseButtonShowFrame
                }
                if self.displayCustomDeleteButton {
                    self.customDeleteButton.alpha = alpha
                    self.customDeleteButton.frame = hidden ? self.customDeleteButtonHideFrame : self.customDeleteButtonShowFrame
                }
                for captionView in captionViews {
                    captionView.alpha = alpha
                }
            },
            completion: { (Bool) -> Void in
        })
        
        if !permanent {
            hideControlsAfterDelay()
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    open func areControlsHidden() -> Bool {
        return toolBar.alpha == 0.0
    }
    
    // MARK: - Button
    open func closeButtonPressed(_ sender: UIButton) {
        determineAndClose()
    }
    
    // MARK: Action Button
    open func actionButtonPressed() {
        let photo = photoAtIndex(currentPageIndex)
        
        delegate?.willShowActionSheet?(currentPageIndex)
        
        
        
        guard numberOfPhotos > 0 else {
            return
        }
        
        if let titles = actionButtonTitles {
            let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            }))
            for idx in titles.indices {
                actionSheetController.addAction(UIAlertAction(title: titles[idx], style: .default, handler: { (action) -> Void in
                    self.delegate?.didDismissActionSheetWithButtonIndex?(idx, photoIndex: self.currentPageIndex)
                }))
            }
            
            if UI_USER_INTERFACE_IDIOM() == .phone {
                present(actionSheetController, animated: true, completion: nil)
            } else {
                actionSheetController.modalPresentationStyle = .popover
                
                if let popoverController = actionSheetController.popoverPresentationController {
					popoverController.sourceView = self.view
				    popoverController.barButtonItem = toolActionButton
				}
            
                present(actionSheetController, animated: true, completion: { () -> Void in
                })
            }
        } else {
            
            guard let underlyingImage = pageDisplayedAtIndex(currentPageIndex).photoImageView.image else {
                return
            }
            
            var activityItems: [AnyObject] = [underlyingImage]
            if photo.caption != nil {
                if let shareExtraCaption = shareExtraCaption {
                    
//                    activityItems.append("\(photo.caption)"+"\(shareExtraCaption)")
                } else {
                    activityItems.append(photo.caption as AnyObject)
                }
            }
            activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityViewController.completionWithItemsHandler = {
                (activity, success, items, error) in
                self.hideControlsAfterDelay()
                self.activityViewController = nil
            }
            if UI_USER_INTERFACE_IDIOM() == .phone {
                present(activityViewController, animated: true, completion: nil)
            } else {
                activityViewController.modalPresentationStyle = .popover
                let popover: UIPopoverPresentationController! = activityViewController.popoverPresentationController
                popover.barButtonItem = toolActionButton
                present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: -  UIScrollView Delegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isViewActive else {
            return
        }
        guard !isPerformingLayout else {
            return
        }
        
        // tile page
        tilePages()
        
        // Calculate current page
        let visibleBounds = pagingScrollView.bounds
        var index = Int(floor(visibleBounds.midX / visibleBounds.width))
        
        if index < 0 {
            index = 0
        }
        if index > numberOfPhotos - 1 {
            index = numberOfPhotos
        }
        let previousCurrentPage = currentPageIndex
        currentPageIndex = index
        if currentPageIndex != previousCurrentPage {
            didStartViewingPageAtIndex(currentPageIndex)
            updateToolbar()
        }
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        setControlsHidden(true, animated: true, permanent: false)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideControlsAfterDelay()

        let currentIndex = self.pagingScrollView.contentOffset.x / self.pagingScrollView.frame.size.width
        self.delegate?.didScrollToIndex?(Int(currentIndex))
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isEndAnimationByToolBar = true
    }

}
