//
//  PublishViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class PublishViewController: UITableViewController {

    @IBOutlet weak var publicDetailInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(PublishViewController.refreshTableView), forControlEvents: UIControlEvents.ValueChanged)
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
            //            refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
            //            self.tableView.reloadData()
            
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        //不能对为空的optional进行解包,否则会报运行时错误.所以在对optional进行解包之前进行判断是否为空.
        // var cell:CustomCell! = tableView.dequeueReusableCellWithIdentifier("RentInfoCell", forIndexPath: indexPath) as? CustomCell
        var cell:CustomCell! = tableView.dequeueReusableCellWithIdentifier("PublicInfoCell", forIndexPath: indexPath) as? CustomCell
        if(cell == nil){
            cell = CustomCell(style: UITableViewCellStyle.Default, reuseIdentifier:"PublicInfoCell")
        }else{
            //publicDetailInfo.text = "安静，舒适，交通方便，距离景点很近"
          
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            //cell.rentInfoImage.image = UIImage(contentsOfFile:"首页tab")
        }
        
        
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        
        return cell
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
