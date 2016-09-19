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

    @IBAction func touchShareButtonAction(_ sender: AnyObject) {
        
        self.ShareAlertShow(self)
    }
    
    @IBAction func touchMoreButtonAction(_ sender: AnyObject) {
     
        self.ShareAlertShow(self)
    }
}


extension DetailAndCommitViewController:ShareAlertDelegate{
    fileprivate func ShareMethod(_ type:String=UMShareToWechatTimeline,content:String,img:UIImage?=nil,resource:UMSocialUrlResource?=nil){
        
        UMSocialDataService.default().postSNS(withTypes: [type], content: content, image: img, location: nil, urlResource: resource, presentedController: self) { (response) -> Void in
            
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
        let pboard = UIPasteboard.general
        pboard.string = n.shareUrl()
        
        SVProgressHUD.showSuccess(withStatus: "已经拷贝至剪切板")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        })
    }
    
    func ClickEmail() {
        
        let mailComposer = configureMailComposer()
        if MFMailComposeViewController.canSendMail() {
            present(mailComposer, animated: true, completion: nil)
        } else {
            print("Email Composer Error")
        }
    }
    
    func ClickSMS() {
        
        let messageComposer = configureMessageComposer()
        if MFMessageComposeViewController.canSendText() {
            present(messageComposer, animated: true, completion: nil)
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
            
            DispatchQueue.main.async(execute: {
                let request = WBSendMessageToWeiboRequest.request(withMessage: message) as! WBSendMessageToWeiboRequest
                WeiboSDK.send(request)
            })
        }
    }
    
    func ClickQQFriends() {
        
        let alert = UIAlertController(title: "暂不支持qq", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "返回", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
    
    fileprivate func configureMailComposer() -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        guard let n = self.new else{ return mailComposer }
        mailComposer.setMessageBody(n.title+"\n"+n.shareUrl(), isHTML: false) // Default Message (optional)
        return mailComposer
    }
    
    fileprivate func configureMessageComposer() -> MFMessageComposeViewController {
        
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        guard let n = self.new else{ return messageComposer }
        messageComposer.body = n.title+"\n"+n.shareUrl() // Default Message (optional)
        return messageComposer
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}
