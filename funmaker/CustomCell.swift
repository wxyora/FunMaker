//
//  CustomCell.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var account: UILabel!
    
    @IBOutlet weak var unionId: UILabel!
    
    @IBOutlet weak var rentInfoImage: UIImageView!

    @IBOutlet weak var unionTheme: UILabel!
    
    @IBOutlet weak var outTime: UILabel!
 
    @IBOutlet weak var publishTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        //从文件读取用户头像
//        let fullPath = ((NSHomeDirectory() as NSString) .stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent("currentImage.png")
//        //可选绑定,若保存过用户头像则显示之
//        if let savedImage = UIImage(contentsOfFile: fullPath){
//            self.rentInfoImage.image = savedImage
//        }
        
        rentInfoImage.layer.borderWidth=1
        rentInfoImage.layer.cornerRadius=6
        rentInfoImage.layer.borderColor = UIColor.grayColor().CGColor
        

        
//        //设置头像圆角
//        headImage.layer.cornerRadius = headImage.frame.width/2
        //设置遮盖额外部分,下面两句的意义及实现是相同的
        //      headImage.clipsToBounds = true
        self.rentInfoImage.layer.masksToBounds = true
//        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    

}
