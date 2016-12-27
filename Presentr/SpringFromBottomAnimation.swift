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

}

// MARK: UIViewControllerAnimatedTransitioning

extension SpringFromBottomAnimation: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animate(transitionContext,
                springDamping: springDamping,
                initialSpringVelocity: initialSpringVelocity,
                transform: { (finalFrame, containerFrame) -> CGRect in
                    var initialFrame = finalFrame
                    initialFrame.origin.y = containerFrame.size.height + initialFrame.size.height
                    return initialFrame
        })
    }
    
}
