//
//  RegistViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/27.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP

class RegistViewController: BaseViewController ,UITextFieldDelegate{

    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var getPhoneCode: UIButton!
    @IBOutlet weak var commitUserInfo: UIButton!
    
    @IBAction func getMobileCode(sender: AnyObject) {
        if !(phone.text?.isEmpty)!{
            do {
                let opt = try HTTP.GET(Constant.host + Constant.findUserUrl, parameters: ["mobile":phone.text])
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
                        //发送手机验证码
                        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber:self.phone.text, zone: "86", customIdentifier: nil) { (error) in
                            var message:String
                            if((error == nil)){
                                message="验证码已经发送"
                            }else{
                                message="获取验证码失败"
                            }
                            self.alert(message)
                        }
                    }else if String(result)=="用户存在"{
                        //闭包中调用成员需要self指定
                        let message="用户已经存在，请直接登录"
                        let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
                        self.presentViewController(alertController, animated: true, completion: {
                            //self.dismissViewControllerAnimated(true, completion: nil)
                        })
                       // self.alert(message)
                    }
                    
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
            //验证手机验证码
            SMSSDK.commitVerificationCode(verifyCode.text, phoneNumber:phone.text, zone: "86") { (error) in
                var message:String
                if((error == nil)){
                    //手机验证通过，开始注册到服务器
                    self.registUser()
                }else{
                    message="已经注册或者注册异常"
                    self.alert(message)
                }
            }
        }else{
            alert("所有参数必填")
        }
        
    }
    
    func registUser(){
        do {
            let opt = try HTTP.GET(Constant.host + Constant.registUrl, parameters: ["mobile":phone.text,"password":password.text])
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
                if String(result)=="注册成功"{
                    let message="注册成功，请登录。"
                    let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
                    self.presentViewController(alertController, animated: true, completion: {
                        //self.dismissViewControllerAnimated(true, completion: nil)
                    })
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

   

}
