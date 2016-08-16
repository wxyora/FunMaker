//
//  TravelDetailViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/7.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP
class TravelDetailViewController: BaseViewController {
    
    @IBOutlet weak var unionTheme: UILabel!
    @IBOutlet weak var contactWay: UILabel!
    @IBOutlet weak var outTime: UILabel!
    @IBOutlet weak var reachWay: UILabel!
    @IBOutlet weak var unionContent: UITextView!

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editItem: UIBarButtonItem!
    
//    let unionTheme = data!.objectForKey("unionTheme") as! String
//    let contactWay = data!.objectForKey("contactWay") as! String
//    let outTime = data!.objectForKey("outTime") as! String
//    let unionContent = data!.objectForKey("unionContent") as! String
//    let contactWay = data!.objectForKey("contactWay") as! String
    
    @IBAction func deleteByUnion(sender: AnyObject) {
        
        let alertController:UIAlertController!=UIAlertController(title: "", message: "您确定要删除？", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){ (alertAciton) -> Void in
             self.deleteUnion()
          
            
            })
        self.presentViewController(alertController, animated: true, completion:nil)
       
    }

    
    @IBAction func editAction(sender: AnyObject) {
        //editItem.setTitleTextAttributes([String : "ddd"]?, forState: UIControlState.Normal.)
        if editItem.title == "编辑"{
             editItem.title="完成"
            deleteButton.hidden=false
        }else{
            editItem.title="编辑"
            deleteButton.hidden=true
        }
        
    }
    
    func deleteUnion() {
        
        
        
     
        
                            //开启网络请求hud
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                            self.pleaseWait()
                            do {
                                let unionId = userInfo.stringForKey("unionId")
                                let opt = try HTTP.GET(Constant.host+Constant.deleteUnion, parameters: ["unionId":unionId])
                                //                    opt.progress = { progress in
                                //                        print("progress: \(progress)") //this will be between 0 and 1.
                                //                    }
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
                                            let result : AnyObject = json.objectForKey("result")!
                                            
                                            //let mobile : AnyObject = json.objectForKey("mobile")!
                                            let str = String(result)
                                            if str=="删除成功"{
                                                
                                                //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                                                dispatch_async(dispatch_get_main_queue()) {
                                                   
                                                    self.noticeInfo("删除成功", autoClear: true, autoClearTime: 2)
                                                   self.navigationController?.popViewControllerAnimated(true)
                                                   
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            } catch {
                                print("loginValidate interface got an error creating the request: \(error)")
                            }
                            
        
                        
        
                    
        
                
        
            
        
        
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()

        initData()
    }
    
    
    func initData(){
        //开启网络请求hud
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.pleaseWait()
        do {
            let unionId = userInfo.stringForKey("unionId")
            let opt = try HTTP.GET(Constant.host+Constant.getUnionByUnionId, parameters: ["unionId":unionId])
            
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
                        
                        
                        let data  = json.objectForKey("data")
                        
                        //let mobile : AnyObject = json.objectForKey("mobile")!
                        if data !=  nil{
                            
                            
                            //                                //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                self.unionTheme.text = data!.objectForKey("unionTheme") as! String
                                self.contactWay.text = data!.objectForKey("contactWay") as! String
                                self.outTime.text = data!.objectForKey("outTime") as! String
                                self.unionContent.text = data!.objectForKey("unionContent") as! String
                                self.reachWay.text=data!.objectForKey("reachWay") as! String

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
 

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
