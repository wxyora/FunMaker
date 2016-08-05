//
//  RegistViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/27.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP

class RegistViewController: UITableViewController ,UITextFieldDelegate{

    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var getPhoneCode: UIButton!
    @IBOutlet weak var commitUserInfo: UIButton!
    
    @IBAction func getMobileCode(sender: AnyObject) {
        phone.resignFirstResponder()
        password.resignFirstResponder()
        verifyCode.resignFirstResponder()
        if !(phone.text?.isEmpty)!{
            //开启网络请求hud
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.pleaseWait()

            do {
                let opt = try HTTP.GET(Constant.host + Constant.findUserUrl, parameters: ["mobile":phone.text])
                opt.progress = { progress in
                    print("progress: \(progress)") //this will be between 0 and 1.
                }
                opt.start { response in
                    if let err = response.error {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                       
                        self.alert(err.localizedDescription)
                         self.clearAllNotice()
                        return
                    }
                    //把NSData对象转换回JSON对象
                    let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                    let result : AnyObject = json.objectForKey("result")!
                    if String(result)=="用户不存在"{
                        //发送手机验证码
                        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber:self.phone.text, zone: "86", customIdentifier: nil) { (error) in
                            var message:String
                            if((error == nil)){
                                message="验证码已经发送"
                            }else{
                                message="获取验证码失败"
                            }
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            
                            self.alert(message)
                            self.clearAllNotice()
                        }
                    }else if String(result)=="用户存在"{
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        
                        //闭包中调用成员需要self指定
                        let message="用户已经存在，请直接登录"
                        let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
                             //点击ok返回登录界面
                              self.navigationController?.popViewControllerAnimated(true)
                            })
                        self.presentViewController(alertController, animated: true, completion: {
                          
                        })
                        self.clearAllNotice()
                       
                    }
                    
                    //关闭网络hud
                    //self.clearAllNotice()
//                    ／UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                }
            } catch let error {
                print("loginValidate interface got an error creating the request: \(error)")
            }
        }else{
            alert("请填写正确手机号")
        }
    
        

    }
    

    
    @IBAction func submitUserInfo(sender: AnyObject) {
        
        if !(phone.text?.isEmpty)! && !(password.text?.isEmpty)! && !(verifyCode.text?.isEmpty)!{
            //开启网络请求hud
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.pleaseWait()
            //验证手机验证码
            SMSSDK.commitVerificationCode(verifyCode.text, phoneNumber:phone.text, zone: "86") { (error) in
                var message:String
                if((error == nil)){
                    //手机验证通过，开始注册到服务器
                    self.registUser()
                }else{
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    message="已经注册或者注册异常"
                    self.alert(message)
                    self.clearAllNotice()
                    
                }
            }
        }else{
            alert("请填写完整信息再提交")
        }
        
    }
    
    func alert(message:String){
        let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func registUser(){
        do {
            let opt = try HTTP.GET(Constant.host + Constant.registUrl, parameters: ["mobile":phone.text,"password":password.text])
            opt.progress = { progress in
                print("progress: \(progress)") //this will be between 0 and 1.
            }
            opt.start { response in
                if let err = response.error {
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.alert(err.localizedDescription)
                    self.clearAllNotice()
                    return
                }
                //把NSData对象转换回JSON对象
                let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                let result : AnyObject = json.objectForKey("result")!
                if String(result)=="注册成功"{
                    let message="注册成功，请登录。"
                    let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
                        //点击OK返回登录界面
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.clearAllNotice()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            }
        } catch let error {
            print("loginValidate interface got an error creating the request: \(error)")
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
            print("cancel button is pressed")
        }
    }
    @IBAction func save(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            print("cave button is pressed")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("registerName",object: "")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhoneCode.layer.cornerRadius = 3
        commitUserInfo.layer.cornerRadius = 3
        
        phone.delegate = self
        password.delegate=self
        verifyCode.delegate=self
    
        //self.navigationController!.navigationBar.tintColor=UIColor.whiteColor();

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        phone.resignFirstResponder()
        password.resignFirstResponder()
        verifyCode.resignFirstResponder()
        return true
    }

    
    override func viewWillDisappear(animated: Bool) {
        //关闭网络hud
        clearAllNotice()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        phone.resignFirstResponder()
        password.resignFirstResponder()
        verifyCode.resignFirstResponder()
    }
   

}
