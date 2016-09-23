//
//  TravelDetailViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/7.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit
import Alamofire

class TravelDetailViewController: BaseViewController {
    
    @IBOutlet weak var unionTheme: UILabel!
    @IBOutlet weak var contactWay: UILabel!
    @IBOutlet weak var outTime: UILabel!
    @IBOutlet weak var reachWay: UILabel!
    @IBOutlet weak var unionContent: UITextView!

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editItem: UIBarButtonItem!
    
//    let unionTheme = data!.objectForKey("unionTheme") as! String
//    let contactWay = data!.objectForKey("contactWay") as! String
//    let outTime = data!.objectForKey("outTime") as! String
//    let unionContent = data!.objectForKey("unionContent") as! String
//    let contactWay = data!.objectForKey("contactWay") as! String
    
    @IBAction func deleteByUnion(_ sender: AnyObject) {
        
        let alertController:UIAlertController!=UIAlertController(title: "", message: "您确定要删除？", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (alertAciton) -> Void in })
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (alertAciton) -> Void in
             self.deleteUnion()
          
            
            })
        self.present(alertController, animated: true, completion:nil)
       
    }

    
    @IBAction func editAction(_ sender: AnyObject) {
        //editItem.setTitleTextAttributes([String : "ddd"]?, forState: UIControlState.Normal.)
        if editItem.title == "编辑"{
             editItem.title="完成"
            deleteButton.isHidden=false
        }else{
            editItem.title="编辑"
            deleteButton.isHidden=true
        }
        
    }
    
    func deleteUnion() {
        
        
        
     
        
                            //开启网络请求hud
                            //UIApplication.shared.isNetworkActivityIndicatorVisible = true
                            self.pleaseWait()
        
                                
                                
                                let unionId = userInfo.string(forKey: "unionId")

                                Alamofire.request(Constant.host+Constant.deleteUnion,method:.get, parameters: ["unionId":unionId!])
                                    .responseJSON { response in
                                        
                                        if let myJson = response.result.value {
                                            let dict = myJson as! Dictionary<String,AnyObject>
                                            //let origin = dict["origin"] as! String
                                            let result = dict["result"] as! String
                                            
                                          
                                            
                                          
                                                DispatchQueue.main.async { [weak self] in
                                                    
                                                    if result=="删除成功"{
                                                        
                                                        //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                                                        
                                                            self?.noticeInfo("删除成功", autoClear: true, autoClearTime: 1)
                                                            self?.navigationController?.popViewController(animated: true)
                                                            
                                                    }
                                                    
                                                }
                                     }
                                        
                                }

        
        
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.layer.cornerRadius=3

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()

        initData()
    }
    
 
    
    
    func initData(){
        //开启网络请求hud
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.pleaseWait()
        
            
            
            
            let unionId = userInfo.string(forKey: "unionId")
            
            Alamofire.request(Constant.host+Constant.getUnionByUnionId,method:.get, parameters: ["unionId":unionId!])
                .responseJSON { response in
                    
                    if let myJson = response.result.value {
                        let dict = myJson as! Dictionary<String,AnyObject>
                        let data = dict["data"] as! Dictionary<String,AnyObject>
                    
         
                        
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            self?.unionTheme.text = data["unionTheme"] as? String
                            self?.contactWay.text =  data["contactWay"] as? String
                            self?.outTime.text =  data["outTime"] as? String
                            self?.unionContent.text =  data["unionContent"] as? String
                            self?.reachWay.text = data["reachWay"] as? String
                            
                        }
                    }else{
                         self.noticeInfo("没有数据", autoClear: true, autoClearTime: 1)
                    }
                    
                     self.clearAllNotice()
                    
            }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
