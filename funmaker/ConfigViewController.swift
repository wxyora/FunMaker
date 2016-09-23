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

  
    @IBAction func loginOut(_ sender: AnyObject) {
        
        let alertController:UIAlertController!=UIAlertController(title: "", message: "您确定要注销？", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (alertAciton) -> Void in })
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (alertAciton) -> Void in
            let userInfo=UserDefaults.standard
            userInfo.removeObject(forKey: "token")
            userInfo.removeObject(forKey: "socketToken")
            userInfo.synchronize()
            RCIM.shared().disconnect()
            //NSNotificationCenter.defaultCenter().postNotificationName("LoginOutSuccessNotification", object:nil)
            self.navigationController?.popViewController(animated: true)})
        self.present(alertController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = getToken()
        if token.isEmpty{
          loginOutButton.isHidden = true
        }else{
             loginOutButton.isHidden = false
        }
        
        loginOutButton.layer.cornerRadius=3
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let token = getToken()
        if (indexPath as NSIndexPath).row == 0{
            if token.isEmpty{
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
                self.navigationController?.present(loginViewController, animated: true, completion: nil)
            }else{
                let myProfileViewController = storyBoard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                self.navigationController?.pushViewController(myProfileViewController, animated: true)
            }
            
        }
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
