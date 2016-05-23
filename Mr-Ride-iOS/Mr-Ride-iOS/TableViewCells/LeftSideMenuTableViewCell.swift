//
//  LeftSideMenuTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/23/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class LeftSideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var leftSideMenuItemLabel: UILabel!
    
    struct Constant {
        static let identifier = "LeftSideMenuTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftSideMenuItemLabel.textColor = UIColor.mrBlack25Color()
        leftSideMenuItemLabel.font = UIFont.mrTextStyleFontSFUITextMedium(24)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}