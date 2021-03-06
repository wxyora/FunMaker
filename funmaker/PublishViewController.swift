//
//  PublishViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import Alamofire

class PublishViewController: BaseViewController ,UITextFieldDelegate,UITextViewDelegate{
    
    @IBOutlet weak var dateInfo: UITextField!
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var publish: UIButton!
    @IBOutlet weak var theme: UITextField!
    @IBOutlet weak var action: UITextField!
    @IBOutlet weak var contact: UITextField!
    
    var message:String=""
 
    @IBOutlet weak var cancel: UIButton!
    
    @IBAction func cancelClick(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if valideLoginState()==0 {
            return false
        }
        
        if textField.tag == 100 {
            theme.resignFirstResponder()
            setDate()
            return false
        }else if textField.tag == 2 {
            
            let actionSheet = UIAlertController()
            actionSheet.addAction(UIAlertAction(title: "飞机", style: UIAlertActionStyle.default) { (alertAciton) -> Void in
                self.action.text="飞机"
                })
            actionSheet.addAction(UIAlertAction(title: "高铁", style: UIAlertActionStyle.default) { (alertAciton) -> Void in
                 self.action.text="高铁"
                })
            actionSheet.addAction(UIAlertAction(title: "自驾游", style: UIAlertActionStyle.default) { (alertAciton) -> Void in
                 self.action.text="自驾游"
                })
            actionSheet.addAction(UIAlertAction(title: "摩托车", style: UIAlertActionStyle.default) { (alertAciton) -> Void in
                 self.action.text="摩托车"
                })
            actionSheet.addAction(UIAlertAction(title: "自行车", style: UIAlertActionStyle.default) { (alertAciton) -> Void in
                 self.action.text="自行车"
                })

            
            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (alertAciton) -> Void in})
            
            self.present(actionSheet, animated: true, completion: nil)
            
