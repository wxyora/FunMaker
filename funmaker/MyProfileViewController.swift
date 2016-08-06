//
//  MyProfileViewController.swift
//  funmaker
//
//  Created by Waylon on 16/8/6.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class MyProfileViewController:BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var mobile: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    //UIImageView监听 1 uiimageview上增加tap gesture recognizer 2 uiimageview 开启user interaction enabled 3 controller最上面gesture图标拖拽action
    
    @IBAction func changeHeadImage(sender: AnyObject) {
                    let actionSheet = UIAlertController(title: "请选择操作", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
                    actionSheet.addAction(UIAlertAction(title: "现场自拍", style: UIAlertActionStyle.Destructive) { (alertAciton) -> Void in
                        
                        //判断是否能进行拍照，可以的话打开相机
                        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                            let picker = UIImagePickerController()
                            picker.sourceType = .Camera
                            picker.delegate = self
                            picker.allowsEditing = true
                            self.presentViewController(picker, animated: true, completion: nil)
                            
                        }
                        else
                        {
                            print("模拟其中无法打开照相机,请在真机中使用");
                        }
                        
                        
                        })
                    actionSheet.addAction(UIAlertAction(title: "打开相册", style: UIAlertActionStyle.Default) { (alertAciton) -> Void in
                        //调用相册功能，打开相册
                        let picker = UIImagePickerController()
                        picker.sourceType = .PhotoLibrary
                        picker.delegate = self
                        picker.allowsEditing = true
                        self.presentViewController(picker, animated: true, completion: nil)
                        })
        
                    actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAciton) -> Void in
                            print("取消")
                        })

                    self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobile.text=getMobie()
        //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
        tableView.tableFooterView = UIView()

        
        //设置头像圆角
        headImage.layer.cornerRadius = headImage.frame.width/2
        //设置遮盖额外部分,下面两句的意义及实现是相同的
//      headImage.clipsToBounds = true
        headImage.layer.masksToBounds = true
        
        //从文件读取用户头像
        let fullPath = ((NSHomeDirectory() as NSString) .stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent("currentImage.png")
        //可选绑定,若保存过用户头像则显示之
        if let savedImage = UIImage(contentsOfFile: fullPath){
            self.headImage.image = savedImage
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //MARK: - 保存图片至沙盒
    func saveImage(currentImage:UIImage,imageName:String){
        var imageData = NSData()
        imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageName)
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
    }
    
    //UIImagePicker回调方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //获取照片的原图
        //let image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage)
        //获得编辑后的图片
       let image = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage)
        //保存图片至沙盒
       self.saveImage(image as! UIImage, imageName: "currentImage.png")
       let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent("currentImage.png")
        //存储后拿出更新头像
        let savedImage = UIImage(contentsOfFile: fullPath)
        self.headImage.image=savedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
