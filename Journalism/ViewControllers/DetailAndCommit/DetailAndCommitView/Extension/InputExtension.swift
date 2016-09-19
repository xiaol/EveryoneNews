//
//  InputExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/2.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift

extension DetailAndCommitViewController:UITextViewDelegate{
    
    override func becomeFirstResponder() -> Bool {
        
        return true
    }
    
    @IBAction func touchBackViewAction(_ sender: AnyObject) {
        
        self.inputTextView.resignFirstResponder()
    }
    
    /// 创建评论对象
    @IBAction func CreateComment(_ sender: AnyObject) {
        
        if let n = self.new {
        
            CustomRequest.commentNew(self.inputTextView.text, new: n, finish: {
                
                self.inputTextView.resignFirstResponder()
                
                let realm = try! Realm()
                let normalResults = realm.objects(Comment.self).filter("nid = \(n.nid)")
                self.commentsLabel.text = "\(normalResults.count)"
                
                SVProgressHUD.showSuccess(withStatus: "评论成功")
                
                NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: USERCOMMENTNOTIFITION), object: nil)
                
                if let tableView = self.commitViewController.tableView{
                    let indexPath = IndexSet(integer: 1)
                    tableView.reloadSections(indexPath, with: UITableViewRowAnimation.automatic)
                }
                
                }, fail: { 
                    
                    SVProgressHUD.showError(withStatus: "评论失败")
            })
        }
    }
    
    @IBAction func touchTextFiledAction(_ sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
        
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
        }else{
        
            self.inputTextView.becomeFirstResponder()
        }
    }
    
    func resignNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailAndCommitViewController.keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailAndCommitViewController.keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //通知中心通知键盘要出现了！  😳   全员戒备！
    func keyboardShow(_ note:Foundation.Notification){
        
        if !self.inputTextView.isFirstResponder {return}
        
        self.textViewDidChange(self.inputTextView)
        
        if let info = (note as NSNotification).userInfo {
            let keyboardFrame:CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let deltay:CGFloat = keyboardFrame.size.height as CGFloat
            self.inputContentViewBottomConstraint.constant = deltay
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.inputBackView.alpha = 1
            self.view.layoutIfNeeded()
        }) 
    }
    //通知中心通知键盘要消失了  😄  解散~  庆功宴~~
    func keyboardHide(_ note:Foundation.Notification){
        
        if !self.inputTextView.isFirstResponder {return}
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.inputBackView.alpha = 0
            self.inputContentViewBottomConstraint.constant = 0
            
            self.view.layoutIfNeeded()
        }) 
        
        self.inputTextView.text = ""
        self.textViewDidChange(self.inputTextView)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.inputCommitButton?.isEnabled = textView.text.characters.count > 0
    }
}
