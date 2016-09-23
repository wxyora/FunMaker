//
//  TravelListViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/6.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import Alamofire

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
        rc.addTarget(self, action: #selector(TravelListViewController.refreshTableView), for: UIControlEvents.valueChanged)
        self.refreshControl = rc
        
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()
        initData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
       initData()
    }
    
    func refreshTableView(){
        
        if(self.refreshControl?.isRefreshing==true){
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
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.pleaseWait()
        
        
        Alamofire.request(Constant.host+Constant.getUnionByUser,method:.get, parameters: ["userId":getMobile()])
            .responseJSON { response in
                
                if let myJson = response.result.value {
   
                    if let data : NSArray = ((myJson as AnyObject).object(forKey: "data") as? NSArray){
                        DispatchQueue.main.async { [weak self] in
                            if data.count == 0{
                                self?.clearAllNotice()
                                self?.noticeInfo("还没有发布信息", autoClear: true, autoClearTime: 1)

                            }else{
                                self?.tableViewData = data
                                //                            self?.refreshControl?.endRefreshing()
                                //                            self?.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                                self?.tableView.reloadData()

                            }
                            
                          }
                    }                }
                
                self.clearAllNotice()
                
        }

    }
    
    func getData(){
        
      Alamofire.request(Constant.host+Constant.getUnionByUser,method:.get, parameters: ["userId":getMobile()])
            .responseJSON { response in
                
                if let myJson = response.result.value {
                    
                    
                    
                    if let data : NSArray = ((myJson as AnyObject).object(forKey: "data") as? NSArray){
                        DispatchQueue.main.async { [weak self] in
                            if data.count == 0{
                                self?.clearAllNotice()
                                self?.noticeInfo("还没有发布信息", autoClear: true, autoClearTime: 1)
                            }else{
                                self?.tableViewData = data
                               
                                self?.tableView.reloadData()

                            }
                            self?.refreshControl?.endRefreshing()
                            self?.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                        }
                    }
                }
                 self.clearAllNotice()
            }
        
                
        }
        
        
        
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableViewData == nil{
            return 0
           
        }else{
            return tableViewData!.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:TogetherTravelCell! = tableView.dequeueReusableCell(withIdentifier: "TogetherTravelCell", for: indexPath) as? TogetherTravelCell
        if(cell == nil){
            cell = TogetherTravelCell(style: UITableViewCellStyle.default, reuseIdentifier: "TogetherTravelCell")
        }else{
            
             //let unionTheme = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "unionTheme") as! String
            
            let unionTheme = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "unionTheme") as! String
            let unionId = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "unionId") as! String
            let outTime = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "outTime") as! String
            let publishTime = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "publishTime") as! String
            let mobile = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "userId") as! String
           

            //解决Optional("***")问题
            cell.themeTitle.text = unionTheme
            cell.outTime.text=outTime
            cell.unionId.text=unionId
            cell.publishTime.text=publishTime
            
            
            let headObj = userInfo.object(forKey: "headImage")
            var headName  =  String(describing: headObj!)
            if headName != ""{
                let dispath=DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
                dispath.async(execute: { () -> Void in
                    
                    var str = Constant.head_image_host+headName+".png"
                    //防止url报出空指针异常
                    str = str.addingPercentEscapes(using: String.Encoding.utf8)!
                    let url:URL = URL(string:str)!
                    let data=try? Data(contentsOf: url)
                    
                    if data != nil {
                        let ZYHImage=UIImage(data: data!)
                        //写缓存
                        DispatchQueue.main.async(execute: { () -> Void in
                            //刷新主UI
                            cell.myHeadImage.image = ZYHImage
                        })
                    }
                })
            }else{
                let head=UIImage(named: "skull")
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      
        
        let cell:TogetherTravelCell = tableView.cellForRow(at: indexPath) as! TogetherTravelCell
        let unionId = cell.unionId.text
        
        userInfo.set(unionId, forKey: "unionId")
        userInfo.synchronize()
        
        let travelDetailViewController = storyBoard.instantiateViewController(withIdentifier: "TravelDetailViewController") as! TravelDetailViewController
     
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
