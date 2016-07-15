//
//  RegistViewController.swift
//  funmaker
//
//  Created by Waylon on 16/6/27.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController {

    @IBOutlet weak var getPhoneCode: UIButton!
    
    @IBOutlet weak var commitUserInfo: UIButton!
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            print("cancel button is pressed")
        }
    }
    @IBAction func save(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            print("cave button is pressed")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("registerName",object: "")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhoneCode.layer.cornerRadius = 3
        commitUserInfo.layer.cornerRadius = 3

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
