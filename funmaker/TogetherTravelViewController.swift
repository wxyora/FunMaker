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
    
    
    
    var idleImages:NSMutableArray = []
    var refreshingImages:NSMutableArray = []
    var objectArr = [String]()
    var i = 0
    //页码
    var pageNo:Int = 1
    
    //每页显示条数
    let pageCount:Int = 8
    
    
    var tableViewData:AnyObject?
    
     var thumbQueue = NSOperationQueue()
    
      var dataSource = NSMutableArray()
    
      let allData : NSMutableArray = []

    

    
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
        
         initData()
        
        
        
        
//        
//        for(var i = 1; i<=10; i += 1){
//            self.objectArr.append("\(i)")
//        }
//        
//        // 设置普通状态的动画图片
//        for (var i = 1; i<=60; i += 1) {
//            let image:UIImage = UIImage(named: "dropdown_anim__000\(i)")! as UIImage
//            idleImages.addObject(image)
//        }
//        
//        // 设置普通状态的动画图片
//        for (var i = 1; i<=3; i++) {
//            var image: UIImage = UIImage(named: "dropdown_loading_0\(i)")! as UIImage
//            idleImages.addObject(image)
//        }
        
        //定义动画刷新Header
//        let header:MJRefreshGifHeader = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
//        //设置普通状态动画图片
//        header.setImages(idleImages as [AnyObject], forState: MJRefreshState.Idle)
//        //设置下拉操作时动画图片
//        header.setImages(refreshingImages as [AnyObject], forState: MJRefreshState.Pulling)
//        //设置正在刷新时动画图片
//        header.setImages(idleImages as [AnyObject], forState: MJRefreshState.Refreshing)
        
        //设置mj_header
        //self.tableView.mj_header = header
        //普通带文字下拉刷新的定义
        //self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        //普通带文字上拉加载的定义
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(TogetherTravelViewController.footerRefresh))

        
        
        
        
        
        
        
        
        
        
        
    }
    
    //下拉刷新操作
    func headerRefresh(){
        //模拟数据请求，设置10s是为了便于观察动画
//        self.delay(10) { () -> () in
//            self.objectArr.removeAll()
//            self.i = 10
//            for self.i ; self.i<20 ; self.i++ {
//                self.objectArr.append("\(self.i)")
//            }
//            //结束刷新
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.reloadData()
//        }
        self.tableView.mj_footer.endRefreshing()
        self.tableView.reloadData()

        print("下拉刷新操作")
    }
    
    //上拉加载操作
    func footerRefresh(){
        //模拟数据请求，设置10s是为了便于观察动画
//        self.delay(10) { () -> () in
//            let j = self.i + 10
//            for self.i ; self.i<j ; self.i++ {
//                self.objectArr.append("\(self.i)")
//            }
//            //结束刷新
//            self.tableView.mj_footer.endRefreshing()
//            self.tableView.reloadData()
//        }
        
        self.tableView.mj_footer.endRefreshing()
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        getData()
       // print("上拉加载操作")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
       
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
            let opt = try HTTP.GET(Constant.host+Constant.getAllUnionByPage,parameters: ["beginPage":"0","endPage":String(pageCount)])
            
            opt.start { response in
                
                if let err = response.error {
                    
                    //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                    dispatch_async(dispatch_get_main_queue()) {
                        self.clearAllNotice()
                         UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 2)
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
       
                        if let data : NSMutableArray = json.objectForKey("data") as? NSMutableArray{
                            dispatch_async(dispatch_get_main_queue()) {
                                self.allData.removeAllObjects()
                                self.pageNo = 0
                                for d in data{
                                    self.allData.addObject(d)
                                }
                                self.tableViewData = self.allData
                                self.refreshControl?.endRefreshing()
                                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                                self.tableView.reloadData()
                                
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue()) {
                                self.noticeInfo("没有数据", autoClear: true, autoClearTime: 1)
                            }
                            
                        }
                    }
                    
                }
                
            }
            
        } catch {
              self.noticeError(String(error), autoClear: true, autoClearTime: 3)
        }
    }
    
    func getData(){
        
    
       
        
        //开启网络请求hud
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //self.pleaseWait()
        do {
             let opt = try HTTP.GET(Constant.host+Constant.getAllUnionByPage,parameters: ["beginPage":String(pageNo*pageCount+pageCount),"endPage":String(pageCount)])
            
            opt.start { response in
                
                if let err = response.error {
                    //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
                    dispatch_async(dispatch_get_main_queue()) {
                        self.clearAllNotice()
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 2)
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
                        if let data : NSMutableArray = json.objectForKey("data") as? NSMutableArray{
                            dispatch_async(dispatch_get_main_queue()) {
                                for d in data{
                                    self.allData.addObject(d)
                                }
                                self.tableViewData = self.allData
                                self.refreshControl?.endRefreshing()
                                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                                self.tableView.reloadData()
                                
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue()) {
                             self.clearAllNotice()
                             self.noticeInfo("没有信息了", autoClear: true, autoClearTime: 1)
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
              self.noticeError(String(error), autoClear: true, autoClearTime: 3)
        }
        
         pageNo += 1
        
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
            initData()
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
            
            var mobile = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("mobile")!)
            //let headImage = tableViewData!.objectAtIndex(indexPath.row).objectForKey("headImage")! as! UIImage
            
            //解决Optional("***")问题
            cell.unionTheme.text = unionTheme
            cell.outTime.text=outTime
            cell.unionId.text=unionId
            cell.publishTime.text=publishTime
           


            
//            let dispath=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
//            dispatch_async(dispath, { () -> Void in
//
//                if let image = self.tableViewData!.objectAtIndex(indexPath.row).objectForKey("headImage"){
//                    let headUrl = String(image);
//                    let url:NSURL = NSURL(string:Constant.host+Constant.headImageUrl+"head"+".png")!
//                    let data=NSData(contentsOfURL: url)
//                    if data != nil {
//                        let ZYHImage=UIImage(data: data!)
//                        //写缓存
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            //刷新主UI
//                            cell.rentInfoImage.image=ZYHImage
//                        })
//                    }
//                }
//                
//            })
            
            
            if let image = self.tableViewData!.objectAtIndex(indexPath.row).objectForKey("headImage"){
                let headUrl = String(image);
                if(headUrl != "<null>"){
                    var str = Constant.host+Constant.headImageUrl+headUrl+".png"
                    //防止url报出空指针异常
                    str = str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    let url:NSURL = NSURL(string:str)!
                  
                    let request = NSURLRequest(URL:url)
                    NSURLConnection.sendAsynchronousRequest(request, queue: thumbQueue, completionHandler: { response, data, error in
                        if (error != nil) {
                            print(error)
                            
                        } else {
                            let image = UIImage.init(data :data!)
                            dispatch_async(dispatch_get_main_queue(), {
                                cell.rentInfoImage.image = image
                            })
                        }
                    })
                }

            }

            
           
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



    