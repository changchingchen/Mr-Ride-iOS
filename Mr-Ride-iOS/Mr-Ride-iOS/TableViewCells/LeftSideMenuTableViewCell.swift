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
    
    @IBOutlet weak var leftSideMenuItemBackgroundView: UIView!
    
    struct Constant {
        static let Identifier = "LeftSideMenuTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftSideMenuItemLabel.textColor = UIColor.mrWhiteColor()
        leftSideMenuItemLabel.font = UIFont.mrTextStyleFontSFUITextMedium(24)
        
        leftSideMenuItemBackgroundView.backgroundColor = UIColor.mrDarkSlateBlueColor()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        leftSideMenuItemLabel.textColor = UIColor.mrWhiteColor()
    }
    
}
