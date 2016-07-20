//
//  RegistViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/27.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class RegistViewController: BaseViewController ,UITextFieldDelegate{

    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var getPhoneCode: UIButton!
    
    @IBOutlet weak var commitUserInfo: UIButton!
    
    @IBAction func getMobileCode(sender: AnyObject) {
        
    //发送手机验证码
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber:phone.text, zone: "86", customIdentifier: nil) { (error) in
            var message,title:String
            if((error == nil)){
                message="获取验证码成功"
                title="Nice"
                
            }else{
                message="获取验证码失败"
                title="Shit"
            }
            let alertController:UIAlertController = UIAlertController(title: "", message:message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    

    
    @IBAction func submitUserInfo(sender: AnyObject) {
        
        //验证手机验证码
        SMSSDK.commitVerificationCode(verifyCode.text, phoneNumber:phone.text, zone: "86") { (error) in
            var message,title:String
            if((error == nil)){
                message="手机验证成功"
                title="Nice"
            }else{
                message="手机验证失败"
                title="Shit"
            }
            let alertController:UIAlertController = UIAlertController(title: "", message:message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title:title, style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
            self.presentViewController(alertController, animated: true, completion: nil)
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
