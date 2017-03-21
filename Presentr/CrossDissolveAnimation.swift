//
//  CrossDissolveAnimation.swift
//  Pods
//
//  Created by Daniel Lozano Valdés on 3/21/17.
//
//

import Foundation

class CrossDissolveAnimation: PresentrAnimation {

    override func beforeAnimation(using transitionContext: PresentrTransitionContext) {
        if transitionContext.isPresenting {
            transitionContext.containerView.addSubview(transitionContext.toView!)
        }

        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 0.0 : 1.0
    }

    override func performAnimation(using transitionContext: PresentrTransitionContext) {
        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 1.0 : 0.0
    }

//    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
//        let duration = transitionDuration(using: transitionContext)
//
//        if isPresenting {
//            containerView.addSubview(toView!)
//        }
//
//        animatingView?.alpha = isPresenting ? 0.0 : 1.0
//
//        UIView.animate(withDuration: duration, animations: {
//            animatingView?.alpha = isPresenting ? 1.0 : 0.0
//        }) { (completed) in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//        
//    }

}
