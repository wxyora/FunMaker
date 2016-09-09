//
//  IndexTravelDetailViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/7.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP

class IndexTravelDetailViewController: BaseViewController {
    

    
    
    @IBOutlet weak var unionTheme: UILabel!
    @IBOutlet weak var contactWay: UILabel!
    @IBOutlet weak var outTime: UILabel!
    @IBOutlet weak var reachWay: UILabel!
    @IBOutlet weak var unionContent: UITextView!
    var mobile:String = ""
    
    @IBAction func talkWithHer(sender: UIButton) {
        
        let userInfo:NSUserDefaults=NSUserDefaults.standardUserDefaults()
        let token = userInfo.valueForKey("token")
       

        if(token != nil){
            let socketToken = String(userInfo.valueForKey("socketToken")!)
            RCIM.sharedRCIM().initWithAppKey("qd46yzrf4q6yf")
            RCIM.sharedRCIM().connectWithToken(socketToken,
                                               success: { (userId) -> Void in
                                                print("登陆成功。当前登录的用户ID：\(userId)")
                }, error: { (status) -> Void in
                    print("登陆的错误码为:\(status.rawValue)")
                }, tokenIncorrect: {
                    //token过期或者不正确。
                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                    print("token错误")
            })
            //新建一个聊天会话View Controller对象
            let chat = RCConversationViewController()
            chat.displayUserNameInCell=true
            //[RCIM sharedRCIM]的globalMessageAvatarStyle属性
            
            RCIM.sharedRCIM().globalMessageAvatarStyle = .USER_AVATAR_CYCLE
            //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
            chat.conversationType = RCConversationType.ConversationType_PRIVATE
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
            chat.targetId = mobile
            
            
            //设置聊天会话界面要显示的标题
            chat.title = mobile
            
            //显示聊天会话界面
            self.navigationController?.pushViewController(chat, animated: true)
        }else{
            let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
            self.presentViewController(loginViewController, animated: true, completion: nil)

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
                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 2)
                    }
                }else{
                    
                    //关闭网络请求hud
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    self.clearAllNotice()
                    let iii = response.data.length
                    //把NSData对象转换回JSON对象
                    let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                    if json == nil {
                        self.alert("网络异常，请重试")
                        self.clearAllNotice()
                    }else{
                        let data  = json.objectForKey("data")
                        let status  = String(json.objectForKey("status")!)
                        //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                        dispatch_async(dispatch_get_main_queue()) {
                            if(status=="1"){
                                let unionTheme = data!.objectForKey("unionTheme") as? String
                                self.unionTheme.text = unionTheme
                                if self.userInfo.stringForKey("token") != nil{
                                    self.contactWay.text = data!.objectForKey("contactWay") as! String
                                }else{
                                    self.contactWay.text = "登陆后可见"
                                    self.contactWay.textColor = UIColor.redColor()
                                    
                                }
                                self.outTime.text = data!.objectForKey("outTime") as! String
                                self.unionContent.text = data!.objectForKey("unionContent") as! String
                                self.reachWay.text=data!.objectForKey("reachWay") as! String
                                self.mobile = data!.objectForKey("userId") as! String

                            }else{
                                dispatch_async(dispatch_get_main_queue()) {
                                    //self.noticeInfo("数据被删除", autoClear: true, autoClearTime: 1)
                                    self.alert("数据被主人删除了，请返回刷新数据。")
                                }
                            }
//                            
//                            if let unionTheme = data!.objectForKey("unionTheme") as? String{
//                                self.unionTheme.text = unionTheme
//                                if self.userInfo.stringForKey("token") != nil{
//                                    self.contactWay.text = data!.objectForKey("contactWay") as! String
//                                }else{
//                                    self.contactWay.text = "登陆后可见"
//                                    self.contactWay.textColor = UIColor.redColor()
//                                    
//                                }
//                                self.outTime.text = data!.objectForKey("outTime") as! String
//                                self.unionContent.text = data!.objectForKey("unionContent") as! String
//                                self.reachWay.text=data!.objectForKey("reachWay") as! String
//                                
//                            }else{
//                                dispatch_async(dispatch_get_main_queue()) {
//                                    //self.noticeInfo("数据被删除", autoClear: true, autoClearTime: 1)
//                                    self.alert("数据被主人删除了，请下拉刷新数据。")
//                                }
//                            }
//                            
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

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
