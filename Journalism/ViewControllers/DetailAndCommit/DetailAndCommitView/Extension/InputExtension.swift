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
    
    @IBAction func touchBackViewAction(sender: AnyObject) {
        
        self.inputTextView.resignFirstResponder()
    }
    
    /// 创建评论对象
    @IBAction func CreateComment(sender: AnyObject) {
        
        if let n = self.new {
        
            CommentUtil.CreateCommentMethod(self.inputTextView.text, new: n, finish: {
                
                self.inputTextView.resignFirstResponder()
                
                let realm = try! Realm()
                let normalResults = realm.objects(Comment.self).filter("nid = \(n.nid)")
                self.commentsLabel.text = "\(normalResults.count)"
                
                if let tableView = self.commitViewController.tableView{
                    let indexPath = NSIndexSet(index: 1)
                    tableView.reloadSections(indexPath, withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                }, fail: { 
                    
                    SVProgressHUD.showErrorWithStatus("评论失败")
                    SVProgressHUD.dismissWithDelay(1.5)
            })
        }
    }
    
    @IBAction func touchTextFiledAction(sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
        
            NSNotificationCenter.defaultCenter().postNotificationName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil)
        }else{
        
            self.inputTextView.becomeFirstResponder()
        }
    }
    
    func resignNotification(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailAndCommitViewController.keyboardShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailAndCommitViewController.keyboardHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    //通知中心通知键盘要出现了！  😳   全员戒备！
    func keyboardShow(note:NSNotification){
        
        if !self.inputTextView.isFirstResponder() {return}
        
        self.textViewDidChange(self.inputTextView)
        
        if let info = note.userInfo {
            let keyboardFrame:CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let deltay:CGFloat = keyboardFrame.size.height as CGFloat
            self.inputContentViewBottomConstraint.constant = deltay
        }
        
        UIView.animateWithDuration(0.3) {
            
            self.inputBackView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    //通知中心通知键盘要消失了  😄  解散~  庆功宴~~
    func keyboardHide(note:NSNotification){
        
        if !self.inputTextView.isFirstResponder() {return}
        
        UIView.animateWithDuration(0.3) {
            
            self.inputBackView.alpha = 0
            self.inputContentViewBottomConstraint.constant = 0
            
            self.view.layoutIfNeeded()
        }
        
        self.inputTextView.text = ""
        self.textViewDidChange(self.inputTextView)
    }
    
    
    func textViewDidChange(textView: UITextView) {
        
        self.inputCommitButton?.enabled = textView.text.characters.count > 0
    }
}
