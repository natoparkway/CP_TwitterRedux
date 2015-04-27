//
//  TweetCell.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/26/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

let minPerHour = 60.0
let secPerMin = 60.0
let hourPerDay = 24.0

class TweetCell: UITableViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var minutesSinceLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        self.tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
        
        self.thumbnailImage.layer.cornerRadius = 3
    }
    
    override func layoutSubviews() {
        self.nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        self.tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getTimeDiff(date: NSDate) -> String {
        var currentTime = NSDate()
        var diff = currentTime.timeIntervalSinceDate(date)
        
        if diff < secPerMin {
            return String(format: "%.0fs", diff)
        } else if diff < secPerMin * minPerHour {
            return String(format: "%.0fm", diff / secPerMin)
        } else if diff < secPerMin * minPerHour * hourPerDay {
            return String(format: "%.0fh", diff / (secPerMin * minPerHour))
        }
        
        return String(format: "%.0fd", diff / (secPerMin * minPerHour * hourPerDay))
    }
    
    func updateContents(tweet: Tweet) {
        var user = tweet.user!
        
        nameLabel.text = user.name
        println(nameLabel.text)
        
        var thumbnailURL = NSURL(string: user.profileImageUrl!)
        thumbnailImage.setImageWithURL(thumbnailURL)
        
        twitterHandleLabel.text = "@" + tweet.screenName!
        
        minutesSinceLabel.text = getTimeDiff(tweet.createdAt!)
        
        tweetTextLabel.text = tweet.text
        
        
        
        
    }

}
