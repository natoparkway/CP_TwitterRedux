//
//  TweetsViewController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/25/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]? = [Tweet]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        fetchTweets()
    }
    
    func fetchTweets() {
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None    //Prevents highlighting
        var tweet = tweets![indexPath.row]
        
        cell.updateContents(tweet)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = tweets!.count as Int? {
            println("Returning \(count)")
            return count
        }
        
        println("Returning 0")
        return 0
        
    }
    
//TweetCellDelegate Methods
    
    func replyButtonPressed(tweet: Tweet) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("ComposeTweetVC") as! ComposeTweetViewController
        vc.user = User.currentUser
        vc.replyScreenname = tweet.screenName
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func retweetButtonPressed(tweet: Tweet, alreadyRetweeted: Bool) {
        println("retweet delegate")
        if !alreadyRetweeted {
            TwitterClient.sharedInstance.retweet(tweet.id!)
        } else {
            //Unretweet
        }
    }
    
    func favoriteButtonPressed(tweet: Tweet, alreadyFavorited: Bool) {
        if !alreadyFavorited {
            TwitterClient.sharedInstance.favoriteTweet(tweet)
        } else {
            TwitterClient.sharedInstance.unfavoriteTweet(tweet)
        }
    }
    
    
//End of delegate methods
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        User.currentUser?.logout()
    
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let id = segue.identifier {
            if id == "ComposeTweetSegue" {
                var ComposeTweetVC = segue.destinationViewController as! ComposeTweetViewController
                ComposeTweetVC.user = User.currentUser
            }
            
            if id == "TweetInfo" {
                println("Tweet Info")
                println(User.currentUser!.name)
                var indexPath = tableView.indexPathForCell(sender as! TweetCell)!
                var nav = segue.destinationViewController as! UINavigationController
                var TweetInfoVC = nav.topViewController as! TweetInfoViewController
                TweetInfoVC.tweet = tweets![indexPath.row]
            }
            
        } else {
            // do something
        }

    }

}
