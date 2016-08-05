//
//  ConfigViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/28.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class ConfigViewController: UITableViewController {

    @IBOutlet weak var loginOutButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
  
    @IBAction func loginOut(sender: AnyObject) {
        let userInfo=NSUserDefaults.standardUserDefaults()
        userInfo.removeObjectForKey("token")
        userInfo.synchronize()
        //NSNotificationCenter.defaultCenter().postNotificationName("LoginOutSuccessNotification", object:nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginOutButton.layer.cornerRadius=3
         //self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Do any additional setup after loading the view.
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
