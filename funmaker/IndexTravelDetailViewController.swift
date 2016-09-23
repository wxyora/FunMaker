//
//  IndexTravelDetailViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/7.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import Alamofire

class IndexTravelDetailViewController: BaseViewController {
    

    
    
    @IBOutlet weak var unionTheme: UILabel!
    @IBOutlet weak var contactWay: UILabel!
    @IBOutlet weak var outTime: UILabel!
    @IBOutlet weak var reachWay: UILabel!
    @IBOutlet weak var unionContent: UITextView!
    var mobile:String = ""
    
    @IBAction func talkWithHer(_ sender: UIButton) {
        
        let userInfo:UserDefaults=UserDefaults.standard
        let token = userInfo.value(forKey: "token")
       

        if(token != nil){
            //新建一个聊天会话View Controller对象
            let chat = RCConversationViewController()
            chat.displayUserNameInCell=true
            //[RCIM sharedRCIM]的globalMessageAvatarStyle属性
            
            //RCIM.sharedRCIM().globalMessageAvatarStyle = .USER_AVATAR_CYCLE
            RCIM.shared().enableTypingStatus = true
            //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
            chat.conversationType = RCConversationType.ConversationType_PRIVATE
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
            
            chat.targetId = mobile
            
            
            var nickName = mobile
            let subRange=(nickName.characters.index(nickName.startIndex, offsetBy: 3) ..< nickName.characters.index(nickName.startIndex, offsetBy: 7)) //Swift 2.0
            nickName.replaceSubrange(subRange, with: "****")
            chat.title = "与\(nickName)会话"
            //设置聊天会话界面要显示的标题
            //chat.title = mobile
            if mobile == self.getMobile(){
                self.noticeInfo("勿自言自语", autoClear: true, autoClearTime: 1)
            }else{
                //显示聊天会话界面
                self.navigationController?.pushViewController(chat, animated: true)
            }
           
        }else{
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
            self.present(loginViewController, animated: true, completion: nil)

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
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.pleaseWait()
        
        
        let unionId = userInfo.string(forKey: "unionId")
        Alamofire.request(Constant.host+Constant.getUnionByUnionId,method:.get, parameters: ["unionId":unionId!])
            .responseJSON { response in
                
                if let myJson = response.result.value {
                
                    let dict = myJson as! Dictionary<String,AnyObject>
                    print(dict)
                    let data = dict["data"]
                    let status = dict["status"] as! String
                 
                        DispatchQueue.main.async { [weak self] in
                         
                            self?.clearAllNotice()
                            if(status=="1"){
                                let unionTheme = data?["unionTheme"]
                                self?.unionTheme.text = unionTheme as! String?
                                if self?.userInfo.string(forKey: "token") != nil{
                                    self?.contactWay.text =  data?["contactWay"] as? String
                                }else{
                                    self?.contactWay.text = "登陆后可见"
                                    self?.contactWay.textColor = UIColor.red
                                    
                                }
                                self?.outTime.text =  data?["outTime"] as? String
                                self?.unionContent.text =  data?["unionContent"] as? String
                                self?.reachWay.text = data?["reachWay"] as? String
                                self?.mobile = (data?["userId"] as? String)!
                                
                            }else{
                               
                                    //self.noticeInfo("数据被删除", autoClear: true, autoClearTime: 1)
                                    self?.alert("数据被主人删除了，请返回刷新数据。")
                                
                            }
                        }
                    
                }
                
        }

    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
