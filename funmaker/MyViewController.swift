//
//  MyViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController {

    
    private var nickName:String?
    private var showLoginButton:Bool?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(PublishViewController.refreshTableView), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        valideLoginState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
         //接收登录成功的通知
         NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MyViewController.doSome(_:)), name: "LoginSuccessNotification", object: nil)
      
    }
    
    
    func valideLoginState(){
        
        let userInfo=NSUserDefaults.standardUserDefaults()
        let token  =  userInfo.objectForKey("token")
        if token == nil{
            nickName = "您还没有登录哦"
            showLoginButton = false
            
        }else{
            nickName = userInfo.stringForKey("mobile")
            showLoginButton = true
  
        }
        self.refreshControl?.endRefreshing()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.tableView.reloadData()
    }

    
    
    func refreshTableView(){
        
        if(self.refreshControl?.refreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            
            valideLoginState()
            //add data
//            let time:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_MSEC * 1000))
//            //延迟
//            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
//                //self.myLabel.text = "请点击调用按钮"
//                
//            }

        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        //不能对为空的optional进行解包,否则会报运行时错误.所以在对optional进行解包之前进行判断是否为空.
        // var cell:CustomCell! = tableView.dequeueReusableCellWithIdentifier("RentInfoCell", forIndexPath: indexPath) as? CustomCell
        var cell:MyCustomCell! = tableView.dequeueReusableCellWithIdentifier("MyInfoCell", forIndexPath: indexPath) as? MyCustomCell
        if(cell == nil){
            cell = MyCustomCell(style: UITableViewCellStyle.Default, reuseIdentifier:"MyInfoCell")
        }else{
            cell.nickName.text = self.nickName!
            cell.loginButton.hidden=showLoginButton!
            cell.logoutButton.addTarget(MyViewController.self, action: #selector(buttonClick), forControlEvents: UIControlEvents.TouchUpInside)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
    
    
    func buttonClick(){
         let userInfo=NSUserDefaults.standardUserDefaults()
         userInfo.removeObjectForKey("token")
         valideLoginState()
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func doSome(notification:NSNotification){

        valideLoginState()
        self.noticeSuccess("登录成功", autoClear: true, autoClearTime:3)
    }
    

    //登录成功后回调
    func loginSuccessCallBack(){
        
       //self.loginStatusInfo.text="成功登录"
       //self.loginNow.hidden=true
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
