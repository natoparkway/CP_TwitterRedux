//
//  TwitterClient.swift
//  twitteroo
//
//  Created by Sherman Leung on 4/22/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

let twitterConsumerSecret = "00jdc9qX1VewAaCJLiBlZ5HIBWBz2wflpJBd4lCEaRmzknFtUV"
let twitterConsumerKey = "AmbzkEvYGXB7ygunBkhkUnhHA"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
  
    class var sharedInstance: TwitterClient {
        struct Static {
          static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
          
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch Request Token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()  //Clean things up before starting
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            println("Got request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            
            }) { (error: NSError!) -> Void in
                
                println("Failure to get request token")
                self.loginCompletion?(user: nil, error: error)
            }
    
    }
    
    //GET Home Timeline
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //print("Home Timeline: \(response)")
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error")
                completion(tweets: nil, error: error)
            })

    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
                println("Got Access Token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                //GET Credentials
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    var user = User(dictionary: response as! NSDictionary)
                    User.currentUser = user //Persists user as current user
                    
                    println("Got User: \(user.name)")
                    
                    self.loginCompletion?(user: user, error: nil)
                    
                    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("error in getting current user")
                        self.loginCompletion?(user: nil, error: error)
                       
                })
                
            
            }) { (error: NSError!) -> Void in
                println("Failed to get Access Token")
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
    func retweet(id: Int) -> Int? {
        var retweetID: Int?
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("Retweeting Successful")
                retweetID = id
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error in retweeting tweet")
                
                
        })
        
        return retweetID
        
    }
    
    func unfavoriteTweet(tweet: Tweet) {
        var params = NSMutableDictionary()
        params["id"] = tweet.id!
        
        TwitterClient.sharedInstance.POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("Unfavoriting Successful")
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error in unfavoriting tweet")
                
        })
    }
    
    func favoriteTweet(tweet: Tweet) {
        var params = NSMutableDictionary()
        params["id"] = tweet.id!
        
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("favoriting Successful")
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error in favoriting tweet")
                
        })
    }
    
    func postTweet(tweetText: String) {
        var params = NSMutableDictionary()
        params["status"] = tweetText
        
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("Tweeting Successful")
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error in posting tweet")
                
        })

    }
    
    
  
}
