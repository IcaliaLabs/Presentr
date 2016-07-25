//
//  PresentrAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/14/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/**
 *  Protocol that represents a custom PresentrAnimation. Conforms to 'UIViewControllerAnimatedTransitioning'
 */
protocol PresentrAnimation: UIViewControllerAnimatedTransitioning {

    /// The duration for the animation. Must be set by the class that implements protocol.
    var animationDuration: NSTimeInterval { get set }

    /**
     This method has a default implementation by the 'PresentrAnimation' extension. It handles animating the view controller.

     - parameter transitionContext: Receives the transition context from the class implementing the protocol
     - parameter transform:         Transform block used to obtain the initial frame for the animation, given the finalFrame and the container's frame.

     */
    func animate(transitionContext: UIViewControllerContextTransitioning, transform: FrameTransformer)

}

/// Transform block used to obtain the initial frame for the animation, given the finalFrame and the container's frame.
typealias FrameTransformer = (finalFrame: CGRect, containerFrame: CGRect) -> CGRect

extension PresentrAnimation {

    func animate(transitionContext: UIViewControllerContextTransitioning, transform: FrameTransformer) {

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
