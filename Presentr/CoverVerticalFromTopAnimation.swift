//
//  CoverVerticalFromTopAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/14/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

class CoverVerticalFromTopAnimation: NSObject, PresentrAnimation{
    var isPresenting = false
}

// MARK: UIViewControllerAnimatedTransitioning

extension CoverVerticalFromTopAnimation: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromView = fromVC?.view
        let toView = toVC?.view
        let containerView = transitionContext.containerView()
        
        if isPresenting {
            containerView!.addSubview(toView!)
        }
        
        let animatingVC = isPresenting ? toVC : fromVC
        let animatingView = animatingVC?.view
        
        let finalFrameForVC = transitionContext.finalFrameForViewController(animatingVC!)
        var initialFrameForVC = finalFrameForVC
        initialFrameForVC.origin.x += initialFrameForVC.size.width
        
        let initialFrame = isPresenting ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresenting ? finalFrameForVC : initialFrameForVC
        
        animatingView?.frame = initialFrame
        animatingView?.alpha = 0.0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay:0, usingSpringWithDamping:300.0, initialSpringVelocity:5.0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            
            animatingView?.frame = finalFrame
            animatingView?.alpha = 1.0
            
            }, completion: { (value: Bool) in
                
                if !self.isPresenting {
                    fromView?.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
                
        })
    }
    
}