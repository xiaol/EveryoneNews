//
//  HomeViewController.swift
//  Journalism
//
//  Created by Mister on 16/5/16.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class ViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagerBehaviour = .Progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: false)
        
        settings.style.buttonBarItemFont = UIFont.boldSystemFontOfSize(15)
        buttonBarView.backgroundColor = UIColor.whiteColor()
        buttonBarView.selectedBar.backgroundColor = UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 0.2)
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            newCell?.label.textColor = UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 1)
        }
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let example1 = ExampleViewController()
        let example2 = ExampleViewController()
        let example3 = ExampleViewController()
        let example4 = ExampleViewController()
        let example5 = ExampleViewController()
        let example6 = ExampleViewController()
        let example7 = ExampleViewController()
        let example8 = ExampleViewController()
        let example9 = ExampleViewController()
        
        example1.vtitle = "张三"
        example2.vtitle = "企业上"
        example3.vtitle = "可爱的时刻"
        example4.vtitle = "辟邪声着"
        example5.vtitle = "好香啊"
        example6.vtitle = "企业上"
        example7.vtitle = "可爱的时刻"
        example8.vtitle = "辟邪声着"
        example9.vtitle = "好香啊"
        
        example1.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        example2.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        example3.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        example4.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        example5.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        example6.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        example7.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        example8.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        example9.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        
        return [example1,example2,example3,example4,example5,example6,example7,example8,example9]
    }
}



class ExampleViewController:UIViewController,IndicatorInfoProvider{
    
    var vtitle = ""
    
    var label:UILabel!
    
    var timer: dispatch_source_t!
    var currentQueue: dispatch_source_t!
    
    var text = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel(frame: CGRect(origin: self.view.center, size: CGSize(width: 200, height: 40)))

        self.view.addSubview(label)
        
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_queue_create("com.gcd.timeout", nil))
        dispatch_source_set_timer(timer!, dispatch_walltime(nil, 0), 1*NSEC_PER_SEC, 0)
        dispatch_source_set_event_handler(timer!, { () -> Void in
            
            self.text = self.text+1
            
            dispatch_async(dispatch_get_main_queue(), { 
                
                self.label.text = "\(self.text)"
            })
            
        })
        //启动 dispatch source
        dispatch_resume(timer!)
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: vtitle)
        
        return info
    }
}




