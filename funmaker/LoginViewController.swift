//
//  ViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/25.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: BaseViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var message:String!
    
    @IBAction func goDown(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       

        userName.delegate=self
        password.delegate=self
        loginButton.layer.cornerRadius = 3
        self.navigationController!.navigationBar.tintColor=UIColor.white;
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.white]
    }
    
    

    
    @IBAction func login(_ sender: AnyObject) {
     
        userName.resignFirstResponder()
        password.resignFirstResponder()
        
        if userName.text?.isEmpty == true{
            message = "用户名不能为空"
            alert(message)
        }else{
            if password.text?.isEmpty == true{
                message = "密码不能为空"
                alert(message)
            }else{
                //开启网络请求hud
               
                self.pleaseWait()
                do {

                   
                    Alamofire.request(Constant.host+Constant.loginUrl,method:.get, parameters: ["mobile":userName.text!, "password": password.text!])
                        .responseJSON { response in
                            
                            if let myJson = response.result.value {
                                let dict = myJson as! Dictionary<String,AnyObject>
                                //let origin = dict["origin"] as! String
                                let result = dict["result"] as! String
                                if result=="用户不存在"{
                                    self.alert("用户不存在")
                                    self.clearAllNotice()
                                }else if result=="用户名密码不匹配"{
                                    self.alert("用户名密码不匹配")
                                    self.clearAllNotice()
                                }else if result=="登录成功"{

                                    let headImage = dict["headImage"] as! String
                                    let token = dict["token"] as! String
                                    let socketToken = dict["socketToken"] as! String
                                    //登录成功后链接融云
                                    RCIM.shared().initWithAppKey(Constant.rongyun_key)
                                    RCIM.shared().connect(withToken: socketToken,
                                                                       success: { (userId) -> Void in
                                                                        print("融云登陆成功。当前登录的用户ID：\(userId)")
                                                                        
                                        }, error: { (status) -> Void in
                                            print("登融云陆的错误码为:\(status.rawValue)")
                                        }, tokenIncorrect: {
                                            //token过期或者不正确。
                                            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                            print("token错误")
                                    })
                                    
                                    self.clearAllNotice()
                                    let userInfo:UserDefaults=UserDefaults.standard
                                    userInfo.set(token, forKey: "token")
                                    userInfo.set(self.userName.text, forKey: "mobile")
                                    userInfo.set(headImage, forKey: "headImage")
                                    userInfo.set(Constant.head_image_host+headImage+".png", forKey: "headImageUrl")
                                    userInfo.set(socketToken, forKey: "socketToken")
                                    userInfo.synchronize();
                                    
                                    DispatchQueue.main.async { [weak self] in
                                        self?.dismiss(animated: true, completion: nil)
                                    }

                                    
                                //设置当前用户信息
                                    RCIM.shared().currentUserInfo=RCUserInfo(userId: self.getMobile(), name: self.getMobile(), portrait: Constant.head_image_host+headImage+".png")
                                    
                                }
                                
                                 self.clearAllNotice()
                            }
                            
                    }
                    
                } catch {
                    print("loginValidate interface got an error creating the request: \(error)")
                }
                
            }
        
        }

    }
    


    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}

