//
//  TabBarViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/12.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {
    

    let PopoverAnimatorWillShow = "PopoverAnimatorWillShow"
    let PopoverAnimatorWillDismiss = "PopoverAnimatorWillDismiss"
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    var menu : PathMenu?
    
    func changeHidden(){
       menu?.hidden = true
    }
    
    func changeShow(){
        menu?.hidden = false
    }

    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        let userInfo:NSUserDefaults=NSUserDefaults.standardUserDefaults()
        let token = userInfo.valueForKey("token")

        //print(viewController.title)
        if viewController.title=="消息导航"{
            if(token != nil){
                
                return true
               
            }else{
                let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
                self.presentViewController(loginViewController, animated: true, completion: nil)
                return false
            }
        }else{
            return true
 
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.badgeValue="2"
        //tabBarControllerDelegate委托的绑定方式
        
        self.delegate = self ;
        // 3.注册通知，监听菜单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarViewController.changeShow), name: PopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarViewController.changeHidden), name: PopoverAnimatorWillDismiss, object: nil)
        
        let menuItemImage = UIImage(named: "jieban")!
        let menuItemHighlitedImage = UIImage(named: "jieban")!
        let starImage = UIImage(named: "jieban")!
        let menuItemImage2 = UIImage(named: "minsu")!
        let menuItemHighlitedImage2 = UIImage(named: "minsu")!
        let starImage2 = UIImage(named: "minsu")!
        
        let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        
        let starMenuItem2 = PathMenuItem(image: menuItemImage2, highlightedImage: menuItemHighlitedImage2, contentImage: starImage2)
        
        
        let items = [starMenuItem1, starMenuItem2]
        
        let startItem = PathMenuItem(image: UIImage(named: "add")!,
                                     highlightedImage: UIImage(named: "add"),
                                     contentImage: UIImage(named: "add"),
                                     highlightedContentImage: UIImage(named: "add"))
        
        menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
        menu!.delegate = self
        menu!.startPoint     = CGPointMake(UIScreen.mainScreen().bounds.width/2, view.frame.size.height - 30.0)
        menu!.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/1.5)
        menu!.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/1.5) * 1/2
        menu!.timeOffset     = 0.0
        menu!.farRadius      = 110.0
        menu!.nearRadius     = 90.0
        menu!.endRadius      = 100.0
        menu!.animationDuration = 0.5
        
        view.addSubview(menu!)
        view.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.92, alpha:1)

        

//        let menuItemImage = UIImage(named: "jieban")!
//        let menuItemHighlitedImage = UIImage(named: "jieban")!
//        let starImage = UIImage(named: "jieban")!
//        
//        
//        let menuItemImage2 = UIImage(named: "minsu")!
//        let menuItemHighlitedImage2 = UIImage(named: "minsu")!
//        let starImage2 = UIImage(named: "minsu")!
//
//
//        let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
//        
//        let starMenuItem2 = PathMenuItem(image: menuItemImage2, highlightedImage: menuItemHighlitedImage2, contentImage: starImage2)
//
//        
//        let items = [starMenuItem1, starMenuItem2]
//        
//        let startItem = PathMenuItem(image: UIImage(named: "Add")!,
//                                     highlightedImage: UIImage(named: "Add"),
//                                     contentImage: UIImage(named: "Add"),
//                                     highlightedContentImage: UIImage(named: "Add"))
//        
//        let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
//        menu.delegate = self
//        menu.startPoint     = CGPointMake(UIScreen.mainScreen().bounds.width/2, view.frame.size.height - 32.0)
//        menu.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/1.5)
//        menu.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/1.5) * 1/2
//        menu.timeOffset     = 0.0
//        menu.farRadius      = 140.0
//        menu.nearRadius     = 120.0
//        menu.endRadius      = 130.0
//        menu.animationDuration = 0.5
//
//        view.addSubview(menu)


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
        if item.title == "消息"{
        

        }
    }
    

    

}


extension TabBarViewController: PathMenuDelegate {
    func pathMenu(menu: PathMenu, didSelectIndex idx: Int) {
        //print("Select the index : \(idx)")
        menu.menuItems.first?.hidden=true
        menu.menuItems[1].hidden=true
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
        print("Menu will open!")
     menu.menuItems.first?.hidden=false
         menu.menuItems[1].hidden=false

    }
    
    func pathMenuWillAnimateClose(menu: PathMenu) {
        print("Menu will close!")
    }
    
    func pathMenuDidFinishAnimationOpen(menu: PathMenu) {
        print("Menu was open!")
    }
    
    func pathMenuDidFinishAnimationClose(menu: PathMenu) {
        print("Menu was closed!")
        menu.menuItems.first?.hidden=true
        menu.menuItems[1].hidden=true
      
    }
   
}

