//
//  SpringFromBottomAnimation.swift
//  PresentrExample
//
//  Created by Francesco Perrotti-Garcia on 12/26/16.
//  Copyright © 2016 Presentr. All rights reserved.
//

import UIKit
import Presentr

class SpringFromBottomAnimation: NSObject, PresentrAnimation {
    
    var animationDuration: TimeInterval
    
    fileprivate var springDamping: CGFloat
    fileprivate var initialSpringVelocity: CGFloat
    
    init(animationDuration: TimeInterval = 0.5,
         springDamping: CGFloat = 0.5,
         initialSpringVelocity: CGFloat = 0) {
        self.animationDuration = animationDuration
        self.springDamping = springDamping
        self.initialSpringVelocity = initialSpringVelocity
    }
    
    func animate(_ transitionContext: UIViewControllerContextTransitioning, transform: FrameTransformer) {
        let containerView = transitionContext.containerView
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        let isPresenting: Bool = (toViewController?.presentingViewController == fromViewController)
        
        let animatingVC = isPresenting ? toViewController : fromViewController
        let animatingView = isPresenting ? toView : fromView
        
        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
        let initialFrameForVC = transform(finalFrameForVC, containerView.frame)
        
        let initialFrame = isPresenting ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresenting ? finalFrameForVC : initialFrameForVC
        
        let duration = transitionDuration(using: transitionContext)
        
        if isPresenting {
            containerView.addSubview(toView!)
        }
        
        animatingView?.frame = initialFrame
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: initialSpringVelocity, options: .allowUserInteraction, animations: {
            
            animatingView?.frame = finalFrame
            
        }, completion: { (value: Bool) in
            
            if !isPresenting {
                fromView?.removeFromSuperview()
            }
            
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
            
        })
    }
}

// MARK: UIViewControllerAnimatedTransitioning

extension SpringFromBottomAnimation: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animate(transitionContext) { finalFrame, containerFrame in
            var initialFrame = finalFrame
            initialFrame.origin.y = containerFrame.size.height + initialFrame.size.height
            return initialFrame
        }
    }
    
}

