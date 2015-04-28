//
//  ComposeTweetViewController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/26/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit
let maxCharacterCount = 140

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var charactersLeftLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var user: User?
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    var replyScreenname: String?
    var overCharLimit = false
    
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
        tweetTextView.delegate = self
        
        //If it's a reply to someone, start with their screenname
        if let initText = replyScreenname {
            tweetTextView.text = "@" + initText + " "
            var charCount = count(tweetTextView.text)
            charactersLeftLabel.text = String(maxCharacterCount - charCount)
        }
        
        tweetTextView.becomeFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        var charCount = count(textView.text)
        charactersLeftLabel.text = String(maxCharacterCount - charCount)
        
        overCharLimit = charCount > maxCharacterCount
        
        //Deal with color
        if charCount == maxCharacterCount + 1 {
            tweetButton.backgroundColor = UIColor.grayColor()
            tweetButton.adjustsImageWhenHighlighted = false
        } else if charCount == maxCharacterCount {
            tweetButton.backgroundColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1.0)
            tweetButton.adjustsImageWhenHighlighted = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetButtonClicked(sender: AnyObject) {
        println("Tweet button clicked")
        if tweetTextView.text == "" || overCharLimit {
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
