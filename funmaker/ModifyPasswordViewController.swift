//
//  RegistViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/27.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP

class ModifyPasswordViewController: UITableViewController ,UITextFieldDelegate{
    
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var getPhoneCode: UIButton!
    @IBOutlet weak var commitUserInfo: UIButton!
    
    var buttonColor:UIColor?
    
    var countdownTimer: NSTimer?
    
    
    func updateTime(timer: NSTimer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    
    var isCounting = false {
        willSet {
            if newValue {
                buttonColor = self.getPhoneCode.backgroundColor
                let selector = #selector(updateTime(_:))
                countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:selector, userInfo: nil, repeats: true)
                
                //NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:(Selector("updateTime")), userInfo: nil, repeats: true)
                
                remainingSeconds = 120
                getPhoneCode.backgroundColor = UIColor.grayColor()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                getPhoneCode.backgroundColor = buttonColor
            }
            
            getPhoneCode.enabled = !newValue
        }
    }
    
    var remainingSeconds: Int = 0 {
        willSet {
            getPhoneCode.setTitle("\(newValue)秒后重新获取", forState: .Normal)
            
            
            if newValue <= 0 {
                getPhoneCode.setTitle("重新获取验证码", forState: .Normal)
                isCounting = false
            }
        }
    }
    
    
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
                        let message="用户不存在，请注册。"
                        let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
                            
                            })
                        self.presentViewController(alertController, animated: true, completion: nil)
                        self.clearAllNotice()
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                        
                    }else if String(result)=="用户存在"{
                        //发送手机验证码
                        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber:self.phone.text, zone: "86", customIdentifier: nil) { (error) in
                            var message:String
                            if((error == nil)){
                                message="验证码已经发送"
                                dispatch_async(dispatch_get_main_queue()) {
                                    // 启动倒计时
                                    self.isCounting = true
                                }
                                
                            }else{
                                message="获取验证码失败"
                            }
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            
                            self.alert(message)
                            self.clearAllNotice()
                            
                            
                        }
                        
                        
//                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                        
//                        //闭包中调用成员需要self指定
//                        let message="用户已经存在，请直接登录"
//                        let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
//                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
//                            //点击ok返回登录界面
//                            self.navigationController?.popViewControllerAnimated(true)
//                            })
//                        self.presentViewController(alertController, animated: true, completion: {
//                            
//                        })
//                        self.clearAllNotice()
                        
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
    
    
    
    
    //    //验证码倒计时
    //    func countDown(timeOut:Int){
    //        //倒计时时间
    //        var timeout = timeOut
    //        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //        let _timer:dispatch_source_t  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue)
    //        dispatch_source_set_timer(_timer, dispatch_walltime(nil, 0), 1*NSEC_PER_SEC, 0)
    //        //每秒执行
    //        dispatch_source_set_event_handler(_timer, { () -> Void in
    //            if(timeout<=0){ //倒计时结束，关闭
    //                dispatch_source_cancel(_timer);
    //                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
    //                    //设置界面的按钮显示 根据自己需求设置
    //                    self.getPhoneCode.setTitle("再次获取", forState: UIControlState.Normal)
    //                    self.getPhoneCode.userInteractionEnabled = true
    //                    self.getPhoneCode.backgroundColor = UIColor.blueColor()
    //                })
    //            }else{//正在倒计时
    //                let seconds = timeout % 60
    //                let strTime = NSString.localizedStringWithFormat("%.2d", seconds)
    //
    //                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
    //                    //                    NSLog("----%@", NSString.localizedStringWithFormat("%@S", strTime) as String)
    //
    //                    UIView.beginAnimations(nil, context: nil)
    //                    UIView.setAnimationDuration(1)
    //                    //设置界面的按钮显示 根据自己需求设置
    //                    self.getPhoneCode.setTitle(NSString.localizedStringWithFormat("%@S", strTime) as String, forState: UIControlState.Normal)
    //                    self.getPhoneCode.backgroundColor = UIColor.grayColor()
    //                    UIView.commitAnimations()
    //                    self.getPhoneCode.userInteractionEnabled = false
    //                })
    //                timeout--;
    //            }
    //
    //        })
    //        dispatch_resume(_timer)
    //    }
    
    
    
    @IBAction func submitUserInfo(sender: AnyObject) {
        
        if !(phone.text?.isEmpty)! && !(password.text?.isEmpty)! && !(verifyCode.text?.isEmpty)!{
            //开启网络请求hud
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.pleaseWait()
            //验证手机验证码
            SMSSDK.commitVerificationCode(verifyCode.text, phoneNumber:phone.text, zone: "86") { (error) in
                var message:String
                if((error == nil)){
                    self.updateUser()
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
    
    func updateUser(){
        do {
            let opt = try HTTP.GET(Constant.host + Constant.updateUserUrl, parameters: ["mobile":phone.text,"password":password.text])
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
                if String(result)=="修改成功"{
                    let message="密码修改成功，请登录。"
                    let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
                        //点击OK返回登录界面
                        self.navigationController?.popViewControllerAnimated(true)
                        })
                    self.presentViewController(alertController, animated: true, completion: nil)
//                    self.clearAllNotice()
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }else if(String(result)=="用户不存在"){
                    let message="用户不存在，请注册。"
                    let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
                        
                        })
                    self.presentViewController(alertController, animated: true, completion: nil)
//                    self.clearAllNotice()
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }else {
                    let message="密码修改失败，请重试。"
                    let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
                        
                        })
                    self.presentViewController(alertController, animated: true, completion: nil)
                   
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.clearAllNotice()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                }
            }
        } catch let error {
            print("loginValidate interface got an error creating the request: \(error)")
        }
    }
    
//    @IBAction func cancel(sender: AnyObject) {
//        
//        self.dismissViewControllerAnimated(true) {
//            print("cancel button is pressed")
//        }
//    }
//    @IBAction func save(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true) {
//            print("cave button is pressed")
//        }
//        
//        NSNotificationCenter.defaultCenter().postNotificationName("registerName",object: "")
//        
//    }
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
