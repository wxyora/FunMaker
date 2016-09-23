//
//  MyViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import Alamofire

class MyViewController: BaseViewController {

    @IBOutlet weak var myTravelLb: UILabel!
    
    @IBOutlet weak var homeHouseLb: UILabel!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var loginNow: UIButton!
    
    var thumbQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(MyViewController.refreshTableView), for: UIControlEvents.valueChanged)
        self.refreshControl = rc
        valideLoginState()
        self.navigationController!.navigationBar.tintColor=UIColor.white;
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.white]


        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()
        
        
        let userInfo=UserDefaults.standard
        let token  =  userInfo.object(forKey: "token")
        if token != nil{
            initData()
        }
        
        
        //设置头像圆角
        headImage.layer.cornerRadius = headImage.frame.width/2
        //设置遮盖额外部分,下面两句的意义及实现是相同的
        //      headImage.clipsToBounds = true
        headImage.layer.masksToBounds = true
        
        headImage.layer.borderWidth=1
        headImage.layer.borderColor = UIColor.gray.cgColor
        
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // alert(String(indexPath.row))
          let token = getToken()
        if (indexPath as NSIndexPath).row == 0{
            if token.isEmpty{
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
                self.navigationController?.present(loginViewController, animated: true, completion: nil)
            }else{
                let myProfileViewController = storyBoard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                self.navigationController?.pushViewController(myProfileViewController, animated: true)
            }
        
        }else if (indexPath as NSIndexPath).row == 2{
            if token.isEmpty{
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
                self.navigationController?.present(loginViewController, animated: true, completion: nil)
            }else{
                let travelListViewController = storyBoard.instantiateViewController(withIdentifier: "TravelListViewController") as! TravelListViewController
                self.navigationController?.pushViewController(travelListViewController, animated: true)
            }
        }else if (indexPath as NSIndexPath).row==3{
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        
         //接收登录成功的通知
         //NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MyViewController.doSome(_:)), name: "LoginSuccessNotification", object: nil)
         //NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MyViewController.doLoginOut(_:)), name: "LoginOutSuccessNotification", object: nil)
        
        
        valideLoginState()
    }
    
    func doSome(_ notification:Notification){
        
        valideLoginState()
        //self.noticeSuccess("登录成功", autoClear: true, autoClearTime:3)
    }
    
    
    func doLoginOut(_ notification:Notification){
        
        valideLoginState()
        //self.noticeSuccess("退出成功", autoClear: true, autoClearTime:3)
    }
    
    
    func valideLoginState(){
        
        //let myProfile = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "myProfileId") as UITableViewCell
        
        
    
       
        let userInfo=UserDefaults.standard
        let token  =  userInfo.object(forKey: "token")
        let headObj = userInfo.object(forKey: "headImage")
        var headName = ""
        
        if token == nil{
            nickName.text = "您还没有登录哦"
            loginNow.isHidden=false
            myTravelLb.text? = "我的拼团游"
            homeHouseLb.text?="我的民宿"
            let head=UIImage(named: "skull")
            self.headImage.image=head
  
        }else{
            nickName.text = userInfo.string(forKey: "mobile")!+" 已登录"
            loginNow.isHidden = true
            getData()
            
            
            if headObj != nil{
               
                 headName  =  String(describing: headObj!)

                
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
        
        if(self.refreshControl?.isRefreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            
            valideLoginState()

            getData()

        }
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
                        let n :Int = data.count
                        let s = "(\(n))"
                        self?.myTravelLb.text?="我的拼团游\(s)"
                    }
                }
                }
                
                self.clearAllNotice()
        }

 
    }
    
    func getData(){
        
 
        
        Alamofire.request(Constant.host+Constant.getUnionByUser,method:.get, parameters: ["userId":getMobile()])
            .responseJSON { response in
                //print(Constant.host+Constant.getUnionByUser+"?userId=\(self.getMobile())")
                if let myJson = response.result.value {
                    //let data = myJson as! Dictionary<String,AnyObject>
                    if let data : NSArray = ((myJson as AnyObject).object(forKey: "data") as? NSArray){
                    DispatchQueue.main.async { [weak self] in
                        let n :Int = data.count
                        let s = "(\(n))"
                        self?.myTravelLb.text?="我的拼团游\(s)"
                    }
                    }
                }
                
               
                
        }
     
    }

    


    //登录成功后回调
    func loginSuccessCallBack(){
        
       //self.loginStatusInfo.text="成功登录"
       //self.loginNow.hidden=true
        
    }


}
