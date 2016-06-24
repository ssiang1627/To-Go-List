//
//  AddPinToRouteTableViewCell.swift
//  ToGoList
//
//  Created by mac on 2016/6/16.
//  Copyright © 2016年 group7. All rights reserved.
//

import UIKit

class AddPinToRouteTableViewCell: UITableViewCell {

    
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationAddressLabel: UILabel!
    @IBOutlet var locationTypeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
