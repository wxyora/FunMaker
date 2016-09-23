//
//  MessageTableViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//


import Foundation
import Alamofire

class MessageTableViewController: RCConversationListViewController,RCIMUserInfoDataSource{
    
    let PopoverAnimatorWillShow = "PopoverAnimatorWillShow"
    let PopoverAnimatorWillDismiss = "PopoverAnimatorWillDismiss"
    
    
    

    //聊天列表中新建的回话userid会传进来
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        let userInfo = UserDefaults.standard
        
      //  let headImageUrl = userInfo.string(forKey: userId)
        
      //  if headImageUrl == nil{
        //Alamofire.request(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
        Alamofire.request(Constant.host+Constant.findUserUrl,method:.get, parameters: ["mobile": userId])
                .responseJSON { response in
                    
                    if let myJson = response.result.value {
                    
             
                        let dict = myJson as! Dictionary<String,AnyObject>
                        let userInfo1 = dict["userInfo"]
                        
                        //let userInfoTemp = json.object(forKey: "userInfo") as AnyObject
                        let headImage = userInfo1?["headImage"] as! String
                        //let headImage = userInfoTemp.object(forKey: "headImage") as! String
                        //let nickName = userInfoTemp.object(forKey: "nickName") as! String
                        let headImageUrlNew = Constant.head_image_host+headImage+".png"

//                        
                        DispatchQueue.main.async { [weak self] in
                            let name = self?.nibName
                            print(name)
                            userInfo.setValue(headImageUrlNew, forKey: userId)
                            userInfo.synchronize()
                            var nickName = userId!
                            let subRange=(nickName.characters.index(nickName.startIndex, offsetBy: 3) ..< nickName.characters.index(nickName.startIndex, offsetBy: 7)) //Swift 2.0
                            nickName.replaceSubrange(subRange, with: "****")
                            //nickName?.replaceSubrange(3...4, with: "****")
//                            let subRange=Range(start: nickName?.startIndex.advancedBy(3), end: nickName?.startIndex.advancedBy(7)) //Swift 2.0
//                            nickName.replaceRange(subRange, with: "****")
                            //刷新主UI
                            let userInfo1 = RCUserInfo(userId: userId, name: nickName, portrait:headImageUrlNew)
                            return completion(userInfo1)
                        }
                    }
                
            }
            
            
        }
    
//    else{
//            let userInfo1 = RCUserInfo(userId: userId, name: userId, portrait:headImageUrl)
//            return completion(userInfo1)
//        }
//        
//  
//    }

    
    
    override func viewDidLoad() {
        //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
        super.viewDidLoad()
        
         RCIM.shared().userInfoDataSource = self
       
        
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue])
        //self.setConversationAvatarStyle(.USER_AVATAR_CYCLE)
        //设置需要将哪些类型的会话在会话列表中聚合显示
        //self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
           // RCConversationType.ConversationType_GROUP.rawValue])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.tabBarController!.tabBar.isHidden = false
        // 发送通知,通知控制器即将展开
        NotificationCenter.default.post(name: Notification.Name(rawValue: PopoverAnimatorWillShow), object: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            }
    
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        //打开会话界面
        let chat = RCConversationViewController(conversationType: model.conversationType, targetId: model.targetId)
        var nickName = model.targetId!
        let subRange=(nickName.characters.index(nickName.startIndex, offsetBy: 3) ..< nickName.characters.index(nickName.startIndex, offsetBy: 7)) //Swift 2.0
        nickName.replaceSubrange(subRange, with: "****")
//        let subRange=(nickName?.index((nickName?.startIndex)!, offsetBy: 3) ..< nickName?.index((nickName?.startIndex)!, offsetBy: 7)) //Swift 2.0
//        nickName.replaceSubrange(subRange, with: "****")
        chat?.title = "与\(nickName)会话"
         //RCIM.sharedRCIM().globalMessageAvatarStyle = .USER_AVATAR_CYCLE
         RCIM.shared().enableTypingStatus = true
       
        chat?.displayUserNameInCell=true
        self.navigationController?.pushViewController(chat!, animated: true)
        
        
        
        
        self.tabBarController!.tabBar.isHidden = true
        // 发送通知,通知控制器即将展开
        NotificationCenter.default.post(name: Notification.Name(rawValue: PopoverAnimatorWillDismiss), object: self)
        
        
    }
}
