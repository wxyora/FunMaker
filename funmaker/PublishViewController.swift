//
//  PublishViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class PublishViewController: UITableViewController ,UITextFieldDelegate,UITextViewDelegate{

    @IBOutlet weak var publish: UIButton!
    @IBOutlet weak var senery: UITextField!
    @IBOutlet weak var action: UITextField!
    @IBOutlet weak var contact: UITextField!
    @IBOutlet weak var dateInfo: UITextField!
    @IBOutlet weak var detailInfo: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        detailInfo.layer.cornerRadius = 4
        publish.layer.cornerRadius = 4
        detailInfo.delegate=self
        dateInfo.delegate=self
        contact.delegate=self
        senery.delegate=self
        action.delegate=self

    }



    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        dateInfo.resignFirstResponder()
        contact.resignFirstResponder()
        senery.resignFirstResponder()
        action.resignFirstResponder()
        
        
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
    

}