            return false
        }else{
            return true
        }
        
      
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        dateInfo.text=""
        content.text=""
        theme.text=""
        action.text=""
        contact.text=""
        
        
        
     
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            //print("收回键盘")
            dateInfo.resignFirstResponder()
            contact.resignFirstResponder()
            theme.resignFirstResponder()
            action.resignFirstResponder()
            content.resignFirstResponder()
            

        }
        sender.cancelsTouchesInView = false
    }

    
    
    @IBAction func publishUnion(_ sender: AnyObject) {
        
        
        
        if theme.text?.isEmpty == true{
            message = "主题不能为空"
            alert(message)
        }else{
            if dateInfo.text?.isEmpty == true{
                message = "请选择日期"
                alert(message)
            }else{
                if action.text?.isEmpty == true{
                    message = "请选择出行方式"
                    alert(message)
                }else{
                    if contact.text?.isEmpty==true{
                        message = "请选择联系方式"
                        alert(message)
                        
                    }else{
                        if content.text.isEmpty == true {
                            message = "请填写具体计划"
                            alert(message)
                        }else{
                            
                            
                            Alamofire.request(Constant.host+Constant.publishUrl,method:.get, parameters: ["userId":getMobile(), "unionTheme": theme.text!,"outTime": dateInfo.text!,"unionContent": content.text!,"contactWay":contact.text!,"reachWay":action.text!])
                                .responseJSON { response in
                                    
                                    if let myJson = response.result.value {
                                        
                                        let json = myJson as! Dictionary<String,AnyObject>
                                        let result = json["result"] as! String
                                            DispatchQueue.main.async { [weak self] in
                                               if result=="发布成功"{
                                                self?.clearAllNotice()
                                                self?.myAlert("发布成功，请到<我的>中查看。")
                                            }
                                        
                                    }
                                    
                                    self.clearAllNotice()
                            }
                            }
                         
                            self.pleaseWait()

                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
    }
    
    
    var datePicker:UIDatePicker = UIDatePicker()
    var alertview:UIView! = UIView()
    
    
    @IBAction func date(_ sender: AnyObject) {
        
        setDate()
    }
    
    func myAlert(_ message:String){
        let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel){ (alertAciton) -> Void in
             self.dismiss(animated: true, completion: nil)
            
            })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setDate() {
        
        
        
        let screen:UIScreen = UIScreen.main
        let devicebounds:CGRect = screen.bounds
        let deviceWidth:CGFloat = devicebounds.width
        let deviceHeight:CGFloat = devicebounds.height
        let viewColor:UIColor = UIColor(white:0, alpha: 0.6)
        
        //设置日期弹出窗口
        alertview = UIView(frame:devicebounds)
        alertview.backgroundColor = viewColor
        alertview.isUserInteractionEnabled = true
        
        //设置datepicker
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor.white
        datePicker.frame = CGRect(x:0,y:deviceHeight/3,width:deviceWidth,height:216)
        
        //设置 确定 和 取消 按钮
        //var li_common:Li_common = Li_common()
        let selectedButton:UIButton = Li_createButton("确定",x:0,y:deviceHeight/3,width:deviceWidth/2,height:45,target:self, action: #selector(PublishViewController.selectedAction))
        let cancelButton:UIButton = Li_createButton("取消",x:deviceWidth/2,y:deviceHeight/3,width:deviceWidth/2,height:45,target:self, action: #selector(PublishViewController.cancelAction))
        
        alertview.addSubview(datePicker)
        alertview.addSubview(selectedButton)
        alertview.addSubview(cancelButton)
        
        self.view.addSubview(alertview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        content.layer.cornerRadius = 4
        publish.layer.cornerRadius = 4
        content.delegate=self
        dateInfo.delegate=self
        contact.delegate=self
        theme.delegate=self
        action.delegate=self
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()
        
        
        //设置默认日期为今天
        //        var currentDate:String = dateString(NSDate())
        //        dateInfo.text=currentDate
        
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let animationDuration=0.90;
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect=CGRect(x: 0.0,y: -140,width: width,height: height);
        self.view.frame=rect;
        UIView.commitAnimations()
        return true
    }
    
    
    
    
   
    func textViewDidEndEditing(_ textView: UITextView) {
        let animationDuration=0.20;
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect=CGRect(x: 0.0,y: 0,width: width,height: height);
        self.view.frame=rect;
         UIView.commitAnimations()
    }
    
    
    //选择日期
    func selectedAction(){
        let dateString:String = self.dateString(datePicker.date)
        dateInfo.text=dateString
        removeAlertview()
        
    }
    
    func cancelAction(){
        removeAlertview()
    }
    
    func removeAlertview(){
        alertview.removeFromSuperview()
    }
    
    //返回2014-06-19格式的日期
    func dateString(_ date:Date) ->String{
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString:String = dateFormatter.string(from: date)
        return dateString
    }
    
    
    //日期选择器响应方法
    func dateChanged(_ datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print(formatter.string(from: datePicker.date))
    }
    
 
    
    func valideLoginState()->Int{
        
        let userInfo=UserDefaults.standard
        let token  =  userInfo.object(forKey: "token")
        if token == nil{
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
            self.present(loginViewController, animated: true, completion: nil)
            return 0
        }else{
            return 1
            //alert("您已经登录")
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dateInfo.resignFirstResponder()
        contact.resignFirstResponder()
        theme.resignFirstResponder()
        action.resignFirstResponder()
        content.resignFirstResponder()
        
        return true
    }
    
    
    //关闭textview的键盘
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.contains("\n") {
            
            self.view.endEditing(true)
            
            return false
            
        }
        
        return true
        
    }
    
    /*
     快速创建一种常用的button，state：normal，  backgroundcolor：white，  type：system    ControlEvents:TouchUpInside
     */
    func Li_createButton(_ title:String!,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,target: AnyObject!, action: Selector) ->UIButton{
        let buttonRect:CGRect = CGRect(x:x, y:y, width:width, height:height)
        let button:UIButton = UIButton(type: UIButtonType.system)
        button.setTitle(title, for: UIControlState())
        button.frame = buttonRect
        button.backgroundColor = UIColor.white
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        return button
    }
    
    
}
