//
//  TogetherTravelViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/14.
//  Copyright © 2016年 Waylon. All rights reserved.
//
import UIKit
import SwiftHTTP

class TogetherTravelViewController: BaseViewController,UISearchBarDelegate{
    
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var progressShow: UIActivityIndicatorView?
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageScrollView: UIScrollView!
    
    var tableViewData:AnyObject?
    
    
    var str = ["香港5日游","泰国8日游"]
    // @IBOutlet var searchBar: UISearchBar!
    
    //    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    //        self.searchBar.resignFirstResponder()
    //    }
    
    override func viewDidLoad() {
        
        self.navigationController!.navigationBar.tintColor=UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()
        
        
        //NSThread.sleepForTimeInterval(1.0) //延长2秒
        super.viewDidLoad()
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]
        // self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]
        //myWebView.delegate = self
        //let url = NSURL(string: "https://login.m.taobao.com/login.htm")!
        //let request = NSURLRequest(URL: url)
        //myWebView.loadRequest(request)
        
        // self.tableView.registerClass(CustomCell.self, forCellReuseIdentifier:"RentInfoCell")
        
        //self.tableView.registerClass(CustomCell.self, forCellReuseIdentifier:"RentInfoCell")
        
        // self.searchBar.delegate = self
        
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(IndexViewController.refreshTableView), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        
        //set pagecontrol infomation
        //pageControl.currentPage = 0
        //pageControl.numberOfPages = 4
        
        // 获取scrollview wight and hight
        let wight:CGFloat=UIScreen.mainScreen().bounds.width
        let hight=self.pageScrollView.frame.height
        //设置scrollview 4个区域
        pageScrollView.contentSize = CGSize(width: 4*wight, height: hight)
        //         pageScrollView.contentSize=CGSizeMake(
        //            CGFloat(CGRectGetWidth(self.view.bounds)) * CGFloat(4),
        //            CGRectGetHeight(self.view.bounds))
        
        //set scrollview delegete
        pageScrollView.delegate=self
        
        //关闭滚动条显示
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.scrollsToTop = false
        
        let totalCount = 4
        
        
        
        for index in 0..<totalCount{
            //let imageView:UIImageView = UIImageView();
            let imageX:CGFloat = CGFloat(index) * wight;
            let imageView:UIImageView = UIImageView(frame: CGRectMake(imageX, 0, wight, 128))
            //let imageX:CGFloat = CGFloat(index) * wight;
            //imageView.frame = CGRectMake(imageX, hight, wight, hight);//设置图片的大小，注意Image和ScrollView的关系，其实几张图片是按顺序从左向右依次放置在ScrollView中的，但是ScrollView在界面中显示的只是一张图片的大小，效果类似与画廊；
            let name:String = String(format: "gallery%d.png", index);
            //imageView.image = UIImage(named:name);
            imageView.image = UIImage(named: name)
            self.pageScrollView.showsHorizontalScrollIndicator = false;//不设置水平滚动条；
            self.pageScrollView.addSubview(imageView)//把图片加入到ScrollView中去，实现轮播的效果；
            //self.pageScrollView.addSubview(imageView)
        }
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        initData()
    }
    
    //    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        let indexTravelDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("IndexTravelDetailViewController") as! IndexTravelDetailViewController
    //        self.navigationController?.pushViewController(indexTravelDetailViewController, animated: true)
    //    }
    
    
    
    func initData(){
        //开启网络请求hud
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.pleaseWait()
        do {
            let opt = try HTTP.GET(Constant.host+Constant.getAllUnionByPage,parameters: ["beginPage":"0","endPage":"10000"])
            
            opt.start { response in
                
                if let err = response.error {
                    
                    //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                    dispatch_async(dispatch_get_main_queue()) {
                        self.clearAllNotice()
                         UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 5)
                    }
                }else{
                    
                    //关闭网络请求hud
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.clearAllNotice()
                    //把NSData对象转换回JSON对象
                    let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                    if json == nil {
                        self.alert("网络异常，请重试")
                        self.clearAllNotice()
                    }else{
                        let data : NSArray = json.objectForKey("data") as! NSArray
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableViewData = data
                            self.refreshControl?.endRefreshing()
                            self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                            self.tableView.reloadData()
                            if data.count == 0{
                                self.noticeInfo("没有数据", autoClear: true, autoClearTime: 1)
                            }
                        }
                    }
                    
                }
                
            }
            
        } catch {
            print("loginVaidate interface got an error creating the request: \(error)")
        }
    }
    
    func getData(){
        
        //开启网络请求hud
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //self.pleaseWait()
        do {
             let opt = try HTTP.GET(Constant.host+Constant.getAllUnionByPage,parameters: ["beginPage":"0","endPage":"10000"])
            
            opt.start { response in
                
                if let err = response.error {
                    //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                    dispatch_async(dispatch_get_main_queue()) {
                        self.clearAllNotice()
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 5)
                    }
                }else{
                    
                    
                    
                    //关闭网络请求hud
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    //self.clearAllNotice()
                    //把NSData对象转换回JSON对象
                    let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
                    if json == nil {
                        self.alert("网络异常，请重试")
                        self.clearAllNotice()
                    }else{
                        let data : NSArray = json.objectForKey("data") as! NSArray
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableViewData = data
                            self.refreshControl?.endRefreshing()
                            self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                            self.tableView.reloadData()
                            if data.count == 0{
                                self.noticeInfo("没有数据", autoClear: true, autoClearTime: 1)
                            }
                        }
                    }
                    
                    
                    
                    
//                    //关闭网络请求hud
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                    //self.clearAllNotice()
//                    //把NSData对象转换回JSON对象
//                    let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
//                    if json == nil {
//                        self.alert("网络异常，请重试")
//                        self.clearAllNotice()
//                    }else{
//                        let data : NSArray = json.objectForKey("data") as! NSArray
//                        dispatch_async(dispatch_get_main_queue()) {
//                            self.tableViewData! = data
//                            self.refreshControl?.endRefreshing()
//                            self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
//                            self.tableView.reloadData()
//                            if data.count == 0{
//                                self.noticeInfo("没有数据", autoClear: true, autoClearTime: 1)
//                            }
//                        }
//
//
//                    }
                    
                }
                
            }
            
        } catch {
            print("loginValidate interface got an error creating the request: \(error)")
        }
        
        
    }
    
    
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的是第几页
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //设置pageController的当前页
        pageControl.currentPage = page
    }
    
    func refreshTableView(){
        
        if(self.refreshControl?.refreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            getData()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        progressShow?.stopAnimating()
        progressShow?.hidesWhenStopped = true
        
        
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        progressShow?.startAnimating()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableViewData == nil{
            return 0
            
        }else{
            return tableViewData!.count
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:CustomCell! = tableView.dequeueReusableCellWithIdentifier("TogetherInfoCell", forIndexPath: indexPath) as? CustomCell
        if(cell == nil){
            cell = CustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TogetherInfoCell")
        }else{
            
            let unionTheme:String = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("unionTheme")!)
            let outTime = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("outTime")!)
            let unionId = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("unionId")!)
            let publishTime = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("publishTime")!)
            let imageObj = tableViewData!.objectAtIndex(indexPath.row).objectForKey("headImage")!
            var mobile = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("mobile")!)
            //let headImage = tableViewData!.objectAtIndex(indexPath.row).objectForKey("headImage")! as! UIImage
            
            
             //            if(headImage){
