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
    
    @IBOutlet weak var registButton: UIButton!
    
    
    var message:String!
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true) {
            print("cancel button is pressed")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 3
        registButton.layer.cornerRadius = 3
    }
    

    override func viewWillAppear(animated: Bool) {
       
    }
    
    func alert(message:String){
        let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func login(sender: AnyObject) {
     
        if userName.text?.isEmpty == true{
            message = "用户名不能为空"
            alert(message)
        }else{
            if password.text?.isEmpty == true{
                message = "密码不能为空"
                alert(message)
            }else{
                do {
                    let opt = try HTTP.GET("http://192.168.0.20:8080/WaylonServer/loginValidate.action", parameters: ["mobile":userName.text, "password": password.text])
                    opt.progress = { progress in
                        print("progress: \(progress)") //this will be between 0 and 1.
                    }
                    opt.start { response in
                        if let err = response.error {
                            print("error: \(err.localizedDescription)")
                            return
                        }
                        //把NSData对象转换回JSON对象
                        let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                        let result : AnyObject = json.objectForKey("result")!
                        if String(result)=="用户不存在"{
                            self.message = "用户不存在,请注册。"
                        }else if String(result)=="用户名密码不匹配"{
                           self.message = "用户名密码不匹配"
                        }else if String(result)=="登录成功"{
                            self.message="登录成功"
                        }
                        //闭包中调用成员需要self指定
                        self.alert(self.message)

                    }
                } catch let error {
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
    @IBAction func acitonSheet(sender: AnyObject) {
        //UIAlertController默认不传参数就是actionSheet操作表控件
        let actionSheet = UIAlertController()
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAciton) -> Void in
            print("取消")
        })
        actionSheet.addAction(UIAlertAction(title: "腾讯QQ", style: UIAlertActionStyle.Destructive) { (alertAciton) -> Void in
            print("腾讯QQ")
        })
        actionSheet.addAction(UIAlertAction(title: "新浪微博", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
            print("新浪微博")
        })
        actionSheet.addAction(UIAlertAction(title: "微信", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
            print("微信")
        })
        
        actionSheet.addAction(UIAlertAction(title: "朋友圈", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
            print("朋友圈")
        })

            
        self.presentViewController(actionSheet, animated: true, completion: nil)

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
    
    


}

