//
//  MessageTableViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//


import Foundation

class MessageTableViewController: RCConversationListViewController {
    
    let PopoverAnimatorWillShow = "PopoverAnimatorWillShow"
    let PopoverAnimatorWillDismiss = "PopoverAnimatorWillDismiss"

    
    
    
    override func viewDidLoad() {
        //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
        super.viewDidLoad()
        
        
       
        
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue])
        self.setConversationAvatarStyle(.USER_AVATAR_CYCLE)
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
         RCIM.sharedRCIM().globalMessageAvatarStyle = .USER_AVATAR_CYCLE
       
        chat.displayUserNameInCell=true
        self.navigationController?.pushViewController(chat, animated: true)
        
        
        
        
        self.tabBarController!.tabBar.hidden = true
        // 发送通知,通知控制器即将展开
        NSNotificationCenter.defaultCenter().postNotificationName(PopoverAnimatorWillDismiss, object: self)
        
        
    }
}
