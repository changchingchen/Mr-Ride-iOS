//
//  ResultTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/25/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    struct Constant {
        static let Identifier = "ResultTableViewCell"
    }
    
    var record: Record? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func initView() {
        self.backgroundColor = UIColor.clearColor()
        
        self.dateLabel.textColor = UIColor.whiteColor()
        self.dateLabel.font = UIFont.mrTextStyleFontRobotoMonoLight(24.0)
        
        self.distanceLabel.textColor = UIColor.whiteColor()
        self.distanceLabel.font = UIFont.mrTextStyleFontRobotoMonoLight(24.0)
        
        self.durationLabel.textColor = UIColor.whiteColor()
        self.durationLabel.font = UIFont.mrTextStyleFontRobotoMonoLight(24.0)
        
        
    }
    
    private func updateUI() {
        if let record = self.record {
            
            let date = record.date
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Year, .Month, .Day], fromDate: date)
            let day = components.day
            var daySuffix = ""
            switch day {
            case 1, 21, 31: daySuffix = "st"
            case 2, 22: daySuffix = "nd"
            case 3, 23: daySuffix = "rd"
            default: daySuffix = "th"
            }
            let dayAttributedString = NSMutableAttributedString(string: "\(day)", attributes: [NSFontAttributeName: UIFont.mrTextStyleFontRobotoMonoLight(24.0)!])
            let daySuffixAttributedString = NSMutableAttributedString(string: "\(daySuffix)", attributes: [NSFontAttributeName: UIFont.mrTextStyleFontRobotoMonoLight(12.0)!])
            dayAttributedString.appendAttributedString(daySuffixAttributedString)
            
            dateLabel.attributedText = dayAttributedString

            distanceLabel.text = String(format: "%.2f km", record.distance / 1000)
            
            var duration = record.duration
            let hour = UInt8(duration / 3600.0)
            duration %= 3600
            let minute = UInt8(duration / 60.0)
            duration %= 60
            let second = UInt8(duration)
            durationLabel.text = String(format: "%02d:%02d:%02d", hour, minute, second)
            
        }
    }
    
}
