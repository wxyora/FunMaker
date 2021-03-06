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
    
    //var menu : PathMenu?
    
    var addButton:UIButton?
    
    func changeHidden(){
       addButton?.isHidden = true
    }
    
    func changeShow(){
       addButton?.isHidden = false
    }

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let userInfo:UserDefaults=UserDefaults.standard
        let token = userInfo.value(forKey: "token")

        //print(viewController.title)
        if viewController.title=="消息导航"{
            if(token != nil){
                
                return true
               
            }else{
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
                self.present(loginViewController, animated: true, completion: nil)
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
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarViewController.changeShow), name: NSNotification.Name(rawValue: PopoverAnimatorWillShow), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarViewController.changeHidden), name: NSNotification.Name(rawValue: PopoverAnimatorWillDismiss), object: nil)
        
        let screenBounds:CGRect = UIScreen.main.bounds
        let s_width = screenBounds.width
        let s_height =  screenBounds.height
        addButton = UIButton(frame: CGRect(x: (s_width - 50)/2, y: s_height - 8 - 50, width: 50, height: 50))
        addButton?.setBackgroundImage(UIImage(named:"add"),for:.normal)
        addButton?.addTarget(self, action: Selector("publishTravel"), for: UIControlEvents.touchUpInside)
        self.view.addSubview(addButton!)

//        let menuItemImage = UIImage(named: "jieban")!
//        let menuItemHighlitedImage = UIImage(named: "jieban")!
//        let starImage = UIImage(named: "jieban")!
//        let menuItemImage2 = UIImage(named: "minsu")!
//        let menuItemHighlitedImage2 = UIImage(named: "minsu")!
//        let starImage2 = UIImage(named: "minsu")!
        
       // let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        
        //let starMenuItem2 = PathMenuItem(image: menuItemImage2, highlightedImage: menuItemHighlitedImage2, contentImage: starImage2)
        
        
       // let items = [starMenuItem1, starMenuItem2]
        
       // let startItem = PathMenuItem(image: UIImage(named: "add")!,
                                     //highlightedImage: UIImage(named: "add"),
                                     //contentImage: UIImage(named: "add"),
                                    // highlightedContentImage: UIImage(named: "add"))
        
//        menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
//        menu!.delegate = self
//        menu!.startPoint     = CGPoint(x: UIScreen.main.bounds.width/2, y: view.frame.size.height - 30.0)
//        menu!.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/1.5)
//        menu!.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/1.5) * 1/2
//        menu!.timeOffset     = 0.0
//        menu!.farRadius      = 110.0
//        menu!.nearRadius     = 90.0
//        menu!.endRadius      = 100.0
//        menu!.animationDuration = 0.5
//        
//        view.addSubview(menu!)
     //   view.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.92, alpha:1)

        

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
        let publishViewController = storyBoard.instantiateViewController(withIdentifier: "PublishViewController") as! PublishViewController
        self.present(publishViewController, animated: true, completion: nil)
         //self.navigationController?.presentViewController(publishViewController, animated: true, completion: nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "消息"{
        

        }
    }
    
    
    func publishTravel(){
        let publishViewController = storyBoard.instantiateViewController(withIdentifier: "PublishViewController") as! PublishViewController
        self.present(publishViewController, animated: true, completion: nil)

    }

    

}


//extension TabBarViewController: PathMenuDelegate {
//    func pathMenu(_ menu: PathMenu, didSelectIndex idx: Int) {
//        //print("Select the index : \(idx)")
//        menu.menuItems.first?.isHidden=true
//        menu.menuItems[1].isHidden=true
//        if idx == 0{
//            let publishViewController = storyBoard.instantiateViewController(withIdentifier: "PublishViewController") as! PublishViewController
//            self.present(publishViewController, animated: true, completion: nil)
//
//        }else if idx==1 {
//            //self.noticeInfo("敬请期待", autoClear: true, autoClearTime: 1)
//            
////            let photoViewController = storyBoard.instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
////            self.presentViewController(photoViewController, animated: true, completion: nil)
//        }
//    }
//    
//    func pathMenuWillAnimateOpen(_ menu: PathMenu) {
//        //print("Menu will open!")
//     menu.menuItems.first?.isHidden=false
//         menu.menuItems[1].isHidden=false
//        
//    }
//    
//    func pathMenuWillAnimateClose(_ menu: PathMenu) {
//        //print("Menu will close!")
//    }
//    
//    func pathMenuDidFinishAnimationOpen(_ menu: PathMenu) {
//        //print("Menu was open!")
//    }
//    
//    func pathMenuDidFinishAnimationClose(_ menu: PathMenu) {
//        //print("Menu was closed!")
//        menu.menuItems.first?.isHidden=true
//        menu.menuItems[1].isHidden=true
//      
//    }
//   
//}
//
