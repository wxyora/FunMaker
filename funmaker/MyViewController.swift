//
//  MyViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class MyViewController: BaseViewController {

    @IBOutlet weak var myTravelLb: UILabel!
    
    @IBOutlet weak var homeHouseLb: UILabel!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var loginNow: UIButton!

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
//            let actionSheet = UIAlertController()
//            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAciton) -> Void in
//                print("取消")
//                })
//            actionSheet.addAction(UIAlertAction(title: "从相册中选取", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
//                self.alert("从相册中选取")
//                })
//            actionSheet.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
//                self.alert("拍照")
//                })
//            
//            self.presentViewController(actionSheet, animated: true, completion: nil)
        
        }else if indexPath.row == 1{
            if token.isEmpty{
                let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
                self.navigationController?.presentViewController(loginViewController, animated: true, completion: nil)
            }else{
                let travelListViewController = storyBoard.instantiateViewControllerWithIdentifier("TravelListViewController") as! TravelListViewController
                self.navigationController?.pushViewController(travelListViewController, animated: true)
            }
        }else if indexPath.row==2{
            if token.isEmpty{
                let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
                self.navigationController?.presentViewController(loginViewController, animated: true, completion: nil)
            }else{
                let homeHotelViewController = storyBoard.instantiateViewControllerWithIdentifier("HomeHotelViewController") as! HomeHotelViewController
                self.navigationController?.pushViewController(homeHotelViewController, animated: true)
            }
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
        if token == nil{
            nickName.text = "您还没有登录哦"
            loginNow.hidden=false
            
            myTravelLb.text? = "我发布的拼团游"
            homeHouseLb.text?="我发布的民宿"
//            
//             myProfile.selectionStyle=UITableViewCellSelectionStyle.None
//            
//               myProfile.accessoryType=UITableViewCellAccessoryType.None
            
        }else{
            nickName.text = userInfo.stringForKey("mobile")!+" 已登录"
            loginNow.hidden = true
            var n :Int = 0
            let s = "(\(n))"
            myTravelLb.text?="我发布的拼团游\(s)"
            homeHouseLb.text?="我发布的民宿\(s)"
            
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


        }
    }

 
    


    //登录成功后回调
    func loginSuccessCallBack(){
        
       //self.loginStatusInfo.text="成功登录"
       //self.loginNow.hidden=true
        
    }


}
