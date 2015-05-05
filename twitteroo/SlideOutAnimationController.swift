//
//  SlideOutAnimationController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 5/2/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var usingGesture = false
    
    override init() {
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.35
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("this one called")
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        transitionContext.containerView().addSubview(toViewController.view)
        toViewController.view.alpha = 0.0
        UIView.animateWithDuration(0.35, animations: {
            toViewController.view.alpha = 1.0
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
//
//    func didPan(gesture: UIScreenEdgePanGestureRecognizer) {
//        let point = gesture.locationInView(transitioningController.view)
//        let percent = fmaxf(fminf(Float(point.x / 300.0), 0.99), 0.0)
//        switch (gesture.state){
//        case .Began:
//            self.usingGesture = true
//            self.transitioningController.navigationController?.popViewControllerAnimated(true)
//        case .Changed:
//            self.updateInteractiveTransition(CGFloat(percent))
//        case .Ended, .Cancelled:
//            if percent > 0.5 {
//                self.finishInteractiveTransition()
//            } else {
//                self.cancelInteractiveTransition()
//            }
//            self.usingGesture = false
//        default:
//            NSLog("Unhandled state")
//        }
//    }

}

