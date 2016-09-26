//
//  CoverVerticalFromTopAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/14/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/// Custom 'CoverVerticalFromTopAnimation' animation. Conforms to 'PresentrAnimation' protocol
class CoverVerticalFromTopAnimation: NSObject, PresentrAnimation {

    var animationDuration: TimeInterval

    init(animationDuration: TimeInterval = 0.5) {
        self.animationDuration = animationDuration
    }

}

// MARK: UIViewControllerAnimatedTransitioning

extension CoverVerticalFromTopAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animate(transitionContext) { finalFrame, _ in
            var initialFrame = finalFrame
            initialFrame.origin.y = 0 - initialFrame.size.height
            return initialFrame
        }
    }

}
