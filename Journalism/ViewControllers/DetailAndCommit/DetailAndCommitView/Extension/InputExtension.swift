//
//  InputExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/2.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension DetailAndCommitViewController:UITextViewDelegate{
    
    override func becomeFirstResponder() -> Bool {
        
        return true
    }
    
    @IBAction func touchBackViewAction(sender: AnyObject) {
        
        self.inputTextView.resignFirstResponder()
    }
    
    
    @IBAction func touchTextFiledAction(sender: AnyObject) {
        
        self.inputTextView.becomeFirstResponder()
    }
    
    func resignNotification(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailAndCommitViewController.keyboardShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailAndCommitViewController.keyboardHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    //通知中心通知键盘要出现了！  😳   全员戒备！
    func keyboardShow(note:NSNotification){
        
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
        
        self.inputTextView.text = ""
        
        self.textViewDidChange(self.inputTextView)
        
        self.inputContentViewBottomConstraint.constant = 0
        
        UIView.animateWithDuration(0.3) {
            
            self.inputBackView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textViewDidChange(textView: UITextView) {
        
        self.inputCommitButton?.enabled = textView.text.characters.count > 0
        
        self.inputViewHeightConstraint.constant = textView.contentSize.height+29+14+18+17
        
        self.view.layoutIfNeeded()
    }
}
