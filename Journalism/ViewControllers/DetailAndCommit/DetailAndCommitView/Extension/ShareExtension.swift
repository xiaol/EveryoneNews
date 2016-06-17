//
//  ShareExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/2.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension DetailAndCommitViewController{

    @IBAction func touchShareButtonAction(sender: AnyObject) {
        
        self.shreContentViewMethod(false, animate: true)
    }
    
    @IBAction func touchMoreButtonAction(sender: AnyObject) {
     
        self.shreContentViewMethod(false, animate: true)
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


    
    /// 点击微信朋友圈按钮
    @IBAction func touchWeChatFriendQuanButtonAction(sender: AnyObject) {
        
        let shareTitleStr = new?.title ?? ""
        
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = self.new?.url ?? ""
        var image:UIImage?
        
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatTimeline], content: shareTitleStr, image: image, location: nil, urlResource: nil, presentedController: self) { (response) -> Void in
            
        }
    }
    
    /// 点击微信朋友按钮
    @IBAction func touchWeChatFriendButtonAction(sender: AnyObject) {
        
//        let shareTitleStr = new?.title ?? ""
//        
//        UMSocialData.defaultData().extConfig.wechatSessionData.url = self.new?.url ?? ""
//        
//        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatSession], content: shareTitleStr, image: shareImage, location: nil, urlResource: nil, presentedController: self) { (response) -> Void in
//            
//        }
    }
    
    /// 点击QQ朋友按钮
    @IBAction func touchQQFriendButtonAction(sender: AnyObject) {
        
//        let shareTitleStr = new?.title ?? ""
//        
//        UMSocialData.defaultData().extConfig.qqData.url = self.new?.url ?? ""
//        
//        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToQQ], content: shareTitleStr, image: nil, location: nil, urlResource: nil, presentedController: self) { (response) -> Void in
//            
//        }
    }
    
    /// 点击新浪微博按钮
    @IBAction func touchSinaButtonAction(sender: AnyObject) {
        
//        let shareTitleStr = new?.title ?? ""
//        
//        let message = WBMessageObject()
//        message.text = shareTitleStr
//        
//        let request = WBSendMessageToWeiboRequest.requestWithMessage(message) as! WBSendMessageToWeiboRequest
//        WeiboSDK.sendRequest(request)
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
        mailComposer.setToRecipients(["macbaszii@gmail.com"]) // Default Recipients (optional)
        mailComposer.setSubject("http://www.macbaszii.com") // Default Subject (optional)
        mailComposer.setMessageBody("邮件内容", isHTML: false) // Default Message (optional)
        
        return mailComposer
    }
    
    private func configureMessageComposer() -> MFMessageComposeViewController {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self;
        messageComposer.body = "短息内容" // Default Message (optional)
        
        return messageComposer
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
