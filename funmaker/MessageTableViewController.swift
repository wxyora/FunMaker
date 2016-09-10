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
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        let userInfo = NSUserDefaults.standardUserDefaults()
        
        let headImageUrl = userInfo.stringForKey(userId)
        
      //  if headImageUrl == nil{
            Alamofire.request(.GET, Constant.host+Constant.findUserUrl, parameters: ["mobile": userId])
                .responseJSON { response in
                    
                    if let myJson = response.result.value {
                        //let result = String(myJson.valueForKey("result")!)
                        let userInfoTemp = myJson.objectForKey("userInfo")
                        let headImage = String(userInfoTemp!.valueForKey("headImage")!)
                        let headImageUrlNew = Constant.head_image_host+headImage+".png"
                        
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            userInfo.setValue(headImageUrlNew, forKey: userId)
                            userInfo.synchronize()
                            
                            //刷新主UI
                            let userInfo1 = RCUserInfo(userId: userId, name: userId, portrait:headImageUrlNew)
                            return completion(userInfo1)
                        })
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
        
         RCIM.sharedRCIM().userInfoDataSource = self
       
        
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue])
        //self.setConversationAvatarStyle(.USER_AVATAR_CYCLE)
        //设置需要将哪些类型的会话在会话列表中聚合显示
        //self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
           // RCConversationType.ConversationType_GROUP.rawValue])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
         self.tabBarController!.tabBar.hidden = false
        // 发送通知,通知控制器即将展开
        NSNotificationCenter.defaultCenter().postNotificationName(PopoverAnimatorWillShow, object: self)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
            }
    
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        //打开会话界面
        let chat = RCConversationViewController(conversationType: model.conversationType, targetId: model.targetId)
        chat.title = "与\(model.targetId)会话"
         //RCIM.sharedRCIM().globalMessageAvatarStyle = .USER_AVATAR_CYCLE
         RCIM.sharedRCIM().enableTypingStatus = true
       
        chat.displayUserNameInCell=true
        self.navigationController?.pushViewController(chat, animated: true)
        
        
        
        
        self.tabBarController!.tabBar.hidden = true
        // 发送通知,通知控制器即将展开
        NSNotificationCenter.defaultCenter().postNotificationName(PopoverAnimatorWillDismiss, object: self)
        
        
    }
}
