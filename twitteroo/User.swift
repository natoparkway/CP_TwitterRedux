//
//  User.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/25/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

var _currentUser: User? //Global variable
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var profileImage: UIImage! = UIImage()
    var tagline: String?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["tagline"] as? String
        
//        var data = NSData(contentsOfURL: NSURL(string: profileImageUrl!)!)
//        
//        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
//            self.profileImage = UIImage(data: data!)
//        }
    }
    
    func logout() {
        User.currentUser = nil  //This is dealt with in the setter for currentUser
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()  //Remove all permissions
        
        //Tell any code that's listening that we just logged out
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    //Class Property
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                //Check NSUser defaults
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        
                //Set the current user with the one stored in NSUserDefaults
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
        
            } else {
        
            }
            return _currentUser //Return the user who has just been set
        }
        
        set(user) {
            _currentUser = user
            
            //Save in persistent storage using NSUserDefaults
            if _currentUser != nil {
                //Try to store it
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                
            } else {
                //Since the user passed in nil, we want to clear out the user data
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            
            NSUserDefaults.standardUserDefaults().synchronize() //write to disk
        }
    }
}
