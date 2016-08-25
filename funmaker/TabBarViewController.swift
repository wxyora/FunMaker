//
//  TabBarViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/12.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //创建一个ContactAdd类型的按钮
        let button:UIButton = UIButton()
        //设置按钮位置和大小
        let swidth = UIScreen.mainScreen().bounds.width;
        let shight = UIScreen.mainScreen().bounds.height;
        button.frame=CGRectMake((swidth-50)/2,shight-75, 50, 50)
        
        button.layer.cornerRadius = 25
        //设置按钮文字
        button.setTitle("发布", forState:UIControlState.Normal)
        self.view.addSubview(button);
        
        
        button.setTitleColor(UIColor.whiteColor(),forState: .Normal) //普通状态下文字的颜色
        button.setTitleColor(UIColor.greenColor(),forState: .Highlighted) //触摸状态下文字的颜色
        button.setTitleColor(UIColor.grayColor(),forState: .Disabled) //禁用状态下文字的颜色
        
        button.backgroundColor=UIColor.blueColor()
        
        //不传递触摸对象（即点击的按钮）
        button.addTarget(self,action:Selector("tapped"),forControlEvents:UIControlEvents.TouchUpInside)
        
      
        
//        //传递触摸对象（即点击的按钮），需要在定义action参数时，方法名称后面带上冒号
//        button.addTarget(self,action:Selector("tapped1:"),forControlEvents:UIControlEvents.TouchUpInside)
//        func tapped1(button:UIButton){
//          
//        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapped(){
        let publishViewController = storyBoard.instantiateViewControllerWithIdentifier("PublishViewController") as! PublishViewController
        self.presentViewController(publishViewController, animated: true, completion: nil)
         //self.navigationController?.presentViewController(publishViewController, animated: true, completion: nil)
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
             print(String(item.title!))
//        if(String(item.title!)=="发布"){
//            let publishViewController = storyBoard.instantiateViewControllerWithIdentifier("PublishViewController") as! PublishViewController
//            self.presentViewController(publishViewController, animated: true, completion: nil)
//
//        }
 

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
