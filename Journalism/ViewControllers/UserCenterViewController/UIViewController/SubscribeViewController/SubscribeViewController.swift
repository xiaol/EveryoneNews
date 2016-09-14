//
//  SubscribeViewController.swift
//  Journalism
//
//  Created by Mister on 16/9/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

@objc protocol SubscribeViewControllerDelegate {
    
    optional func ClickFinishButton(hasSubscribe:Bool)
}


class SubscribeViewController: UIViewController {
    
    private var clickFinishButtonBlock:((hasSubscribe:Bool)->Void)?
    private var delegate:SubscribeViewControllerDelegate?
    
    //MARK: 视图集合
    @IBOutlet var FinishButton:UIButton!
    
    @IBOutlet var SubscribeLabel0:UILabel!
    @IBOutlet var SubscribeLabel1:UILabel!
    @IBOutlet var SubscribeLabel2:UILabel!
    @IBOutlet var SubscribeLabel3:UILabel!
    @IBOutlet var SubscribeLabel4:UILabel!
    @IBOutlet var SubscribeLabel5:UILabel!
    @IBOutlet var SubscribeLabel6:UILabel!
    @IBOutlet var SubscribeLabel7:UILabel!
    @IBOutlet var SubscribeLabel8:UILabel!
    
    @IBOutlet var SubscribeImageView0:UIImageView!
    @IBOutlet var SubscribeImageView1:UIImageView!
    @IBOutlet var SubscribeImageView2:UIImageView!
    @IBOutlet var SubscribeImageView3:UIImageView!
    @IBOutlet var SubscribeImageView4:UIImageView!
    @IBOutlet var SubscribeImageView5:UIImageView!
    @IBOutlet var SubscribeImageView6:UIImageView!
    @IBOutlet var SubscribeImageView7:UIImageView!
    @IBOutlet var SubscribeImageView8:UIImageView!
    
    @IBOutlet var SubscribeButton0:UIButton!
    @IBOutlet var SubscribeButton1:UIButton!
    @IBOutlet var SubscribeButton2:UIButton!
    @IBOutlet var SubscribeButton3:UIButton!
    @IBOutlet var SubscribeButton4:UIButton!
    @IBOutlet var SubscribeButton5:UIButton!
    @IBOutlet var SubscribeButton6:UIButton!
    @IBOutlet var SubscribeButton7:UIButton!
    @IBOutlet var SubscribeButton8:UIButton!
    
    class func defaultViewController(delegate:SubscribeViewControllerDelegate? = nil,clickFinishButtonBlock:((hasSubscribe:Bool)->Void)? = nil) -> SubscribeViewController{
    
        let subscribeViewController = UIStoryboard.shareUserStoryBoard.instantiateViewControllerWithIdentifier("SubscribeViewController") as! SubscribeViewController
        subscribeViewController.clickFinishButtonBlock = clickFinishButtonBlock
        subscribeViewController.delegate = delegate
        return subscribeViewController
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setRandICONAndText()
        
        self.FinishButton.setBackgroundColor(UIColor.hexStringToColor("#bdc3c7"), forState: UIControlState.Normal)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SubscribeViewController.SubscribeStateChange), name: "SubscribeStateChange", object: nil)
    }
    
    @IBAction func ClickFinishButtonAction(s:AnyObject){
        
        let hasSubscribe = self.FinishButton.backgroundImageForState(UIControlState.Normal) == UIColor.hexStringToColor("#0091fa")
        
        self.clickFinishButtonBlock?(hasSubscribe: hasSubscribe)
        
        self.delegate?.ClickFinishButton?(hasSubscribe)
    }

}



//MARK: 显示订阅视图相关
extension SubscribeViewController{

    /**
     NSNotificationCenter Selector 当页面内的某一个订阅发生变化
     */
    func SubscribeStateChange(){
        
        var count = 0
        
        for button in SubscribeButtons() {
            
            if button.imageForState(UIControlState.Normal) == CustomSubscribeButton.CSelectImg {
                
                count += 1
            }
        }
        
        if count > 0 {
            
            self.FinishButton.setBackgroundColor(UIColor.hexStringToColor("#0091fa"), forState: UIControlState.Normal)
        }else{
            
            self.FinishButton.setBackgroundColor(UIColor.hexStringToColor("#bdc3c7"), forState: UIControlState.Normal)
        }
    }
    
    /**
     返回 订阅项目 标签试图 集合
     
     - returns: 标签集合
     */
    private func SubscribeLabes() -> [UILabel] {
        
        return [SubscribeLabel0,SubscribeLabel1,SubscribeLabel2,SubscribeLabel3,SubscribeLabel4,SubscribeLabel5,SubscribeLabel6,SubscribeLabel7,SubscribeLabel8]
    }
    
    /**
     返回 订阅项目 标签ICON 集合
     
     - returns: ICON 集合
     */
    private func SubscribeImageViews() -> [UIImageView] {
        
        return [SubscribeImageView0,SubscribeImageView1,SubscribeImageView2,SubscribeImageView3,SubscribeImageView4,SubscribeImageView5,SubscribeImageView6,SubscribeImageView7,SubscribeImageView8]
    }
    
    /**
     订阅项目 订阅 按钮集合
     
     - returns: 按钮集合
     */
    private func SubscribeButtons() -> [UIButton] {
        
        return [SubscribeButton0,SubscribeButton1,SubscribeButton2,SubscribeButton3,SubscribeButton4,SubscribeButton5,SubscribeButton6,SubscribeButton7,SubscribeButton8]
    }
    
    /**
     设置当前页面的随机订阅号显示
     */
    private func setRandICONAndText(){
        
        let subscribeLabes = self.SubscribeLabes()
        let subscribeImageViews = self.SubscribeImageViews()
        
        for (index,subscribe) in Subscribe.RandSubscribeArray().enumerate() {
            
            subscribeLabes[index].text = subscribe.title
            subscribeImageViews[index].image = UIImage(named: subscribe.imageName)
        }
    }
}
