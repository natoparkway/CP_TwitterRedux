//
//  ViewController.swift
//  twitteroo
//
//  Created by Sherman Leung on 4/21/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

    @IBAction func loginButtonClicked(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> () in
            if user != nil {
                //Perform Segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
                
            } else {
                //handle login error
            }
        }
        
        println("Login Button Clicked")
    }
}

