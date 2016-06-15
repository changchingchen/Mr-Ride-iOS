//
//  InfoView.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/14/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {

    struct Constant {
        static let Identifier = "HeaderView"
    }
    
    @IBOutlet weak var headerBackgroundView: UIView! { didSet {initHeaderBackgroundView()} }
    @IBOutlet weak var headerTitleLabel: UILabel! { didSet {initHeaderTitleLabel()} }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private func initHeaderBackgroundView() {
        headerBackgroundView.layer.cornerRadius = 2.0
    }
    
    private func initHeaderTitleLabel() {
        headerTitleLabel.font = UIFont.mrTextStyleFontSFUITextMedium(12.0)
        headerTitleLabel.textColor = UIColor.mrDarkSlateBlueColor()
        headerTitleLabel.textAlignment = .Center
    }

}
