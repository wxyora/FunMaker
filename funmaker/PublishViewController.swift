//
//  PublishViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class PublishViewController: BaseViewController ,UITextFieldDelegate,UITextViewDelegate{

    @IBOutlet weak var publish: UIButton!
    @IBOutlet weak var senery: UITextField!
    @IBOutlet weak var action: UITextField!
    @IBOutlet weak var contact: UITextField!
    @IBOutlet weak var dateInfo: UITextField!
    @IBOutlet weak var detailInfo: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        detailInfo.layer.cornerRadius = 4
        publish.layer.cornerRadius = 4
        detailInfo.delegate=self
        dateInfo.delegate=self
        contact.delegate=self
        senery.delegate=self
        action.delegate=self
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()

    }

    override func viewWillAppear(animated: Bool) {
        valideLoginState()
    }

    
    func valideLoginState(){
        
        let userInfo=NSUserDefaults.standardUserDefaults()
        let token  =  userInfo.objectForKey("token")
        if token == nil{
//            let login = LoginViewController()
//            let alertController:UIAlertController!=UIAlertController(title: "", message: "请登录", preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in self.presentViewController(login, animated: true, completion: nil) })
//            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            
             //alert("您已经登录")
        }
       
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        dateInfo.resignFirstResponder()
        contact.resignFirstResponder()
        senery.resignFirstResponder()
        action.resignFirstResponder()
        
        
        return true
    }
    

    //关闭textview的键盘
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text.containsString("\n") {
            
            self.view.endEditing(true)
            
            return false
            
        }
        
        return true
        
    }
    

}
