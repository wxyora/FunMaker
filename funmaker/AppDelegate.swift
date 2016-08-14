//
//  AppDelegate.swift
//  funmaker
//
//  Created by Waylon on 16/6/25.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
       // SMSSDK registerApp:appKey withSecret:appSecret
        //注册发短信sdk
        SMSSDK.registerApp("152586542fe1a", withSecret:"e5cef2c86a470a123672b7cbaf12ec0e")
        
        
        
        
//        //QQ空间
//        ShareSDK.connectQZoneWithAppKey("1103527931", appSecret:"WEKkOPW0NJkc1cwS", qqApiInterfaceCls: QQApiInterface.classForCoder(), tencentOAuthCls: TencentOAuth.classForCoder())
//        //QQ
//        ShareSDK.connectQQWithAppId("1103527931", qqApiCls:QQApiInterface.classForCoder())
//        //链接微信
//        ShareSDK.connectWeChatWithAppId("wx5f09f3b56fd1faf7", wechatCls: WXApi.classForCoder())
//        //微信好友
//        ShareSDK.connectWeChatSessionWithAppId("wx5f09f3b56fd1faf7", wechatCls:WXApi.classForCoder())
//        //微信朋友圈
//        ShareSDK.connectWeChatTimelineWithAppId("wx5f09f3b56fd1faf7", wechatCls: WXApi.classForCoder())
//        
        
        
        
        // 得到当前应用的版本号
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 取出之前保存的版本号
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let appVersion = userDefaults.stringForKey("appVersion")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
        if appVersion == nil || appVersion != currentAppVersion {
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            
            let guideViewController = storyboard.instantiateViewControllerWithIdentifier("GuideViewController") as! GuideViewController
            self.window?.rootViewController = guideViewController
        }
        
        
        
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

