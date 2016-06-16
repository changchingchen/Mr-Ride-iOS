//
//  LeftSideMenuTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/23/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class LeftSideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var leftSideMenuItemLabel: UILabel! { didSet{ initLeftSideMenuItemLabel() } }
    
    @IBOutlet weak var leftSideMenuItemBackgroundView: UIView! { didSet { initLeftSideMenuItemBackgroundView() } }
    
    @IBOutlet weak var pointView: UIView! { didSet{ initPointView() } }
    
    struct Constant {
        static let Identifier = "LeftSideMenuTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            leftSideMenuItemLabel.textColor = UIColor.mrWhiteColor()
            pointView.hidden = false
        } else {
            leftSideMenuItemLabel.textColor = UIColor.mrWhite50Color()
            pointView.hidden = true
        }

    }
    
    private func initLeftSideMenuItemLabel() {
        leftSideMenuItemLabel.textColor = UIColor.mrWhite50Color()
        leftSideMenuItemLabel.layer.shadowColor = UIColor.mrBlack25Color().CGColor
        leftSideMenuItemLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        leftSideMenuItemLabel.layer.shadowRadius = 2.0
        leftSideMenuItemLabel.layer.shadowOpacity = 1.0
        leftSideMenuItemLabel.font = UIFont.mrTextStyleFontSFUITextMedium(24)
    }
    
    private func initLeftSideMenuItemBackgroundView() {
        leftSideMenuItemBackgroundView.backgroundColor = UIColor.mrDarkSlateBlueColor()
    }
    
    private func initPointView() {
        pointView.backgroundColor = UIColor.mrWhiteColor()
        pointView.layer.cornerRadius = pointView.bounds.size.width / 2
        pointView.layer.shadowColor = UIColor.mrBlack25Color().CGColor
        pointView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        pointView.layer.shadowRadius = 2.0
        pointView.layer.shadowOpacity = 1.0
    }
    
}
