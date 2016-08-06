//
//  ConfigViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/28.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class ConfigViewController: BaseViewController {

    @IBOutlet weak var loginOutButton: UIButton!

  
    @IBAction func loginOut(sender: AnyObject) {
        
        let alertController:UIAlertController!=UIAlertController(title: "", message: "您确定要注销？", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){ (alertAciton) -> Void in
            let userInfo=NSUserDefaults.standardUserDefaults()
            userInfo.removeObjectForKey("token")
            userInfo.synchronize()
            //NSNotificationCenter.defaultCenter().postNotificationName("LoginOutSuccessNotification", object:nil)
            self.navigationController?.popViewControllerAnimated(true)})
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = getToken()
        if token.isEmpty{
          loginOutButton.hidden = true
        }else{
             loginOutButton.hidden = false
        }
        
        loginOutButton.layer.cornerRadius=3
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
