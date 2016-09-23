//
//  RecentOrderViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/11.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

import Alamofire


class RecentOrderViewController: BaseViewController,UISearchBarDelegate{

    var str = ["可以根据查询信息制定最佳出行方案"]

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.white]
        
        
        self.searchBar.delegate = self
        
        
        
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: #selector(IndexViewController.refreshTableView), for: UIControlEvents.valueChanged)
        self.refreshControl = rc

        // Do any additional setup after loading the view.
        
        //注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecentOrderViewController.handleTap(_:))))
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            //print("收回键盘")
            searchBar.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return str.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel?.text = str[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        
        
        
        let searchNo = self.searchBar.text
        
        
        
      
        
        
        
        
        
    }
    
    
    
    
        func refreshTableView(){
        
        if(self.refreshControl?.isRefreshing==true){
            self.refreshControl?.attributedTitle=NSAttributedString(string:"加载中")
            
            
            
            //add data
            let time:DispatchTime = DispatchTime.now() + Double((Int64)(NSEC_PER_MSEC * 1000)) / Double(NSEC_PER_SEC)
            //延迟
            DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
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

    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return str.count
//        
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
//        cell.textLabel?.text = "Row \(str[indexPath.row])))"
//        return cell
//    }
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
