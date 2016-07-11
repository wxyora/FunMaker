//
//  RecentOrderViewController.swift
//  funmaker
//
//  Created by Waylon on 16/7/11.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class RecentOrderViewController: UITableViewController{
    
    var str = ["订单1","订单2","订单3","订单4","订单5","订单3","订单6"]

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return str.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel?.text = str[indexPath.row]
        return cell
    }
    
    table
    
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
