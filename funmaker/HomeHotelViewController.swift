//
//  TogetherTravelViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/14.
//  Copyright © 2016年 Waylon. All rights reserved.
//
import UIKit


class HomeHotellViewController: BaseViewController,UISearchBarDelegate{
    
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
        
        self.navigationController!.navigationBar.tintColor=UIColor.white;
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.white]
        
        
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()
        
        
        //NSThread.sleepForTimeInterval(1.0) //延长2秒
        super.viewDidLoad()
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.white]
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
        rc.addTarget(self, action: #selector(IndexViewController.refreshTableView), for: UIControlEvents.valueChanged)
        self.refreshControl = rc
        
        //set pagecontrol infomation
        //pageControl.currentPage = 0
        //pageControl.numberOfPages = 4
        
        // 获取scrollview wight and hight
        let wight:CGFloat=320
        //let hight=self.pageScrollView.frame.height
        //设置scrollview 4个区域
        pageScrollView.contentSize = CGSize(width: 4*wight, height: 0)
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
            let imageView:UIImageView = UIImageView(frame: CGRect(x: imageX, y: 0, width: wight, height: 128))
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
    }
    
    //    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        let indexTravelDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("IndexTravelDetailViewController") as! IndexTravelDetailViewController
    //        self.navigationController?.pushViewController(indexTravelDetailViewController, animated: true)
    //    }
    
    
    
    func initData(){
        //开启网络请求hud
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.pleaseWait()
//        do {
//            let opt = try HTTP.GET(Constant.host+Constant.getUnionByUser)
//            
//            opt.start { response in
//                
//                if let err = response.error {
//                    //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.clearAllNotice()
//                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 2)
//                    }
//                }else{
//                    
//                    //关闭网络请求hud
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                    
//                    self.clearAllNotice()
//                    //把NSData对象转换回JSON对象
//                    let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(response.data, options:NSJSONReadingOptions.AllowFragments)
//                    if json == nil {
//                        self.alert("网络异常，请重试")
//                        self.clearAllNotice()
//                    }else{
//                        
//                        
//                        let data : NSArray = json.objectForKey("data") as! NSArray
//                        
//                        //let mobile : AnyObject = json.objectForKey("mobile")!
//                        if data.count != 0{
//                            
//                            //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
//                            dispatch_async(dispatch_get_main_queue()) {
//                                self.tableViewData = data
//                                self.tableView.reloadData()
//                            }
//                        }else{
//                            
//                            dispatch_async(dispatch_get_main_queue()) {
//                                self.noticeInfo("没有数据", autoClear: true, autoClearTime: 1)
//                            }
//                        }
//                        
//                    }
//                    
//                }
//                
//            }
//            
//        } catch {
//            print("loginVaidate interface got an error creating the request: \(error)")
//        }
    }
    
    func getData(){
        
        //开启网络请求hud
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //self.pleaseWait()
 //       do {
//            let opt = try HTTP.GET(Constant.host+Constant.getUnionByUser)
//            
//            opt.start { response in
//                
//                if let err = response.error {
//                    //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.clearAllNotice()
//                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                        self.noticeInfo(err.localizedDescription, autoClear: true, autoClearTime: 2)
//                    }
//                }else{
//                    
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
//                        //let mobile : AnyObject = json.objectForKey("mobile")!
//                        if data.count != 0{
//                            //                                //＊＊＊＊＊＊从主线程中执行＊＊＊＊＊＊＊＊＊
//                            dispatch_async(dispatch_get_main_queue()) {
//                                self.tableViewData! = data
//                                self.refreshControl?.endRefreshing()
//                                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
//                                self.tableView.reloadData()
//                            }
//                            
//                            
//                            //self.clearAllNotice()
//                        }else{
//                            
//                            dispatch_async(dispatch_get_main_queue()) {
//                                self.noticeInfo("没有数据", autoClear: true, autoClearTime: 1)
//                            }
//                            
//                        }
//                        
//                        
//                        
//                        
//                    }
//                    
//                }
//                
//            }
//            
//        } catch {
//            print("loginValidate interface got an error creating the request: \(error)")
//        }
        
        
    }
    
    
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的是第几页
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //设置pageController的当前页
        pageControl.currentPage = page
    }
    
    func refreshTableView(){
        
        if(self.refreshControl?.isRefreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            getData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("页面即将出现")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        progressShow?.stopAnimating()
        progressShow?.hidesWhenStopped = true
        
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        progressShow?.startAnimating()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableViewData == nil{
            return 0
            
        }else{
            return tableViewData!.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:CustomCell! = tableView.dequeueReusableCell(withIdentifier: "RentInfoCell", for: indexPath) as? CustomCell
        if(cell == nil){
            cell = CustomCell(style: UITableViewCellStyle.default, reuseIdentifier: "RentInfoCell")
        }else{
            
            let unionTheme = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "unionTheme") as! String
            let unionId = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "unionId") as! String
            let outTime = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "outTime") as! String
            let publishTime = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "publishTime") as! String
            let mobile = (tableViewData!.object(at: indexPath.row) as AnyObject).value(forKey: "userId") as! String

            //解决Optional("***")问题
            cell.unionTheme.text = unionTheme
            cell.outTime.text=outTime
            cell.unionId.text=unionId
            
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let cell:CustomCell = tableView.cellForRow(at: indexPath) as! CustomCell
        let unionId = cell.unionId.text
        
        userInfo.set(unionId, forKey: "unionId")
        userInfo.synchronize()
        
        let indexTravelDetailViewController = storyBoard.instantiateViewController(withIdentifier: "IndexTravelDetailViewController") as! IndexTravelDetailViewController
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
    
    
    @IBAction func acitonSheet(_ sender: AnyObject) {
        //UIAlertController默认不传参数就是actionSheet操作表控件
        let actionSheet = UIAlertController()
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (alertAciton) -> Void in
            //print("取消")
            })
        actionSheet.addAction(UIAlertAction(title: "腾讯QQ", style: UIAlertActionStyle.destructive) { (alertAciton) -> Void in
            //print("腾讯QQ")
            })
        actionSheet.addAction(UIAlertAction(title: "新浪微博", style: UIAlertActionStyle.default) { (alertAciton) -> Void in
            //print("新浪微博")
            })
        actionSheet.addAction(UIAlertAction(title: "微信", style: UIAlertActionStyle.default) { (alertAciton) -> Void in
            //print("微信")
            })
        
        actionSheet.addAction(UIAlertAction(title: "朋友圈", style: UIAlertActionStyle.default) { (alertAciton) -> Void in
            //print("朋友圈")
            })
        
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
}



    
