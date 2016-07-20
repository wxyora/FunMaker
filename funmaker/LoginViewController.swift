//
//  ViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/25.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

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
        let c = add(4)
        print(c)
        let str = {
            a,b in
            return a + b
            
        }("hello,","world")
        print(str)
    }
    
    func add(a:Int=3,b:Int = 2)->Int{
        return a+b
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("login page appear")
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
                //self.performSegueWithIdentifier("loginSuccessSegue", sender: nil)
            
                self.dismissViewControllerAnimated(true, completion: {
                    
                })
               
               
//                let sb = UIStoryboard(name: "Main", bundle: nil)
//                let vc = sb.instantiateViewControllerWithIdentifier("loginSuccessViewController")
//                self.presentViewController(vc, animated: true, completion: nil)
                
                
            }
        
        }
        
        if !message.isEmpty{
            //            UIAlertController通过闭包来实现响应事件，UIAlertView是通过实现委托协议来实现的
            let alertController:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in
                //print("OK button was pressed")
                })
            
//            alertController.addAction(UIAlertAction(title: "警告", style: UIAlertActionStyle.Destructive, handler: { (self) in
//                
//            }))
            
            //显示
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
      
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

