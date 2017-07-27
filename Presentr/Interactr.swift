//
//  Interactr.swift
//  Presentr
//
//  Created by Andreas Grauel on 26.07.17.
//  Copyright © 2017 danielozano. All rights reserved.
//

import Foundation
import UIKit

public class Interactr: UIPercentDrivenInteractiveTransition {
    public enum Direction {
        case up
        case down
        case left
        case right
    }
    
    var hasStarted = false
    var shouldFinish = false
    public var percentThreshold: CGFloat = 0.3
    
    public func calculateProgress(_ translationInView:CGPoint, viewBounds:CGRect, direction:Direction) -> CGFloat {
        let pointOnAxis:CGFloat
        let axisLength:CGFloat
        switch direction {
        case .up, .down:
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height
        case .left, .right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis:Float
        let positiveMovementOnAxisPercent:Float
        switch direction {
        case .right, .down: // positive
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .up, .left: // negative
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    public func mapGestureState(_ gestureState:UIGestureRecognizerState, progress:CGFloat, triggerSegue: () -> ()) {
        switch gestureState {
        case .began:
            hasStarted = true
            triggerSegue()
        case .changed:
            shouldFinish = progress > percentThreshold
            update(progress)
        case .cancelled:
            hasStarted = false
            cancel()
        case .ended:
            hasStarted = false
            shouldFinish ? finish() : cancel()
        default:
            break
        }
    }
}
