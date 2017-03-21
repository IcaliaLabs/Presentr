//
//  PresentrAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/14/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit

/// Simplified wrapper for the UIViewControllerContextTransitioning protocol.
public struct PresentrTransitionContext {

    let containerView: UIView

    let initialFrame: CGRect

    let finalFrame: CGRect

    let isPresenting: Bool

    let fromViewController: UIViewController?

    let toViewController: UIViewController?

    let fromView: UIView?

    let toView: UIView?

    let animatingViewController: UIViewController?
    
    let animatingView: UIView?
    
}

/// Class that handles animating the transition. Override this class if you want to create your own transition animation.
open class PresentrAnimation: NSObject {

    /// Animation duration. Default is 0.5, override to customize.
    open var animationDuration: TimeInterval {
        return 0.5
    }


    /// <#Description#>
    ///
    /// - Parameters:
    ///   - containerFrame: <#containerFrame description#>
    ///   - finalFrame: <#finalFrame description#>
    /// - Returns: <#return value description#>
    open func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        initialFrame.origin.y = containerFrame.height + initialFrame.height
        return initialFrame
    }


    /// <#Description#>
    ///
    /// - Parameter transitionContext: <#transitionContext description#>
    open func beforeAnimation(using transitionContext: PresentrTransitionContext) {
        let finalFrameForVC = transitionContext.finalFrame
        let initialFrameForVC = transform(containerFrame: transitionContext.containerView.frame, finalFrame: finalFrameForVC)

        let initialFrame = transitionContext.isPresenting ? initialFrameForVC : finalFrameForVC
        let finalFrame = transitionContext.isPresenting ? finalFrameForVC : initialFrameForVC

        if transitionContext.isPresenting {
            transitionContext.containerView.addSubview(transitionContext.toView!)
        }

        transitionContext.animatingView?.frame = initialFrame
    }


    /// <#Description#>
    ///
    /// - Parameter transitionContext: <#transitionContext description#>
    open func performAnimation(using transitionContext: PresentrTransitionContext) {
        let finalFrameForVC = transitionContext.finalFrame
        let initialFrameForVC = transform(containerFrame: transitionContext.containerView.frame, finalFrame: finalFrameForVC)
        let finalFrame = transitionContext.isPresenting ? finalFrameForVC : initialFrameForVC

        transitionContext.animatingView?.frame = finalFrame
    }

}

// MARK: - UIViewControllerAnimatedTransitioning

extension PresentrAnimation: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)

        let isPresenting: Bool = (toViewController?.presentingViewController == fromViewController)

        let animatingVC = isPresenting ? toViewController : fromViewController
        let animatingView = isPresenting ? toView : fromView

        let initialFrame = transitionContext.initialFrame(for: animatingVC!)
        let finalFrame = transitionContext.finalFrame(for: animatingVC!)

        let presentrContext = PresentrTransitionContext(containerView: containerView,
                                                        initialFrame: initialFrame,
                                                        finalFrame: finalFrame,
                                                        isPresenting: isPresenting,
                                                        fromViewController: fromViewController,
                                                        toViewController: toViewController,
                                                        fromView: fromView,
                                                        toView: toView,
                                                        animatingViewController: animatingVC,
                                                        animatingView: animatingView)

        beforeAnimation(using: presentrContext)

        UIView.animate(withDuration: animationDuration, animations: {
            self.performAnimation(using: presentrContext)
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

//    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//
//        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
//        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
//        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
//        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
//
//        let isPresenting: Bool = (toViewController?.presentingViewController == fromViewController)
//
//        let animatingVC = isPresenting ? toViewController : fromViewController
//        let animatingView = isPresenting ? toView : fromView
//
//        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
//        let initialFrameForVC = transform(containerFrame: containerView.frame, finalFrame: finalFrameForVC)
//
//        let initialFrame = isPresenting ? initialFrameForVC : finalFrameForVC
//        let finalFrame = isPresenting ? finalFrameForVC : initialFrameForVC
//
//        let duration = transitionDuration(using: transitionContext)
//
//        if isPresenting {
//            containerView.addSubview(toView!)
//        }
//
//        animatingView?.frame = initialFrame
//
//        UIView.animate(withDuration: duration, animations: {
//            animatingView?.frame = finalFrame
//        }) { (completed) in
//            if !isPresenting {
//                fromView?.removeFromSuperview()
//            }
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//        
//    }

}
