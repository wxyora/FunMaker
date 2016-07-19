import UIKit

class IndexViewController: UITableViewController,UISearchBarDelegate{
    
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var progressShow: UIActivityIndicatorView?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
     var str = ["精装修别墅","豪华洋房","三亚海景房","重庆江景房"]
   // @IBOutlet var searchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
 
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
        
        self.searchBar.delegate = self
        
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(IndexViewController.refreshTableView), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        
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

