//
//  DummyAnimationController.swift
//  twitteroo
//
//  Created by Nathaniel Okun on 5/2/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class DummyAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.35
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("Animating Transition")
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
}
