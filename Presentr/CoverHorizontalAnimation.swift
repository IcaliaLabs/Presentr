//
//  CoverHorizontalAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/15/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/// Custom 'CoverHorizontalAnimation' animation. Conforms to 'PresentrAnimation' protocol
class CoverHorizontalAnimation: NSObject, PresentrAnimation {

    var animationDuration: TimeInterval
    var fromRight: Bool

    init(animationDuration: TimeInterval = 0.5, fromRight: Bool = true) {
        self.animationDuration = animationDuration
        self.fromRight = fromRight
    }

}

// MARK: UIViewControllerAnimatedTransitioning

extension CoverHorizontalAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animate(transitionContext) { finalFrame, containerFrame in
            var initialFrame = finalFrame
            if self.fromRight {
                initialFrame.origin.x = containerFrame.size.width + initialFrame.size.width
            } else {
                initialFrame.origin.x = 0 - initialFrame.size.width
            }
            return initialFrame
        }
    }

}
