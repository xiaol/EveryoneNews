//
//  CollectionViewController.swift
//  EveryoneNews
//
//  Created by Mister on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import CoreData


extension UIStoryboard{

    /// 获取单例模式下的UIStoryBoard对象
    class var shareCollectionBoard:UIStoryboard!{
        get{
            struct backTaskLeton{
                static var predicate:dispatch_once_t = 0
                static var bgTask:UIStoryboard? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                backTaskLeton.bgTask = UIStoryboard(name: "Collection", bundle: NSBundle.mainBundle())
            })
            
            return backTaskLeton.bgTask
        }
    }
    
    /**
     获取收藏页面 UIViewController
     
     - returns: Class UIViewController
     */
    func getCollectionViewController() -> UIViewController{
    
        return self.instantiateViewControllerWithIdentifier("CollectionViewController")
    }
}






class CollectionViewController:UIViewController{
    
    // 左上角的管理按钮
    @IBOutlet var managerButton: UIButton!
    // 下方的删除按钮
    @IBOutlet var deleteButton: UIButton!
    // 页面内的表格视图对象
    @IBOutlet var tableView: UITableView!
    // 因为某些关系，不得不自己做一个选中的NSIndexPath 集合
    private var selectIndexPaths = NSMutableArray()
    
    /// 收藏的卡片集合
    private var dataSource = [CardFrame]()
    
    // 数据库访问上下文
    private let importContext:NSManagedObjectContext = {
        let cdh = (UIApplication.sharedApplication().delegate as! AppDelegate).cdh()
        return cdh.context
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "UserCollectionedChangeer:", name: "UserCollectionedChangeer", object: nil)// 注册一个当数据库某个对象的收藏属性发生变化的监听者
        
        self.reloadTableViewDataSource()
        self.tableView.reloadData()
        
        self.deleteButton.transform = CGAffineTransformTranslate(self.deleteButton.transform, 0, self.deleteButton.frame.height) // 默认讲删除按钮隐藏
    }
    
    // 接收到对象的收藏属性变化
    func UserCollectionedChangeer(aNotification:NSNotification){
    
        self.reloadTableViewDataSource()
        
        self.tableView.reloadData()
    }
}


extension CollectionViewController{

    /// 刷新tableView数据
    private func reloadTableViewDataSource(){
        
        self.dataSource.removeAll()
        
        let fetch = NSFetchRequest()
        fetch.entity = NSEntityDescription.entityForName("Card", inManagedObjectContext: self.importContext)
        fetch.predicate = NSPredicate(format: "isCollected = 1")
        let names = try! self.importContext.executeFetchRequest(fetch)
        
        names.forEach { (card) in
            if let cd = card as? Card {
                let cf = CardFrame()
                cf.card = cd
                dataSource.append(cf)
            }
        }
        
        self.tableView.hidden = dataSource.count <= 0
        self.managerButton.hidden = dataSource.count <= 0
    }
    
    /// pop到上一个UIViewController 方法
    @IBAction func PopViewController(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}


// MARK: UItableViewDataSource
extension CollectionViewController{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? CollectionViewCell
        
        if cell == nil {
        
            cell = CollectionViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        cell?.cardFrame = self.dataSource[indexPath.row]
        
        cell?.selectionStyle = tableView.editing ? .Default : .None
        
        print(self.dataSource[indexPath.row].card.isCollected)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.dataSource[indexPath.row].cellHeight
    }
}


// MARK: UItableViewDelegate 相关方
extension CollectionViewController{
    
    // 点击删除按钮
    @IBAction func deleteSelectObject(sender: AnyObject) {
        
        if let selects = self.selectIndexPaths.copy() as? [NSIndexPath] {
        
            if selects.count <= 0 {return}
            
            selects.forEach({ (indexPath) in
              
                let card = dataSource[indexPath.row].card
                
                let cardd = try! self.importContext.existingObjectWithID(card.objectID) as! Card
                
                cardd.isCollected = NSNumber(integer: 0)
            
                try! self.importContext.save()
            })
            
            self.reloadTableViewDataSource()

            tableView.deleteRowsAtIndexPaths(selects, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        self.clickDeleteButton()
        
        self.tableView.reloadData()
    }
    
    // 点击管理按钮
    @IBAction func editTableView(sender: AnyObject) {
        
        self.clickDeleteButton()
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
    
        return true
    }
    
    // 滑动删除
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
    
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let card = dataSource[indexPath.row].card
            
            card.isCollected = NSNumber(integer: 0)
            
            Card.updateCard(card)
            //card.updateCard(card)
            
//            let cardd = try! self.importContext.existingObjectWithID(card.objectID) as! Card
//            
//            cardd.isCollected = NSNumber(integer: 0)
//            
//            try! self.importContext.save()
            
            self.reloadTableViewDataSource()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        self.tableView.reloadData()
    }
    
    // 设置编辑风格
     func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
    
        return UITableViewCellEditingStyle.Delete
    }

    // 选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if !self.selectIndexPaths.containsObject(indexPath) {
        
            self.selectIndexPaths.addObject(indexPath)
        }
        
        if tableView.editing {
        
            self.setDeleteButtonParams()
        }else{
        
            let cardFrame = self.dataSource[indexPath.row]
            let detailVc = LPDetailViewController()
            detailVc.cardID = cardFrame.card.objectID
            detailVc.isRead = cardFrame.card.isRead;
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    
    // 取消选中
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.selectIndexPaths.containsObject(indexPath) {
            
            self.selectIndexPaths.removeObject(indexPath)
        }
        
        self.setDeleteButtonParams()
    }
    
    // 点击删除按钮
    private func clickDeleteButton(){
    
        self.tableView.setEditing(!self.tableView.editing, animated: true)
        
        self.tableView.visibleCells.forEach { (cell) in
            
            cell.selectionStyle = self.tableView.editing ? .Default : .None
        }
        
        self.deleteButton.enabled = false
        
        self.deleteButton.setTitle("删除", forState: UIControlState.Normal)
        self.deleteButton.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        
        UIView.animateWithDuration(0.3) {
            
            let y = !self.tableView.editing ? CGAffineTransformTranslate(self.deleteButton.transform, 0, self.deleteButton.frame.height) : CGAffineTransformIdentity
            
            self.deleteButton.transform = y
        }
    }
    
    
    /// 根据选中的收藏数目个数进行删除按钮的设置
    private func setDeleteButtonParams(){
    
        if tableView.indexPathsForSelectedRows?.count > 0 {
            
            self.deleteButton.enabled = true
            self.deleteButton.backgroundColor = UIColor(red: 240/255, green: 71/255, blue: 0, alpha: 1)
            self.deleteButton.setTitle("删除(\(tableView.indexPathsForSelectedRows!.count))", forState: UIControlState.Normal)
        }else{
            
            self.deleteButton.enabled = false
            self.deleteButton.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
            self.deleteButton.setTitle("删除", forState: UIControlState.Normal)
        }
    }
}
