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
        button.frame=CGRectMake((swidth-55)/2,shight-65, 55, 55)
        
        button.layer.cornerRadius = 27.5
        
        
        
        //创建一个ContactAdd类型的按钮
        let button1:UIButton = UIButton()
        //设置按钮位置和大小
     
        button1.frame=CGRectMake((swidth-52)/2,shight-140, 52, 52)
        
        button1.layer.cornerRadius = 26
        //设置按钮文字
        button.setTitle("发布", forState:UIControlState.Normal)
        button1.setTitle("结伴", forState:UIControlState.Normal)
        //self.view.addSubview(button);
        //self.view.addSubview(button1);
        
        button.setTitleColor(UIColor.whiteColor(),forState: .Normal) //普通状态下文字的颜色
        button.setTitleColor(UIColor.greenColor(),forState: .Highlighted) //触摸状态下文字的颜色
        button.setTitleColor(UIColor.grayColor(),forState: .Disabled) //禁用状态下文字的颜色
        button.backgroundColor=UIColor(colorLiteralRed: 17/255, green: 128/255, blue: 255/255, alpha: 1)
        
        button1.setTitleColor(UIColor.whiteColor(),forState: .Normal) //普通状态下文字的颜色
        button1.setTitleColor(UIColor.greenColor(),forState: .Highlighted) //触摸状态下文字的颜色
        button1.setTitleColor(UIColor.grayColor(),forState: .Disabled) //禁用状态下文字的颜色
        button1.backgroundColor=UIColor(colorLiteralRed: 17/255, green: 128/255, blue: 255/255, alpha: 1)
        
        //IColor *color1=[UIColor colorWithRed:155/255 green:255/255 blue:255/255 alpha:1];
        
        //不传递触摸对象（即点击的按钮）
        button.addTarget(self,action:Selector("tapped"),forControlEvents:UIControlEvents.TouchUpInside)
        
        
//        
//        var bubbleMenuButton = DWBubbleMenuButton(frame: CGRectMake(80.0,
//            80.0,
//            button.frame.size.width,
//            button.frame.size.height), expansionDirection: ExpansionDirection.DirectionDown)
//        
//        bubbleMenuButton.homeButtonView = button;
//        
//        bubbleMenuButton.addButtons([button1])

        let menuItemImage = UIImage(named: "Add")!
        let menuItemHighlitedImage = UIImage(named: "Add")!
        let starImage = UIImage(named: "Add")!
        
        
        let menuItemImage2 = UIImage(named: "Add")!
        let menuItemHighlitedImage2 = UIImage(named: "Add")!
        let starImage2 = UIImage(named: "Add")!


        let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        
        let starMenuItem2 = PathMenuItem(image: menuItemImage2, highlightedImage: menuItemHighlitedImage2, contentImage: starImage2)

        
        let items = [starMenuItem1, starMenuItem2]
        
        let startItem = PathMenuItem(image: UIImage(named: "Add")!,
                                     highlightedImage: UIImage(named: "Add"),
                                     contentImage: UIImage(named: "Add"),
                                     highlightedContentImage: UIImage(named: "Add"))
        
        let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
        menu.delegate = self
        menu.startPoint     = CGPointMake(UIScreen.mainScreen().bounds.width/2, view.frame.size.height - 32.0)
        menu.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/1.5)
        menu.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/1.5) * 1/2
        menu.timeOffset     = 0.0
        menu.farRadius      = 110.0
        menu.nearRadius     = 90.0
        menu.endRadius      = 100.0
        menu.animationDuration = 0.5
        
//        let wholeView = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
//        wholeView.backgroundColor = UIColor.darkGrayColor()
//        wholeView.alpha = 0.5
//        view.addSubview(wholeView)
        view.addSubview(menu)
       // view.backgroundColor = UIColor.blueColor()

        
    
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
        
             //print(String(item.title!))
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


extension TabBarViewController: PathMenuDelegate {
    func pathMenu(menu: PathMenu, didSelectIndex idx: Int) {
        print("Select the index : \(idx)")
        if idx == 0{
            let publishViewController = storyBoard.instantiateViewControllerWithIdentifier("PublishViewController") as! PublishViewController
            self.presentViewController(publishViewController, animated: true, completion: nil)

        }else if idx==1 {
            //self.noticeInfo("敬请期待", autoClear: true, autoClearTime: 1)
            
            let photoViewController = storyBoard.instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
            self.presentViewController(photoViewController, animated: true, completion: nil)
        }
    }
    
    func pathMenuWillAnimateOpen(menu: PathMenu) {
        //print("Menu will open!")
    }
    
    func pathMenuWillAnimateClose(menu: PathMenu) {
        //print("Menu will close!")
    }
    
    func pathMenuDidFinishAnimationOpen(menu: PathMenu) {
        //print("Menu was open!")
    }
    
    func pathMenuDidFinishAnimationClose(menu: PathMenu) {
        //print("Menu was closed!")
    }
}

