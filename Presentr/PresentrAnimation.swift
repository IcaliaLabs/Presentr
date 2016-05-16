//
//  PresentrAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/14/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

protocol PresentrAnimation: UIViewControllerAnimatedTransitioning{

    var isPresenting: Bool { get set }
    var animationDuration: NSTimeInterval { get set }

    func animateSlideIn(transitionContext: UIViewControllerContextTransitioning, transform: frameTransformer)
    
}

typealias frameTransformer = (finalFrame: CGRect, containerFrame: CGRect) -> CGRect

extension PresentrAnimation{
    
    func animateSlideIn(transitionContext: UIViewControllerContextTransitioning, transform: frameTransformer){
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromView = fromVC?.view
        let toView = toVC?.view
        
        if isPresenting {
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresenting ? toVC : fromVC
        let animatingView = animatingVC?.view
        
        let finalFrameForVC = transitionContext.finalFrameForViewController(animatingVC!)
        let initialFrameForVC = transform(finalFrame: finalFrameForVC, containerFrame: containerView.frame)
        
        let initialFrame = isPresenting ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresenting ? finalFrameForVC : initialFrameForVC
        
        animatingView?.frame = initialFrame
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 300.0, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            
            animatingView?.frame = finalFrame
            
            }, completion: { (value: Bool) in
                
                if !self.isPresenting {
                    fromView?.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
                
        })
    }
    
}

