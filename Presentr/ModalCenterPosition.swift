//
//  ModalCenterPosition.swift
//  Presentr
//
//  Created by Daniel Lozano on 7/6/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/**
 Describes the presented presented view controller's center position. It is meant to be non-specific, but we can use the 'calculatePoint' method when we want to calculate the exact point by passing in the 'containerBounds' rect that only the presentation controller should be aware of.

 - Center:       Center of the screen.
 - TopCenter:    Center of the top half of the screen.
 - BottomCenter: Center of the bottom half of the screen.
 - Custom: A custom center position using a CGPoint which represents the center point of the presented view controller.
 - Custom: A custom center position to be calculated, using a CGPoint which represents the origin of the presented view controller.
 */
public enum ModalCenterPosition {

    case Center
    case TopCenter
    case BottomCenter
    case Custom(centerPoint: CGPoint)
    case CustomOrigin(origin: CGPoint)

    /**
     Calculates the exact position for the presented view controller center.

     - parameter containerBounds: The container bounds the controller is being presented in.

     - returns: CGPoint representing the presented view controller's center point.
     */
    func calculatePoint(containerBounds: CGRect) -> CGPoint? {
        switch self {
        case .Center:
            return CGPoint(x: containerBounds.width / 2, y: containerBounds.height / 2)
        case .TopCenter:
            return CGPoint(x: containerBounds.width / 2, y: containerBounds.height * (1 / 4) - 1)
        case .BottomCenter:
            return CGPoint(x: containerBounds.width / 2, y: containerBounds.height * (3 / 4))
        case .Custom(let point):
            return point
        case .CustomOrigin(_):
            return nil
        }
    }

    func calculateOrigin() -> CGPoint? {
        switch self {
        case .CustomOrigin(let origin):
            return origin
        default:
            return nil
        }
    }

}
