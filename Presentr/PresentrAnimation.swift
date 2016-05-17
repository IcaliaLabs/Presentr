//
//  PresentrAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/14/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

protocol PresentrAnimation: UIViewControllerAnimatedTransitioning{

    var animationDuration: NSTimeInterval { get set }

    func animate(transitionContext: UIViewControllerContextTransitioning, transform: frameTransformer)
    
}

typealias frameTransformer = (finalFrame: CGRect, containerFrame: CGRect) -> CGRect

extension PresentrAnimation{
    
    func animate(transitionContext: UIViewControllerContextTransitioning, transform: frameTransformer){
        
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        let isPresenting: Bool = (toViewController?.presentingViewController == fromViewController)
        
        let animatingVC = isPresenting ? toViewController : fromViewController
        let animatingView = isPresenting ? toView : fromView
        
        let finalFrameForVC = transitionContext.finalFrameForViewController(animatingVC!)
        let initialFrameForVC = transform(finalFrame: finalFrameForVC, containerFrame: containerView.frame)
        
        let initialFrame = isPresenting ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresenting ? finalFrameForVC : initialFrameForVC
        
        let duration = transitionDuration(transitionContext)
        
        if isPresenting {
            containerView.addSubview(toView!)
        }
        
        animatingView?.frame = initialFrame
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 300.0, initialSpringVelocity: 5.0, options: .AllowUserInteraction, animations: {
            
            animatingView?.frame = finalFrame
            
            }, completion: { (value: Bool) in
                
                if !isPresenting {
                    fromView?.removeFromSuperview()
                }
                
                let wasCancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!wasCancelled)
                
        })
    }
    
}

