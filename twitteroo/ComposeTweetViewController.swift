//
//  ComposeTweetViewController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/26/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var user: User?
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userImage.layer.cornerRadius = 3
        tweetButton.layer.cornerRadius = 3
        tweetTextView.layer.borderColor = UIColor.grayColor().CGColor
        tweetTextView.layer.borderWidth = 1.0
        
        userImage.setImageWithURL(NSURL(string: user!.profileImageUrl!))
        nameLabel.text = user?.name
        screenNameLabel.text = "@" + user!.screenname!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetButtonClicked(sender: AnyObject) {
        println("Tweet button clicked")
        if tweetTextView.text == "" {
            return
        }
        
        TwitterClient.sharedInstance.postTweet(tweetTextView.text)
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onExitButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
