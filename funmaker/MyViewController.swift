//
//  MyViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP

class MyViewController: BaseViewController {

    @IBOutlet weak var myTravelLb: UILabel!
    
    @IBOutlet weak var homeHouseLb: UILabel!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var loginNow: UIButton!
    
    var thumbQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(MyViewController.refreshTableView), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        valideLoginState()
        self.navigationController!.navigationBar.tintColor=UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]


        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()
        
        
        let userInfo=NSUserDefaults.standardUserDefaults()
        let token  =  userInfo.objectForKey("token")
        if token != nil{
            initData()
        }
        
        
        //设置头像圆角
        headImage.layer.cornerRadius = headImage.frame.width/2
        //设置遮盖额外部分,下面两句的意义及实现是相同的
        //      headImage.clipsToBounds = true
        headImage.layer.masksToBounds = true
        
        headImage.layer.borderWidth=1
        headImage.layer.borderColor = UIColor.grayColor().CGColor
        
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       // alert(String(indexPath.row))
          let token = getToken()
        if indexPath.row == 0{
            if token.isEmpty{
                let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
                self.navigationController?.presentViewController(loginViewController, animated: true, completion: nil)
            }else{
                let myProfileViewController = storyBoard.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
                self.navigationController?.pushViewController(myProfileViewController, animated: true)
            }
        
        }else if indexPath.row == 2{
            if token.isEmpty{
                let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
                self.navigationController?.presentViewController(loginViewController, animated: true, completion: nil)
            }else{
                let travelListViewController = storyBoard.instantiateViewControllerWithIdentifier("TravelListViewController") as! TravelListViewController
                self.navigationController?.pushViewController(travelListViewController, animated: true)
            }
        }else if indexPath.row==3{
        
            self.noticeInfo("敬请期待...", autoClear: true, autoClearTime:1)

//            if token.isEmpty{
//                let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
//                self.navigationController?.presentViewController(loginViewController, animated: true, completion: nil)
//            }else{
//                let homeHotelViewController = storyBoard.instantiateViewControllerWithIdentifier("HomeHotelViewController") as! HomeHotelViewController
//                self.navigationController?.pushViewController(homeHotelViewController, animated: true)
//            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
         //接收登录成功的通知
         //NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MyViewController.doSome(_:)), name: "LoginSuccessNotification", object: nil)
         //NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MyViewController.doLoginOut(_:)), name: "LoginOutSuccessNotification", object: nil)
        
        
        valideLoginState()
    }
    
    func doSome(notification:NSNotification){
        
        valideLoginState()
        //self.noticeSuccess("登录成功", autoClear: true, autoClearTime:3)
    }
    
    
    func doLoginOut(notification:NSNotification){
        
        valideLoginState()
        //self.noticeSuccess("退出成功", autoClear: true, autoClearTime:3)
    }
    
    
    func valideLoginState(){
        
        //let myProfile = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "myProfileId") as UITableViewCell
        
        
    
       
        let userInfo=NSUserDefaults.standardUserDefaults()
        let token  =  userInfo.objectForKey("token")
        let headObj = userInfo.objectForKey("headImage")
        var headName = ""
        
        if token == nil{
            nickName.text = "您还没有登录哦"
            loginNow.hidden=false
            myTravelLb.text? = "我的拼团游"
            homeHouseLb.text?="我的民宿"
            let head=UIImage(named: "packman")
            self.headImage.image=head
  
        }else{
            nickName.text = userInfo.stringForKey("mobile")!+" 已登录"
            loginNow.hidden = true
            getData()
            
             headName  =  String(headObj!)
            if headName != ""{
               
                
                
                
                
                
                
//                
//                var str = Constant.host+Constant.headImageUrl+headName+".png"
//                //防止url报出空指针异常
//                str = str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//                let url:NSURL = NSURL(string:str)!
//                
//                let request = NSURLRequest(URL:url)
//                NSURLConnection.sendAsynchronousRequest(request, queue: thumbQueue, completionHandler: { response, data, error in
//                    if (error != nil) {
//                        print(error)
//                        
//                    } else {
//                        let image = UIImage.init(data :data!)
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.headImage.image = image
//                        })
//                    }
//                })
                
                
                
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
                           self.headImage.image = ZYHImage
                        })
                    }
                 })
    
            }

            
            //从文件读取用户头像
//            let fullPath = ((NSHomeDirectory() as NSString) .stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent("currentImage.png")
//            //可选绑定,若保存过用户头像则显示之
//            if let savedImage = UIImage(contentsOfFile: fullPath){
//                self.headImage.image = savedImage
//            }

            
//            myProfile.selectionStyle=UITableViewCellSelectionStyle.Default
//            myProfile.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
  
        }
        self.refreshControl?.endRefreshing()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.tableView.reloadData()
    }

    
    
    func refreshTableView(){
        
        if(self.refreshControl?.refreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            
            valideLoginState()

            //getData()

        }
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
                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime:2)
                    }
                }else{
                    
                    //关闭网络请求hud
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    self.clearAllNotice()
                    //把NSData对象转换回JSON对象
                    let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                    if json == nil {
                        self.alert("网络异常，请重试")
                    }else{

                        let data : NSArray = json.objectForKey("data") as! NSArray
  
                            //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                            dispatch_async(dispatch_get_main_queue()) {
                                let n :Int = data.count
                                let s = "(\(n))"
                                self.myTravelLb.text?="我的拼团游\(s)"
                                //self.homeHouseLb.text?="我的民宿\(s)"
                            }
                    }
                    
                }
                
            }
            
        } catch {
             self.noticeError(String(error), autoClear: true, autoClearTime: 3)
        }
    }
    
    func getData(){
        
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
                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime:2)
                    }                }else{
                    
                    //关闭网络请求hud
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.clearAllNotice()
                    //把NSData对象转换回JSON对象
                    let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                    if json == nil {
                        self.alert("网络异常，请重试")
                      
                    }else{
                        let data : NSArray = json.objectForKey("data") as! NSArray
                        //let mobile : AnyObject = json.objectForKey("mobile")!
                        
                          //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                            dispatch_async(dispatch_get_main_queue()) {
                                //self.tableViewData! = data
                                var n :Int = data.count
                                let s = "(\(n))"
                                self.myTravelLb.text?="我的拼团游\(s)"
                                //self.homeHouseLb.text?="我的民宿\(s)"

                                self.refreshControl?.endRefreshing()
                                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                                self.tableView.reloadData()
                            }
                            
                            
                        
                        
                        
                        
                    }
                    
                }
                
            }
            
        } catch {
            self.noticeError(String(error), autoClear: true, autoClearTime: 3)
                   }
        
        
    }

    


    //登录成功后回调
    func loginSuccessCallBack(){
        
       //self.loginStatusInfo.text="成功登录"
       //self.loginNow.hidden=true
        
    }


}
