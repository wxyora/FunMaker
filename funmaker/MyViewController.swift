//
//  MyViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class MyViewController: BaseViewController {

    @IBOutlet weak var loginNow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginNow.layer.cornerRadius=3
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
      
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
