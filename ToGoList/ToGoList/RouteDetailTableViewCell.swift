//
//  RouteDetailTableViewCell.swift
//  ToGoList
//
//  Created by mac on 2016/6/16.
//  Copyright © 2016年 group7. All rights reserved.
//

import UIKit

class RouteDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var routeLocationListLabel: UILabel!
    
    @IBOutlet weak var routeLocationListAddressLabel: UILabel!
    
    @IBOutlet weak var routeLocationListPhoneLabel: UILabel!
    
    
    @IBOutlet weak var routeLocationTypeImage: UIImageView!
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
