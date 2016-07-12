//
//  ShareExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/2.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SVProgressHUD

extension DetailAndCommitViewController{

    @IBAction func touchShareButtonAction(sender: AnyObject) {
        
        self.shreContentViewMethod(false, animate: true)
    }
    
    @IBAction func touchMoreButtonAction(sender: AnyObject) {
     
//        self.ShowFouceView()
        
        let viewC = UIStoryboard.shareStoryBoard.get_FocusViewController()
        
        self.presentViewController(viewC, animated: true, completion: nil)
        
//        self.shreContentViewMethod(false, animate: true)
    }
    
    @IBAction func touchCancelButtonAction(sender: AnyObject) {
        
        self.shreContentViewMethod(true, animate: true)
    }
    
    @IBAction func touchCancelViewAction(sender: AnyObject) {
        
        self.shreContentViewMethod(true, animate: true)
    }
    
    func shreContentViewMethod(hidden:Bool = false,animate:Bool = true){
        
        let show = CGAffineTransformIdentity
        let hiddentran = CGAffineTransformTranslate(self.shareContentView.transform, 0, self.shareContentView.frame.height)
        
        UIView.animateWithDuration(animate ? 0.3 : 0) {
            
            self.shareBackView.alpha = hidden ? 0 : 1
            self.shareContentView.transform = hidden ? hiddentran : show
        }
    }
}


import MessageUI
import CoreLocation

extension DetailAndCommitViewController:WaitLoadProtcol{
    
    private func ShareMethod(type:String=UMShareToWechatTimeline,content:String,img:UIImage?=nil,resource:UMSocialUrlResource?=nil){
    
        UMSocialDataService.defaultDataService().postSNSWithTypes([type], content: content, image: img, location: nil, urlResource: resource, presentedController: self) { (response) -> Void in
            
//            self.shreContentViewMethod(true, animate: true)
        }
    }

    
    /// 点击微信朋友圈按钮
    @IBAction func touchWeChatFriendQuanButtonAction(sender: AnyObject) {
        
        guard let n = self.new else{ return }
        
        let title = n.title
        
        let resource = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: n.shareUrl())
        
        n.firstImage { (image) in
            
            self.ShareMethod(content:title,img:image,resource:resource)
        }
    }
    
    /// 点击微信朋友按钮
    @IBAction func touchWeChatFriendButtonAction(sender: AnyObject) {
        
        guard let n = self.new else{ return }
        
        let title = n.title
        let resource = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: n.shareUrl())
        
        n.firstImage { (image) in
            
            self.ShareMethod(UMShareToWechatSession,content:title,img:image,resource:resource)
        }
    }
    
    /// 点击QQ朋友按钮
    @IBAction func touchQQFriendButtonAction(sender: AnyObject) {
        
        let alert = UIAlertController(title: "暂不支持qq", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "返回", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
//        guard let n = self.new else{ return }
//        
//        let title = n.title
//        let resource = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: n.shareUrl())
//        
//        n.firstImage { (image) in
//            
//            self.ShareMethod(UMShareToQQ,content:title,img:image,resource:resource)
//        }
    }
    
    /// 点击新浪微博按钮
    @IBAction func touchSinaButtonAction(sender: AnyObject) {
        
        guard let n = self.new else{ return }

        let message = WBMessageObject()
        message.text = "我在 #奇点资讯 看到这个新闻，可以的。 "
        
        let title = n.title
        let url = n.shareUrl()
        
        n.firstImage { (image) in
            
            let pageObject = WBWebpageObject()
            pageObject.objectID = "123123123123"
            pageObject.title = title
            pageObject.thumbnailData = UIImageJPEGRepresentation(UIImage(named: "LP_icon")!, 0.5)
            pageObject.webpageUrl = url
            message.mediaObject = pageObject
            
            
//            let imageObject = WBImageObject()
//            imageObject.imageData = UIImagePNGRepresentation(image)
//            message.imageObject = imageObject

            
            dispatch_async(dispatch_get_main_queue(), {
                let request = WBSendMessageToWeiboRequest.requestWithMessage(message) as! WBSendMessageToWeiboRequest
                WeiboSDK.sendRequest(request)
            })
        }
    }
    
    /// 点击短信按钮
    @IBAction func touchSMSButtonAction(sender: AnyObject) {
        let messageComposer = configureMessageComposer()
        if MFMessageComposeViewController.canSendText() {
            presentViewController(messageComposer, animated: true, completion: nil)
        } else {
            print("Message Composer Error")
        }
    }
    
    /// 点击邮件按钮
    @IBAction func touchEmailButtonAction(sender: AnyObject) {
        let mailComposer = configureMailComposer()
        if MFMailComposeViewController.canSendMail() {
            presentViewController(mailComposer, animated: true, completion: nil)
        } else {
            print("Email Composer Error")
        }
    }
    
    /// 点击转发链接按钮
    @IBAction func touchCopyLinkButtonAction(sender: AnyObject) {
        
        self.shreContentViewMethod(true, animate: true)
        guard let n = self.new else{ return }
        let pboard = UIPasteboard.generalPasteboard()
        pboard.string = n.shareUrl()
        
        SVProgressHUD.showSuccessWithStatus("已经拷贝至剪切板")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), {
            dispatch_async(dispatch_get_main_queue()) {
                SVProgressHUD.dismiss()
            }
        })
    }
    
    /// 点击字体大小按钮
    @IBAction func touchFontSizeButtonAction(sender: AnyObject) {
        
        self.shreContentViewMethod(true, animate: true)
        
        self.showFontSizeSlideView()
    }
}


extension DetailAndCommitViewController: MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
    
    private func configureMailComposer() -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        guard let n = self.new else{ return mailComposer }
        mailComposer.setMessageBody(n.title+"\n"+n.shareUrl(), isHTML: false) // Default Message (optional)
        return mailComposer
    }
    
    private func configureMessageComposer() -> MFMessageComposeViewController {
        
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        guard let n = self.new else{ return messageComposer }
        messageComposer.body = n.title+"\n"+n.shareUrl() // Default Message (optional)
        return messageComposer
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
