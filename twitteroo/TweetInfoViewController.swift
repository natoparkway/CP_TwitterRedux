//
//  TweetInfoViewController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/26/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class TweetInfoViewController: UIViewController {


    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoritedButton: UIButton!
    @IBOutlet weak var tweetDateLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    //Properties
    var retweeted = false
    var favorited = false
    var tweet: Tweet?
    var tweeter: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailImage.layer.cornerRadius = 3

        tweeter = tweet!.user
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        tweetText.preferredMaxLayoutWidth = tweetText.frame.size.width
        populateElements()
    }


    @IBAction func replyButtonPressed(sender: AnyObject) {
    
    
    
    }
    
    
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        if !retweeted {
            retweetButton.setImage(UIImage(named: "retweet_icon_on"), forState: .Normal)
            TwitterClient.sharedInstance.retweet(tweet!.id!)
            retweeted = true
        } else {
            retweetButton.setImage(UIImage(named: "retweet_icon_off"), forState: .Normal)
            retweeted = false
        }
        
    
    }
    
    
    @IBAction func favoritedButtonPressed(sender: AnyObject) {
        println("favorited button pressed")
        if !favorited {
            favoritedButton.setImage(UIImage(named: "favorite_icon_on"), forState: .Normal)
            TwitterClient.sharedInstance.favoriteTweet(tweet!)
            favorited = true
        } else {
            favoritedButton.setImage(UIImage(named: "favorite_icon_off"), forState: .Normal)
            TwitterClient.sharedInstance.unfavoriteTweet(tweet!)
            favorited = false
        }
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateElements() {
        nameLabel.text = tweeter!.name
        screenNameLabel.text = "@" + tweeter!.screenname!
        
        thumbnailImage.image = tweeter!.profileImage
        
        tweetDateLabel.text = tweet!.createdAtString!
        tweetText.text = tweet!.text
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            if id == "ComposeTweet" {
                var ComposeTweetVC = segue.destinationViewController as! ComposeTweetViewController
                ComposeTweetVC.user = User.currentUser
                ComposeTweetVC.replyScreenname = tweet!.screenName
            }
        } else {
            // do something
        }
    }

}
