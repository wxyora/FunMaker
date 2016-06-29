//
//  ViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/25.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    var message:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(sender: AnyObject) {
        if userName.text?.isEmpty == true{
//            let alert = UIAlertView(title: "提示信息", message: "用户名不能为空", delegate: nil, cancelButtonTitle: "OK")
//            alert.show()

            message = "用户名不能为空"
            
            
        }else{
            if password.text?.isEmpty == true{
                //let alert = UIAlertView(title: "提示信息", message: "密码不能为空", delegate: nil, cancelButtonTitle: "OK")
                //alert.show()
                message = "密码不能为空"
                
            }else{
                //let alert = UIAlertView(title: "提示信息", message: "登录成功", delegate: nil, cancelButtonTitle: "OK")
                //alert.show()
                message = "登录成功"
            }
        
        }
        
        if !message.isEmpty{
            //            UIAlertController通过闭包来实现响应事件，UIAlertView是通过实现委托协议来实现的
            let alertController:UIAlertController = UIAlertController(title: "新的提示控件", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
                print("OK button was pressed")
                })
            //显示
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
      
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

