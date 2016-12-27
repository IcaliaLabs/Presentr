//
//  PresentrAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/14/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/// Class that handles animating the transition. Override this class if you want to create your own transition animation.
open class PresentrAnimation: NSObject {

    /// Spring damping for the UIView animation. Default is 300. Override to customize.
    open var springDamping: CGFloat {
        return 300
    }

    /// Initial spring velocity for the UIView animation. Default is 5. Override to customize.
    open var initialSpringVelocity: CGFloat {
        return 5
    }

    /// Animation duration. Default is 0.5, override to customize.
    open var animationDuration: TimeInterval {
        return 0.5
    }

    /// Method used to create an initial frame for the animation. Override to customize, default is 0,0,0,0.
    ///
    /// - Parameters:
    ///   - containerFrame: The container frame.
    ///   - finalFrame: The final frame for the view controller.
    /// - Returns: The initial frame for the animation.
    open func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        initialFrame.origin.y = containerFrame.height + initialFrame.height
        return initialFrame
    }


    /// If you want to completely handle the transition animation on your own, override this method and return true. If you return true and handle the animation on your own, all the other animation properties of this class will be ignored.
    ///
    /// - Parameter transitionContext: The transition context for the transition animation.
    /// - Returns: A boolean indicating if you want to use this custom animation instead of the included version.
    open func customAnimation(using transitionContext: UIViewControllerContextTransitioning) -> Bool {
        return false
    }

}

// MARK: - UIViewControllerAnimatedTransitioning

extension PresentrAnimation: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let custom = customAnimation(using: transitionContext)
        guard custom == false else {
            return
        }

        let containerView = transitionContext.containerView

        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)

        let isPresenting: Bool = (toViewController?.presentingViewController == fromViewController)

        let animatingVC = isPresenting ? toViewController : fromViewController
        let animatingView = isPresenting ? toView : fromView

        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
        let initialFrameForVC = transform(containerFrame: containerView.frame, finalFrame: finalFrameForVC)

        let initialFrame = isPresenting ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresenting ? finalFrameForVC : initialFrameForVC

        let duration = transitionDuration(using: transitionContext)

        if isPresenting {
            containerView.addSubview(toView!)
        }

        animatingView?.frame = initialFrame

        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: .allowUserInteraction,
                       animations: {

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