//                
//            }else{
//                alert(headImage)
//            }
            //解决Optional("***")问题
            cell.unionTheme.text = unionTheme
            cell.outTime.text=outTime
            cell.unionId.text=unionId
            cell.publishTime.text=publishTime
           
           // let headData = imageObj as? UIImage
            
          
           // var URL:NSURL = NSURL(string: "http://p2.qqyou.com/touxiang/UploadPic/2016-8/17/a3dec7cada44965e2bbad1d13ee7ba32.jpg")!
           // var data:NSData?=NSData(contentsOfURL: URL)


            
            var dispath=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
            dispatch_async(dispath, { () -> Void in
                var URL:NSURL = NSURL(string: "http://p2.qqyou.com/touxiang/UploadPic/2016-8/17/a3dec7cada44965e2bbad1d13ee7ba32.jpg")!
                var data:NSData?=NSData(contentsOfURL: URL)
                if data != nil {
                    let ZYHImage=UIImage(data: data!)
                    //写缓存
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //刷新主UI
                        cell.rentInfoImage.image=ZYHImage
                    })
                }
                
            })
         
          
           
            //let head = UIImage(data: data!)
            
          
          //cell.rentInfoImage.image = head
          
            
            let subRange=Range(start: mobile.startIndex.advancedBy(3), end: mobile.startIndex.advancedBy(7)) //Swift 2.0
            mobile.replaceRange(subRange, with: "****")
            cell.account.text=mobile
            
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        var cell:CustomCell = tableView.cellForRowAtIndexPath(indexPath) as! CustomCell
        let unionId = cell.unionId.text
        
        userInfo.setObject(unionId, forKey: "unionId")
        userInfo.synchronize()
        
        let indexTravelDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("IndexTravelDetailViewController") as! IndexTravelDetailViewController
        self.navigationController?.pushViewController(indexTravelDetailViewController, animated: true)
        
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func acitonSheet(sender: AnyObject) {
        //UIAlertController默认不传参数就是actionSheet操作表控件
        let actionSheet = UIAlertController()
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAciton) -> Void in
            print("取消")
            })
        actionSheet.addAction(UIAlertAction(title: "腾讯QQ", style: UIAlertActionStyle.Destructive) { (alertAciton) -> Void in
            print("腾讯QQ")
            })
        actionSheet.addAction(UIAlertAction(title: "新浪微博", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
            print("新浪微博")
            })
        actionSheet.addAction(UIAlertAction(title: "微信", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
            print("微信")
            })
        
        actionSheet.addAction(UIAlertAction(title: "朋友圈", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
            print("朋友圈")
            })
        
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
}



    