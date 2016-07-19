import UIKit

class IndexViewController: UITableViewController,UISearchBarDelegate{
    
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var progressShow: UIActivityIndicatorView?
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageScrollView: UIScrollView!
    
  
    
    @IBOutlet weak var searchBar: UISearchBar!
    
     var str = ["精装修别墅","豪华洋房","三亚海景房","重庆江景房","精装修别墅","豪华洋房","三亚海景房","重庆江景房"]
   // @IBOutlet var searchBar: UISearchBar!
    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        self.searchBar.resignFirstResponder()
//    }
 
    override func viewDidLoad() {
        
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
        let wight:CGFloat=320
        let hight=self.pageScrollView.frame.height
        //设置scrollview 4个区域
        pageScrollView.contentSize = CGSize(width: 4*wight, height: hight)
        //set scrollview delegete
        pageScrollView.delegate=self
        
        let totalCount = 4
        
     
        
        for index in 0..<totalCount{
            //let imageView:UIImageView = UIImageView();
            let imageX:CGFloat = CGFloat(index) * wight;
            let imageView:UIImageView = UIImageView(frame: CGRectMake(imageX, 0, 320, 128))
            //let imageX:CGFloat = CGFloat(index) * wight;
            //imageView.frame = CGRectMake(imageX, hight, wight, hight);//设置图片的大小，注意Image和ScrollView的关系，其实几张图片是按顺序从左向右依次放置在ScrollView中的，但是ScrollView在界面中显示的只是一张图片的大小，效果类似与画廊；
            let name:String = String(format: "gallery%d.png", index);
            //imageView.image = UIImage(named:name);
            imageView.image = UIImage(named: name)
            self.pageScrollView.showsHorizontalScrollIndicator = false;//不设置水平滚动条；
            self.pageScrollView.addSubview(imageView)//把图片加入到ScrollView中去，实现轮播的效果；
            //self.pageScrollView.addSubview(imageView)
        }
        //通过坐标和大小来创建图像视图
//                var imageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 320, 128))
//                imageView.image = UIImage(named: "gallery1.png")
//                self.pageScrollView.addSubview(imageView)
        
    
    }
    

    func refreshTableView(){
        
            if(self.refreshControl?.refreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            
            
            
            //add data
            let time:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_MSEC * 1000))
            //延迟
            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                //self.myLabel.text = "请点击调用按钮"
                self.refreshControl?.endRefreshing()
                
                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                
                self.tableView.reloadData()
            }
            
            
//            refreshControl?.endRefreshing()
//            
//            refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
//            
//            self.tableView.reloadData()
            
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return str.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

      

        //不能对为空的optional进行解包,否则会报运行时错误.所以在对optional进行解包之前进行判断是否为空.
       // var cell:CustomCell! = tableView.dequeueReusableCellWithIdentifier("RentInfoCell", forIndexPath: indexPath) as? CustomCell
        var cell:CustomCell! = tableView.dequeueReusableCellWithIdentifier("RentInfoCell", forIndexPath: indexPath) as? CustomCell
        if(cell == nil){
            cell = CustomCell(style: UITableViewCellStyle.Default, reuseIdentifier:"RentInfoCell")
        }else{
            cell.rentDetailInfo.text = "安静，舒适，交通方便，距离景点很近"
            cell.rentInfoName.text = str[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            //cell.rentInfoImage.image = UIImage(contentsOfFile:"首页tab")
        }
        
        
         //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
       
        return cell
        
       
    
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

