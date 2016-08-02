//
//  ViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/25.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP

class LoginViewController: UITableViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
       
    
    var message:String!
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true) {
           // print("cancel button is pressed")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate=self
        password.delegate=self
        loginButton.layer.cornerRadius = 3
        //registButton.layer.cornerRadius = 3
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func alert(message:String){
        let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    override func viewWillAppear(animated: Bool) {
       
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
                            
                           
                            self.alert("error: \(err.localizedDescription)")
                             self.clearAllNotice()
                            //关闭网络请求hud
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            //self.notice(err.localizedDescription, type: NoticeType.info, autoClear: true)
                            //return
                        }else{
                            //self.clearAllNotice()
                            //把NSData对象转换回JSON对象
                            let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                            let result : AnyObject = json.objectForKey("result")!
                            
                            //let mobile : AnyObject = json.objectForKey("mobile")!
                            if String(result)=="用户不存在"{
                                self.alert("用户不存在")
                            }else if String(result)=="用户名密码不匹配"{
                                self.alert("用户名密码不匹配")
                            }else if String(result)=="登录成功"{
                                
                                self.dismissViewControllerAnimated(true, completion:{
//                                    let mvc = MyViewController()
//                                    mvc.loginSuccessCallBack()
                                    //存储用户token，mobile
                                    let token : AnyObject = json.objectForKey("token")!
                                    let userInfo:NSUserDefaults=NSUserDefaults.standardUserDefaults()
                                    userInfo.setObject(token, forKey: "token")
                                    userInfo.setObject(self.userName.text, forKey: "mobile")
                                    userInfo.synchronize();
                                    //发布一条通知
                                    NSNotificationCenter.defaultCenter().postNotificationName("LoginSuccessNotification", object:String(result))
                                })
                            }
                            self.clearAllNotice()
                            //关闭网络请求hud
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        }

                    }
                    
                } catch {
                    print("loginValidate interface got an error creating the request: \(error)")
                }
             
                //self.performSegueWithIdentifier("loginSuccessSegue", sender: nil)
            
//                self.dismissViewControllerAnimated(true, completion: {
//                    
//                })
               
               
//                let sb = UIStoryboard(name: "Main", bundle: nil)
//                let vc = sb.instantiateViewControllerWithIdentifier("loginSuccessViewController")
//                self.presentViewController(vc, animated: true, completion: nil)
                
                
            }
        
        }
        
        
        
        
     
        
        
        
        
//        if !message!.isEmpty{
//            //            UIAlertController通过闭包来实现响应事件，UIAlertView是通过实现委托协议来实现的
//            let alertController:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
//                //print("OK button was pressed")
//                })
//            
//
//            
//            //显示
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }


        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        //关闭网络hud
        clearAllNotice()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }


}

