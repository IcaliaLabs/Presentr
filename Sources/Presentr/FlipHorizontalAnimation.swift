//
//  FlipHorizontalAnimation.swift
//  Presentr
//
//  Created by Falko Buttler on 10/2/17.
//
// Inspired by https://stackoverflow.com/questions/12565204/smooth-horizontal-flip-using-catransform3dmakerotation

import Foundation

public class FlipHorizontalAnimation: PresentrAnimation {
    
    override public func performAnimation(using transitionContext: PresentrTransitionContext) {
		// This is to make sure transform/animation does not go behind background "chrome" view.
		transitionContext.toView?.layer.zPosition = 999
		transitionContext.fromView?.layer.zPosition = 999

        var fromViewRotationPerspectiveTrans = CATransform3DIdentity
        fromViewRotationPerspectiveTrans.m34 = -0.003
        fromViewRotationPerspectiveTrans = CATransform3DRotate(fromViewRotationPerspectiveTrans, .pi / 2.0, 0.0, -1.0, 0.0)
        
        var toViewRotationPerspectiveTrans = CATransform3DIdentity
        toViewRotationPerspectiveTrans.m34 = -0.003
        toViewRotationPerspectiveTrans = CATransform3DRotate(toViewRotationPerspectiveTrans, .pi / 2.0, 0.0, 1.0, 0.0)
        
        transitionContext.toView?.layer.transform = toViewRotationPerspectiveTrans
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
            transitionContext.fromView?.layer.transform = fromViewRotationPerspectiveTrans
        }) { _ in
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
                transitionContext.toView?.layer.transform = CATransform3DMakeRotation(.pi / 2.0, 0.0, 0.0, 0.0)
            }) { _ in }
        }
    }
    
}

