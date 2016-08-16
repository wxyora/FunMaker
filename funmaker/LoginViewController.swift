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
                                self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 5)
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
                                let result : AnyObject = json.objectForKey("result")!
                                
                                //let mobile : AnyObject = json.objectForKey("mobile")!
                                if String(result)=="用户不存在"{
                                    self.alert("用户不存在")
                                    self.clearAllNotice()
                                }else if String(result)=="用户名密码不匹配"{
                                    self.alert("用户名密码不匹配")
                                    self.clearAllNotice()
                                }else if String(result)=="登录成功"{
                                    //存储用户token，mobile
                                    self.clearAllNotice()
                                    let token : AnyObject = json.objectForKey("token")!
                                    let userInfo:NSUserDefaults=NSUserDefaults.standardUserDefaults()
                                    userInfo.setObject(token, forKey: "token")
                                    userInfo.setObject(self.userName.text, forKey: "mobile")
                                    userInfo.synchronize();
                                    
                                    
                                    //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                                    dispatch_async(dispatch_get_main_queue()) {
                                       //self.navigationController?.popViewControllerAnimated(true)
                                       self.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                   
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

