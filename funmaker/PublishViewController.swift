//
//  PublishViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import SwiftHTTP

class PublishViewController: BaseViewController ,UITextFieldDelegate,UITextViewDelegate{
    
    @IBOutlet weak var dateInfo: UITextField!
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var publish: UIButton!
    @IBOutlet weak var theme: UITextField!
    @IBOutlet weak var action: UITextField!
    @IBOutlet weak var contact: UITextField!
    
    var message:String=""
 
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if valideLoginState()==0 {
            return false
        }
        
        if textField.tag == 100 {
            theme.resignFirstResponder()
            setDate()
            return false
        }else if textField.tag == 2 {
            
            let actionSheet = UIAlertController()
            actionSheet.addAction(UIAlertAction(title: "飞机", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
                self.action.text="飞机"
                })
            actionSheet.addAction(UIAlertAction(title: "高铁", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
                 self.action.text="高铁"
                })
            actionSheet.addAction(UIAlertAction(title: "自驾游", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
                 self.action.text="自驾游"
                })
            actionSheet.addAction(UIAlertAction(title: "摩托车", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
                 self.action.text="摩托车"
                })
            actionSheet.addAction(UIAlertAction(title: "自行车", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
                 self.action.text="自行车"
                })

            
            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAciton) -> Void in})
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
            
            return false
        }else{
            return true
        }
        
      
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        dateInfo.text=""
        content.text=""
        theme.text=""
        action.text=""
        contact.text=""
        
        
        
     
    }

    
    
    @IBAction func publishUnion(sender: AnyObject) {
        
        
        
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
                            //开启网络请求hud
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                            self.pleaseWait()
                            do {
                                let opt = try HTTP.GET(Constant.host+Constant.publishUrl, parameters: ["userId":getMobile(), "unionTheme": theme.text,"outTime": dateInfo.text,"unionContent": content.text,"contactWay":contact.text,"reachWay":action.text])
                                //                    opt.progress = { progress in
                                //                        print("progress: \(progress)") //this will be between 0 and 1.
                                //                    }
                                opt.start { response in
                                    
                                    if let err = response.error {
                                        //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                                        dispatch_async(dispatch_get_main_queue()) {
                                            self.clearAllNotice()
                                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                            self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 5)
                                        }
                                    }else{
                                        
                                        //关闭网络请求hud
                                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                        
                                        //self.clearAllNotice()
                                        //把NSData对象转换回JSON对象
                                        let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                                        if json == nil {
                                            self.alert("网络异常，请重试")
                                            self.clearAllNotice()
                                        }else{
                                            let result : AnyObject = json.objectForKey("result")!
                                            
                                            //let mobile : AnyObject = json.objectForKey("mobile")!
                                            if String(result)=="发布成功"{
                                               
                                                //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                                                dispatch_async(dispatch_get_main_queue()) {
                                                    
                                                    self.alert("发布成功，请到<我的>中查看。")
                                                   // let tabBarViewController = self.storyBoard.instantiateViewControllerWithIdentifier("TabBarViewController") as! TabBarViewController
                                                    //self.tabBarController?.presetViewController(tabBarViewController, animated: true)
                                                    //self.tabBarController?.tabBar.selectedItem = (self.tabBarController?.tabBar.items![3])! as UITabBarItem
                                                    self.clearAllNotice()
                                                    //self.noticeInfo("发布成功", autoClear: true, autoClearTime: 2)
                                                    self.dateInfo.text=""
                                                    self.content.text=""
                                                    self.theme.text=""
                                                    self.action.text=""
                                                    self.contact.text=""
                                      
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            } catch {
                                print("loginValidate interface got an error creating the request: \(error)")
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
    }
    
    
    var datePicker:UIDatePicker = UIDatePicker()
    var alertview:UIView! = UIView()
    
    
    @IBAction func date(sender: AnyObject) {
        
        setDate()
    }
    
    func setDate() {
        
        
        
        var screen:UIScreen = UIScreen.mainScreen()
        var devicebounds:CGRect = screen.bounds
        var deviceWidth:CGFloat = devicebounds.width
        var deviceHeight:CGFloat = devicebounds.height
        var viewColor:UIColor = UIColor(white:0, alpha: 0.6)
        
        //设置日期弹出窗口
        alertview = UIView(frame:devicebounds)
        alertview.backgroundColor = viewColor
        alertview.userInteractionEnabled = true
        
        //设置datepicker
        datePicker.datePickerMode = .Date
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.frame = CGRect(x:0,y:deviceHeight/3,width:deviceWidth,height:216)
        
        //设置 确定 和 取消 按钮
        //var li_common:Li_common = Li_common()
        var selectedButton:UIButton = Li_createButton("确定",x:0,y:deviceHeight/3,width:deviceWidth/2,height:45,target:self, action: Selector("selectedAction"))
        var cancelButton:UIButton = Li_createButton("取消",x:deviceWidth/2,y:deviceHeight/3,width:deviceWidth/2,height:45,target:self, action: Selector("cancelAction"))
        
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
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        let animationDuration=0.30;
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect=CGRectMake(0.0,-140,width,height);
        self.view.frame=rect;
        UIView.commitAnimations()
        return true
    }
    
    
    
    
   
    func textViewDidEndEditing(textView: UITextView) {
        let animationDuration=0.30;
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect=CGRectMake(0.0,-20,width,height);
        self.view.frame=rect;
         UIView.commitAnimations()
    }
    
    
    //选择日期
    func selectedAction(){
        var dateString:String = self.dateString(datePicker.date)
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
    func dateString(date:NSDate) ->String{
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString:String = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    
    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print(formatter.stringFromDate(datePicker.date))
    }
    
 
    
    func valideLoginState()->Int{
        
        let userInfo=NSUserDefaults.standardUserDefaults()
        let token  =  userInfo.objectForKey("token")
        if token == nil{
            let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
            self.navigationController?.presentViewController(loginViewController, animated: true, completion: nil)
            return 0
        }else{
            return 1
            //alert("您已经登录")
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        dateInfo.resignFirstResponder()
        contact.resignFirstResponder()
        theme.resignFirstResponder()
        action.resignFirstResponder()
        content.resignFirstResponder()
        
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
    
    /*
     快速创建一种常用的button，state：normal，  backgroundcolor：white，  type：system    ControlEvents:TouchUpInside
     */
    func Li_createButton(title:String!,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,target: AnyObject!, action: Selector) ->UIButton{
        var buttonRect:CGRect = CGRect(x:x, y:y, width:width, height:height)
        let button:UIButton = UIButton(type: UIButtonType.System)
        button.setTitle(title, forState: UIControlState.Normal)
        button.frame = buttonRect
        button.backgroundColor = UIColor.whiteColor()
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    
}
