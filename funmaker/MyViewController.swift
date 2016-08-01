//
//  MyViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController {

    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var loginNow: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(MyViewController.refreshTableView), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        valideLoginState()
        
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
         //接收登录成功的通知
         NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MyViewController.doSome(_:)), name: "LoginSuccessNotification", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MyViewController.doLoginOut(_:)), name: "LoginOutSuccessNotification", object: nil)
      
    }
    
    func doSome(notification:NSNotification){
        
        valideLoginState()
        self.noticeSuccess("登录成功", autoClear: true, autoClearTime:3)
    }
    
    
    func doLoginOut(notification:NSNotification){
        
        valideLoginState()
        self.noticeSuccess("退出成功", autoClear: true, autoClearTime:3)
    }
    
    
    func valideLoginState(){
        
        let userInfo=NSUserDefaults.standardUserDefaults()
        let token  =  userInfo.objectForKey("token")
        if token == nil{
            nickName.text = "您还没有登录哦"
            loginNow.hidden=false
            
        }else{
            nickName.text = userInfo.stringForKey("mobile")
            loginNow.hidden = true
  
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
