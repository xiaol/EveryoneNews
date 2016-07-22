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
        
        self.ShareAlertShow(self)
    }
    
    @IBAction func touchMoreButtonAction(sender: AnyObject) {
     
        self.ShareAlertShow(self)
    }
}


extension DetailAndCommitViewController:ShareAlertDelegate{
    private func ShareMethod(type:String=UMShareToWechatTimeline,content:String,img:UIImage?=nil,resource:UMSocialUrlResource?=nil){
        
        UMSocialDataService.defaultDataService().postSNSWithTypes([type], content: content, image: img, location: nil, urlResource: resource, presentedController: self) { (response) -> Void in
            
            //            self.shreContentViewMethod(true, animate: true)
        }
    }
    func ClickCancel() {
        
        self.ShareAlertHidden()
    }
    
    func ClickFontSize() {
        
        self.ShareAlertHidden()
        
        self.showFontSizeSlideView()
    }
    
    /**
     点击转发链接按钮
     */
    func ClickCopyLink() {
        
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
    
    func ClickEmail() {
        
        let mailComposer = configureMailComposer()
        if MFMailComposeViewController.canSendMail() {
            presentViewController(mailComposer, animated: true, completion: nil)
        } else {
            print("Email Composer Error")
        }
    }
    
    func ClickSMS() {
        
        let messageComposer = configureMessageComposer()
        if MFMessageComposeViewController.canSendText() {
            presentViewController(messageComposer, animated: true, completion: nil)
        } else {
            print("Message Composer Error")
        }
    }
    
    func ClickSina() {
        
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
            
            dispatch_async(dispatch_get_main_queue(), {
                let request = WBSendMessageToWeiboRequest.requestWithMessage(message) as! WBSendMessageToWeiboRequest
                WeiboSDK.sendRequest(request)
            })
        }
    }
    
    func ClickQQFriends() {
        
        let alert = UIAlertController(title: "暂不支持qq", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "返回", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func ClickWeChatFriends() {
        
        guard let n = self.new else{ return }
        
        let title = n.title
        let resource = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: n.shareUrl())
        
        n.firstImage { (image) in
            
            self.ShareMethod(UMShareToWechatSession,content:title,img:image,resource:resource)
        }
    }
    
    func ClickWeChatMoments() {
        
        guard let n = self.new else{ return }
        
        let title = n.title
        
        let resource = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: n.shareUrl())
        
        n.firstImage { (image) in
            
            self.ShareMethod(content:title,img:image,resource:resource)
        }
    }
}



import MessageUI
import CoreLocation

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
