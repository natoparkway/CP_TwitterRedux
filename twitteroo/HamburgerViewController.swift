//
//  HamburgerViewController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 4/30/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class HamburgerViewController: UITableViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        profilePictureImage.image = user!.profileImage
        descriptionLabel.text = user!.userDescription
        self.descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
        nameLabel.text = user!.name
        
        
        // Do any additional setup after loading the view.
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
        if let identifier = segue.identifier {
            if identifier == "toProfilePage" {
                var profilePageNav = segue.destinationViewController as! UINavigationController
                var profilePageVC = profilePageNav.topViewController as! ProfilePageViewController
                profilePageVC.user = self.user
            }
        }
    }
    

}
