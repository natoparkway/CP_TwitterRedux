//
//  ProfilePageViewController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/30/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]! = [Tweet]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberFollowersLabel: UILabel!
    @IBOutlet weak var numberFollowingLabel: UILabel!
    @IBOutlet weak var numberTweetsLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        addGestureRecognizer()
        updateView()


        // Do any additional setup after loading the view.
    }
    
    
    func addGestureRecognizer() {
        let panGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "screenPanned:")
        panGestureRecognizer.edges = .Left
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func screenPanned(sender: UIScreenEdgePanGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
        
        
        
    }
    
    func updateView() {
        getUserTweets()
        updateProfilePhoto()
        numberFollowersLabel.text = String(user.numFollowers)
        numberFollowingLabel.text = String(user.numFollowing)
        numberTweetsLabel.text = String(user.numTweets)
        nameLabel.text = user.name
        screenNameLabel.text = "@" + user.screenname!
    }
    
    func getUserTweets() {
        var queue = NSOperationQueue()
        var operation = NSBlockOperation { ()
            self.tweets = TwitterClient.sharedInstance.getUserTweets(self.user.screenname!)
            self.tableView.reloadData()
        }
        
        queue.addOperation(operation)
    }
    
    func updateProfilePhoto() {
        var queue = NSOperationQueue()
        var operation = NSBlockOperation { ()
            var data = NSData(contentsOfURL: NSURL(string: self.user.profileImageUrl!)!)
            
            NSOperationQueue.mainQueue().addOperationWithBlock { ()
                self.profileImage.image = UIImage(data: data!)
                
            }
        }
        queue.addOperation(operation)
    }
    
    //UINAVIGATION CONTROLLER DELEGATE METHODS
//    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        println("here")
//        return DummyAnimationController()
//    }
//    
//    
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        println("asdf")
//        return DummyAnimationController()
//    }
    
    //TABLE VIEW METHODS
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
