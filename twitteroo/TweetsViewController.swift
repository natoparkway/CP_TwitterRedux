//
//  TweetsViewController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/25/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional func handlePanGesture(sender: UIScreenEdgePanGestureRecognizer)
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = [Tweet]()
    var refreshControl: UIRefreshControl!
    var hamburgerMenu: HamburgerViewController!
    var delegate: CenterViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Add pan gesture recognizer
        var edgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "showHamburgerView:")
        edgePanRecognizer.edges = .Left
        view.addGestureRecognizer(edgePanRecognizer)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        hamburgerMenu = storyboard.instantiateViewControllerWithIdentifier("hamburgerMenu") as! HamburgerViewController
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        fetchTweets()
    }
    
    func showHamburgerView(sender: UIScreenEdgePanGestureRecognizer) {
        delegate?.handlePanGesture!(sender)

    }
    
    func fetchTweets() {
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if let gotTweets = tweets {
                self.tweets = gotTweets
            }
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
        var tweet = tweets[indexPath.row]
        
        cell.updateContents(tweet)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = tweets.count as Int? {
            return count
        }

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
    
    func thumbnailImagePressed(tweet: Tweet) {
        performSegueWithIdentifier("profilePageSegue", sender: tweet.user)
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
                var indexPath = tableView.indexPathForCell(sender as! TweetCell)!
                var nav = segue.destinationViewController as! UINavigationController
                var TweetInfoVC = nav.topViewController as! TweetInfoViewController
                TweetInfoVC.tweet = tweets[indexPath.row]
            }
            
            if id == "profilePageSegue" {
                var nav = segue.destinationViewController as! UINavigationController
                var profilePageVC = nav.topViewController as! ProfilePageViewController
                profilePageVC.user = sender as! User
                
                
            }
            
        } else {
            // do something
        }

    }

}
