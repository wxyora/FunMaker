//
//  BaseViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/15.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let userInfo = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        //set navigation bar tile color ---titleTextAttributes = NSDicturnary
         //self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert(message:String){
        let alertController:UIAlertController!=UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (alertAciton) -> Void in })
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getToken()->String{
       
        if let token = userInfo.stringForKey("token"){
            return token
        }else{
            return ""
        }
        
    }
    
    func getMobie()->String{
        
        let mobile = userInfo.stringForKey("mobile")
        return mobile!
    }
    
    func clearToken(){
        
         userInfo.removeObjectForKey("token")
         userInfo.synchronize()
    }
    
    func generateToken(token:String){
        userInfo.setObject(token, forKey: "Token")
        userInfo.synchronize()

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
