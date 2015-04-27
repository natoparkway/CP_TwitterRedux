//
//  Tweet.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/25/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favoritedCount: Int?
    var retweetCount: Int?
    var favorited = false
    var retweeted = false
    var screenName: String?
    
    
    init(dictionary: NSDictionary) {
        //println(dictionary)
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"    //Date formatting code
        createdAt = formatter.dateFromString(createdAtString!)
        
        favoritedCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as! Int == 0    //0 indicates not, 1 yes
        retweetCount = dictionary["retweet_count"] as? Int
        retweeted = dictionary["retweeted"] as! Int == 0
        screenName = (dictionary["user"] as! NSDictionary)["screen_name"] as? String
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
