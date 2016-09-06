//
//  RecentOrderViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/11.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP
import Alamofire


class RecentOrderViewController: BaseViewController,UISearchBarDelegate{

    var str = ["景区1","景区2","景区3","景区4","景区5","景区3","景区6"]

    @IBOutlet weak var searchedInfo: UITextView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        self.searchBar.delegate = self
        
        
        
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(IndexViewController.refreshTableView), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc

        // Do any additional setup after loading the view.
        
        //注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            //print("收回键盘")
            searchBar.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return str.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
//        cell.textLabel?.text = str[indexPath.row]
//        return cell
//    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        
        
        
        let searchNo = self.searchBar.text
        
        
        
        getData2(searchNo!)
        
        
        
        
        
    }
    
    func getData1(searchNo:String){
        
        
        
        
        //开启网络请求hud
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //self.pleaseWait()
        do {
            let opt = try HTTP.GET("http://apicloud.mob.com/train/tickets/queryByTrainNo",parameters: ["key":"152586542fe1a","trainno":searchNo])
            
            opt.start { response in
                
                if let err = response.error {
                    //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                    dispatch_async(dispatch_get_main_queue()) {
                        self.clearAllNotice()
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 2)
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
//                        if let data : NSMutableArray = json.objectForKey("result") as? NSMutableArray{
//                            dispatch_async(dispatch_get_main_queue()) {
//                                for d in data{
//                                    self.allData.addObject(d)
//                                }
//                                self.tableViewData = self.allData
//                                self.refreshControl?.endRefreshing()
//                                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
//                                self.tableView.reloadData()
//                                
//                            }
//                        }else{
//                            dispatch_async(dispatch_get_main_queue()) {
//                                self.clearAllNotice()
//                                self.noticeInfo("没有信息了", autoClear: true, autoClearTime: 1)
//                            }
//                            
//                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            let msg = String(json.objectForKey("msg")!)
                            if msg=="success"{
                                let result = String(json.objectForKey("result")!)
                                self.searchedInfo.text = result
                            }else{
                                self.searchedInfo.text = "未查到相关信息"
                            }
                        }
      
                    }
      
                    
                }
                
            }
            
        } catch {
            self.noticeError(String(error), autoClear: true, autoClearTime: 3)
        }

        
    }
    
    
    
    
    func getData2(searchNo: String) {
        
        self.pleaseWait()
        Alamofire.request(.GET, "http://apicloud.mob.com/train/tickets/queryByTrainNo", parameters: ["key":"152586542fe1a","trainno":searchNo]).validate()
            .responseJSON { response in

                
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["msg"].string=="success" {
                        print("json：",json["result"])
                        let info = String(json["result"])
                        self.searchedInfo.text = info
                       
                    }else{
                        self.searchedInfo.text = "未查到相关信息"
                    }
                }
                
                self.clearAllNotice()
        }
        
    }
    func refreshTableView(){
        
        if(self.refreshControl?.refreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            
            
            
            //add data
            let time:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_MSEC * 1000))
            //延迟
            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                //self.myLabel.text = "请点击调用按钮"
                self.refreshControl?.endRefreshing()
                
                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                
                self.tableView.reloadData()
            }
            
            
            //            refreshControl?.endRefreshing()
            //
            //            refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
            //
            //            self.tableView.reloadData()
            
        }
    }

    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return str.count
//        
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
//        cell.textLabel?.text = "Row \(str[indexPath.row])))"
//        return cell
//    }
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
