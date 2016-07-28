//
//  MyCustomCell.swift
//  funmaker
//
//  Created by Waylon on 16/7/27.
//  Copyright © 2016年 Waylon. All rights reserved.
//


import UIKit

class MyCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func loginout(sender: AnyObject) {
        
        let userInfo=NSUserDefaults.standardUserDefaults()
        userInfo.removeObjectForKey("token")
        userInfo.synchronize()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loginButton.layer.cornerRadius=3
      
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
