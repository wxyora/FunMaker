//
//  CustomCell.swift
//  funmaker
//
//  Created by Waylon on 16/7/18.
//  Copyright © 2016年 Waylon. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var unionId: UILabel!
    
    @IBOutlet weak var rentInfoImage: UIImageView!

    @IBOutlet weak var unionTheme: UILabel!
    
    @IBOutlet weak var outTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rentInfoImage.layer.borderWidth=1
        rentInfoImage.layer.cornerRadius=3
        rentInfoImage.layer.borderColor = UIColor.grayColor().CGColor
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    

}
