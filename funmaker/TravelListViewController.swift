//
//  TravelListViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/6.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP

class TravelListViewController: BaseViewController ,UISearchBarDelegate{
    
    
    var tableViewData:AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(TravelListViewController.refreshTableView), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()
        initData()

    }
    
    func refreshTableView(){
        
        if(self.refreshControl?.refreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            //add data
            //let time:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_MSEC * 1000))
            //延迟
//            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
//                //self.myLabel.text = "请点击调用按钮"
//                self.refreshControl?.endRefreshing()
//                
//                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
//                
//                self.tableView.reloadData()
//            }
            getData()
            
            //            refreshControl?.endRefreshing()
            //
            //            refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
            //
            //            self.tableView.reloadData()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
        //开启网络请求hud
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.pleaseWait()
        do {
            let opt = try HTTP.GET(Constant.host+Constant.getUnionByUser, parameters: ["userId":getMobie()])
            
            opt.start { response in
                
                if let err = response.error {
                    if String(err.code)=="-1001"{
                        self.alert("网络不给力，请重试。")
                    }
                    self.clearAllNotice()
                    //关闭网络请求hud
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.notice(err.localizedDescription, type: NoticeType.info, autoClear: true)
                    //return
                }else{
                    
                    //关闭网络请求hud
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    self.clearAllNotice()
                    //把NSData对象转换回JSON对象
                    let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                    if json == nil {
                        self.alert("网络异常，请重试")
                        self.clearAllNotice()
                    }else{
                        
                        
                        let data : NSArray = json.objectForKey("data") as! NSArray
                        
                        //let mobile : AnyObject = json.objectForKey("mobile")!
                        if data.count != 0{
                            
                            //                                //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableViewData = data
                                self.tableView.reloadData()
                            }
                        }else{
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.noticeInfo("没有数据", autoClear: true, autoClearTime: 1)
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        } catch {
            print("loginValidate interface got an error creating the request: \(error)")
        }
    }
    
    func getData(){
        
            //开启网络请求hud
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            //self.pleaseWait()
            do {
                let opt = try HTTP.GET(Constant.host+Constant.getUnionByUser, parameters: ["userId":getMobie()])

                opt.start { response in
                    
                    if let err = response.error {
                        if String(err.code)=="-1001"{
                            self.alert("网络不给力，请重试。")
                        }
                        //self.clearAllNotice()
                        //关闭网络请求hud
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        //self.notice(err.localizedDescription, type: NoticeType.info, autoClear: true)
                        //return
                    }else{
                        
                        //关闭网络请求hud
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        //self.clearAllNotice()
                        //把NSData对象转换回JSON对象
                        let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                        if json == nil {
                            self.alert("网络异常，请重试")
                            self.clearAllNotice()
                        }else{
                            let data : NSArray = json.objectForKey("data") as! NSArray
                            //let mobile : AnyObject = json.objectForKey("mobile")!
                            if data.count != 0{
//                                //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.tableViewData = data
                                    self.refreshControl?.endRefreshing()
                                    self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                                    self.tableView.reloadData()
                                }
                                
                                
                                //self.clearAllNotice()
                            }else{
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.noticeInfo("没有数据", autoClear: true, autoClearTime: 1)
                                 }
                               
                            }
                            
                            
                           
                            
                        }
                        
                    }
                    
                }
                
            } catch {
                print("loginValidate interface got an error creating the request: \(error)")
            }
            
        
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableViewData == nil{
            return 0
           
        }else{
            return tableViewData!.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:TogetherTravelCell! = tableView.dequeueReusableCellWithIdentifier("TogetherTravelCell", forIndexPath: indexPath) as? TogetherTravelCell
        if(cell == nil){
            cell = TogetherTravelCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TogetherTravelCell")
        }else{
            
            let unionTheme:String = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("unionTheme"))
            let outTime = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("outTime"))
            let unionId = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("unionId"))
            cell.themeTitle.text = unionTheme
            cell.outDate.text=outTime
            cell.unionId.text=unionId
        
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      
        
        
        
        let travelDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("TravelDetailViewController") as! TravelDetailViewController
        self.navigationController?.pushViewController(travelDetailViewController, animated: true)
      
            
      
    }

 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
