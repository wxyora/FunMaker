//
//  ViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/25.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP

class LoginViewController: BaseViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var message:String!
    
    @IBAction func goDown(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       

        userName.delegate=self
        password.delegate=self
        loginButton.layer.cornerRadius = 3
        self.navigationController!.navigationBar.tintColor=UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    

    
    
    @IBAction func login(sender: AnyObject) {
     
        userName.resignFirstResponder()
        password.resignFirstResponder()
        
        if userName.text?.isEmpty == true{
            message = "用户名不能为空"
            alert(message)
        }else{
            if password.text?.isEmpty == true{
                message = "密码不能为空"
                alert(message)
            }else{
                //开启网络请求hud
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                self.pleaseWait()
                do {
                    let opt = try HTTP.GET(Constant.host+Constant.loginUrl, parameters: ["mobile":userName.text, "password": password.text])
//                    opt.progress = { progress in
//                        print("progress: \(progress)") //this will be between 0 and 1.
//                    }
                    opt.start { response in
                       
                        if let err = response.error {
                            //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                            dispatch_async(dispatch_get_main_queue()) {
                                self.clearAllNotice()
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 2)
                            }
                        }else{
                            
                            //关闭网络请求hud
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                            //self.clearAllNotice()
                            //把NSData对象转换回JSON对象
                            let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                            if json == nil {
                                self.alert("网络异常，请重试")
                                  self.clearAllNotice()
                            }else{
            
                                let json = JSON(json)
                                
     
                                    let result = json["result"].string
                                    let headImage = json["headImage"].string
                                    let token = json["token"].string
                                    let socketToken = json["socketToken"].string
                                    if result=="用户不存在"{
                                        self.alert("用户不存在")
                                        self.clearAllNotice()
                                    }else if result=="用户名密码不匹配"{
                                        self.alert("用户名密码不匹配")
                                        self.clearAllNotice()
                                    }else if result=="登录成功"{
                                       
                                        //登录成功后链接融云
                                        RCIM.sharedRCIM().initWithAppKey(Constant.rongyun_key)
                                        RCIM.sharedRCIM().connectWithToken(socketToken,
                                            success: { (userId) -> Void in
                                                print("融云登陆成功。当前登录的用户ID：\(userId)")
                                                
                                            }, error: { (status) -> Void in
                                                print("登融云陆的错误码为:\(status.rawValue)")
                                            }, tokenIncorrect: {
                                                //token过期或者不正确。
                                                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                                print("token错误")
                                        })

                                        self.clearAllNotice()
                                        let userInfo:NSUserDefaults=NSUserDefaults.standardUserDefaults()
                                        userInfo.setObject(token, forKey: "token")
                                        userInfo.setObject(self.userName.text, forKey: "mobile")
                                        userInfo.setObject(headImage, forKey: "headImage")
                                        userInfo.setObject(Constant.head_image_host+headImage!+".png", forKey: "headImageUrl")
                                        userInfo.setObject(socketToken, forKey: "socketToken")
                                        userInfo.synchronize();
                                        
                                        //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                                        dispatch_async(dispatch_get_main_queue()) {
                                           
                                            
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                        }
                                        //设置当前用户信息
                                         RCIM.sharedRCIM().currentUserInfo=RCUserInfo(userId: self.getMobile(), name: self.getMobile(), portrait: Constant.head_image_host+headImage!+".png")
                                       
                                    }
                                    
                             

                            }
                
                        }

                    }
                    
                } catch {
                    print("loginValidate interface got an error creating the request: \(error)")
                }
                
            }
        
        }

    }
    


    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}

