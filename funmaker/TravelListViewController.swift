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
       // initData()

    }
    
    override func viewWillAppear(animated: Bool) {
       initData()
    }
    
    func refreshTableView(){
        
        if(self.refreshControl?.refreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            getData()
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
            let opt = try HTTP.GET(Constant.host+Constant.getUnionByUser, parameters: ["userId":getMobile()])
            
            opt.start { response in
                
                if let err = response.error {
                    //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                    dispatch_async(dispatch_get_main_queue()) {
                        self.clearAllNotice()
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 5)
                    }
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
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableViewData = data
                            self.refreshControl?.endRefreshing()
                            self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                            self.tableView.reloadData()
                             self.clearAllNotice()
                            if data.count == 0{
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
                let opt = try HTTP.GET(Constant.host+Constant.getUnionByUser, parameters: ["userId":getMobile()])

                opt.start { response in
                    
                    if let err = response.error {
                        //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                        dispatch_async(dispatch_get_main_queue()) {
                            self.clearAllNotice()
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 5)
                        }
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
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableViewData = data
                                self.refreshControl?.endRefreshing()
                                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                                self.tableView.reloadData()
                                if data.count == 0{
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
            
            let unionTheme:String = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("unionTheme")!)
            let outTime = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("outTime")!)
            let unionId = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("unionId")!)
            let publishTime = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("publishTime")!)
            //解决Optional("***")问题
            cell.themeTitle.text = unionTheme
            cell.outTime.text=outTime
            cell.unionId.text=unionId
            cell.publishTime.text=publishTime
            
            
            let headObj = userInfo.objectForKey("headImage")
            var headName  =  String(headObj!)
            if headName != ""{
                let dispath=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                dispatch_async(dispath, { () -> Void in
                    
                    var str = Constant.host+Constant.headImageUrl+headName+".png"
                    //防止url报出空指针异常
                    str = str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    let url:NSURL = NSURL(string:str)!
                    let data=NSData(contentsOfURL: url)
                    
                    if data != nil {
                        let ZYHImage=UIImage(data: data!)
                        //写缓存
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //刷新主UI
                            cell.myHeadImage.image = ZYHImage
                        })
                    }
                })
            }else{
                let head=UIImage(named: "packman")
                cell.myHeadImage.image=head
            }
            
          
//            let headObj = userInfo.objectForKey("headImage")
//            var headName = ""
//            headName  =  String(headObj!)
//            if headName != ""{
//                var str = Constant.host+Constant.headImageUrl+headName+".png"
//                //防止url报出空指针异常
//                // str = str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//                let url:NSURL = NSURL(string:str)!
//                let data=NSData(contentsOfURL: url)
//                let image = UIImage(data:data!)
//                cell.myHeadImage.image = image
//            }
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      
        
        var cell:TogetherTravelCell = tableView.cellForRowAtIndexPath(indexPath) as! TogetherTravelCell
        let unionId = cell.unionId.text
        
        userInfo.setObject(unionId, forKey: "unionId")
        userInfo.synchronize()
        
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
