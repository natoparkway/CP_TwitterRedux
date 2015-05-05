//
//  SlideContainerViewController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 5/3/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

let distanceFromSide = CGFloat(40.0)
var currentState: SlideOutState = .BothCollapsed
enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class SlideContainerViewController: UIViewController {
    var currentState: SlideOutState = .BothCollapsed
    var centerNavController: UINavigationController!
    var centerViewController: TweetsViewController!
    var leftPanelExpanded = false
    var leftViewController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        centerNavController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("TweetsNavController") as! UINavigationController
        
        //This is definitely not the way to go.
        centerNavController.addChildViewController(centerViewController)
        
        view.addSubview(centerNavController.view)
        addChildViewController(centerNavController)
        
        centerNavController.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension SlideContainerViewController: CenterViewControllerDelegate {
    
    func handlePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let correctDirection = sender.velocityInView(view).x > 0

        
        if sender.state == UIGestureRecognizerState.Began {
            addLeftPanelViewController()
        } else if sender.state == UIGestureRecognizerState.Changed {
            self.centerNavController.view.center.x = self.centerNavController.view.center.x + sender.translationInView(view).x
            sender.setTranslation(CGPointZero, inView: view)
        } else if sender.state == UIGestureRecognizerState.Ended {
            if correctDirection {
                animateLeftPanel()
            }
        }

    }
    
    func addLeftPanelViewController() {
        if leftViewController == nil {
            leftViewController = UIStoryboard.leftViewController()
            var hamburgerMenu = leftViewController.topViewController as! HamburgerViewController
            hamburgerMenu.user = User.currentUser
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: UINavigationController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func addTapControllerToNav(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "animateLeftPanel")
        centerNavController.view.addGestureRecognizer(tapRecognizer)
    }
    
    func animateLeftPanel() {
        println("registered")
        println(leftPanelExpanded)
        var vcWidth = CGRectGetWidth(self.centerViewController.view.frame)
        var moveDistance = vcWidth - distanceFromSide + vcWidth / 2
        if !leftPanelExpanded {
            leftPanelExpanded = true
            UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
                
                self.centerNavController.view.center.x = moveDistance
                
                }, completion: { (finished) -> Void in
                    println("Done")
                    self.addTapControllerToNav()
                    
                    
            })
        } else {
            leftPanelExpanded = false
            UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
                
                self.centerNavController.view.center.x = vcWidth / 2
                
                }, completion: { (finished) -> Void in
                    println("Done")
                    
                    
            })
        }
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> UINavigationController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("HamburgerNavController") as! UINavigationController
    }
    
    class func centerViewController() -> TweetsViewController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController
    }
    
}
