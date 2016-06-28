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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(sender: AnyObject) {
        if userName.text?.isEmpty == true{
            let alert = UIAlertView(title: "提示信息", message: "用户名不能为空", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }else{
            if password.text?.isEmpty == true{
                let alert = UIAlertView(title: "提示信息", message: "密码不能为空", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
            }else{
                let alert = UIAlertView(title: "提示信息", message: "登录成功", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        
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

