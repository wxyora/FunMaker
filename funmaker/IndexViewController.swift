import UIKit
import SwiftHTTP

class IndexViewController: BaseViewController,UISearchBarDelegate{
    
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var togetherImage: UIImageView!
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var progressShow: UIActivityIndicatorView?
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageScrollView: UIScrollView!
    
    var tableViewData:AnyObject?
    

    
    @IBAction func hotelImageOnclick(sender: AnyObject) {
        
        self.noticeInfo("敬请期待...", autoClear: true, autoClearTime: 1)
    }
    
   // @IBOutlet var searchBar: UISearchBar!
    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        self.searchBar.resignFirstResponder()
//    }
 
    override func viewDidLoad() {
        
        
        
        self.navigationController!.navigationBar.tintColor=UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.whiteColor()]

 

        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()
        

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
        
//        let rc = UIRefreshControl()
//        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
//        rc.addTarget(self, action: #selector(IndexViewController.refreshTableView), forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshControl = rc
//        

        
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
        
    
        
        //initData()
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let indexTravelDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("IndexTravelDetailViewController") as! IndexTravelDetailViewController
//        self.navigationController?.pushViewController(indexTravelDetailViewController, animated: true)
//    }
    
    
    
    
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
           // getData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //print("页面即将出现")
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
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        if tableViewData == nil{
//            return 0
//            
//        }else{
//            return tableViewData!.count
//        }
//        
//    }
    
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        var cell:CustomCell! = tableView.dequeueReusableCellWithIdentifier("RentInfoCell", forIndexPath: indexPath) as? CustomCell
//        if(cell == nil){
//            cell = CustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "RentInfoCell")
//        }else{
//            
//            let unionTheme:String = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("unionTheme")!)
//            let outTime = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("outTime")!)
//            let unionId = String(tableViewData!.objectAtIndex(indexPath.row).objectForKey("unionId")!)
//            //解决Optional("***")问题
//            cell.unionTheme.text = unionTheme
//            cell.outTime.text=outTime
//            cell.unionId.text=unionId
//            
//        }
//        
//        return cell
//    }
//    
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        
//        
//        var cell:CustomCell = tableView.cellForRowAtIndexPath(indexPath) as! CustomCell
//        let unionId = cell.unionId.text
//        
//        userInfo.setObject(unionId, forKey: "unionId")
//        userInfo.synchronize()
//        
//        let indexTravelDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("IndexTravelDetailViewController") as! IndexTravelDetailViewController
//               self.navigationController?.pushViewController(indexTravelDetailViewController, animated: true)
//        
//    }
    

    
    
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
            //print("取消")
            })
        actionSheet.addAction(UIAlertAction(title: "腾讯QQ", style: UIAlertActionStyle.Destructive) { (alertAciton) -> Void in
            //print("腾讯QQ")
            })
        actionSheet.addAction(UIAlertAction(title: "新浪微博", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
            //print("新浪微博")
            })
        actionSheet.addAction(UIAlertAction(title: "微信", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
            //print("微信")
            })
        
        actionSheet.addAction(UIAlertAction(title: "朋友圈", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
            //print("朋友圈")
            })
        
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
}

