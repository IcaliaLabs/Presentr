//
//  ModalPosition.swift
//  Presentr
//
//  Created by Daniel Lozano on 7/6/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/// <#Description#>
///
/// - custom: <#custom description#>
/// - center: <#center description#>
/// - stickTo: <#stickTo description#>
public enum ModalPosition {

    case origin(CGPoint)
    case center(CenterPosition)
    case stickTo(ScreenEdgePosition)

}

public extension ModalPosition {

    /**
     Describes the presented presented view controller's center position. It is meant to be non-specific, but we can use the 'calculatePoint' method when we want to calculate the exact point by passing in the 'containerBounds' rect that only the presentation controller should be aware of.

     - Center:       Center of the screen.
     - TopCenter:    Center of the top half of the screen.
     - BottomCenter: Center of the bottom half of the screen.
     - Custom: A custom center position using a CGPoint which represents the center point of the presented view controller.
     - Custom: A custom center position to be calculated, using a CGPoint which represents the origin of the presented view controller.
     */
    public enum CenterPosition {

        case screenCenter
        case topCenter
        case bottomCenter
        case custom(centerPoint: CGPoint)

        /**
         Calculates the exact position for the presented view controller center.

         - parameter containerBounds: The container bounds the controller is being presented in.

         - returns: CGPoint representing the presented view controller's center point.
         */
//        func calculateCenterPointWith(containerFrame: CGRect) -> CGPoint {
//            let halfWidth = containerFrame.width / 2
//            let halfHeight = containerFrame.height / 2
//
//            switch self {
//            case .screenCenter:
//                return CGPoint(x: containerFrame.minX + halfWidth,
//                               y: containerFrame.minY + halfHeight)
//            case .topCenter:
//                return CGPoint(x: containerFrame.minX + halfWidth,
//                               y: containerFrame.minY + (containerFrame.height * (1 / 4) - 1))
//            case .bottomCenter:
//                return CGPoint(x: containerFrame.minX + halfWidth,
//                               y: containerFrame.minY + (containerFrame.height * (3 / 4)))
//            case .custom(let point):
//                return point
//            }
//        }

        func calculateOriginWith(presentedFrameSize: CGSize, containerFrame: CGRect) -> CGPoint {
            let presentedFrameHalfWidth = presentedFrameSize.width / 2
            let presentedFrameHalfHeight = presentedFrameSize.height / 2

            let containerFrameHalfWidth = containerFrame.width / 2
            let containerFrameHalfHeight = containerFrame.height / 2

            switch self {
            case .screenCenter:
                return CGPoint(x: containerFrame.minX + containerFrameHalfWidth - presentedFrameHalfWidth,
                               y: containerFrame.minY + containerFrameHalfHeight - presentedFrameHalfHeight)
            case .topCenter:
                return CGPoint(x: containerFrame.minX + containerFrameHalfWidth - presentedFrameHalfWidth,
                               y: containerFrame.minY + (containerFrame.height * (1 / 4) - 1) - presentedFrameHalfHeight)
            case .bottomCenter:
                return CGPoint(x: containerFrame.minX + containerFrameHalfWidth - presentedFrameHalfWidth,
                               y: containerFrame.minY + (containerFrame.height * (3 / 4)) - presentedFrameHalfHeight)
            case .custom(let point):
                return point
            }
        }

    }


    /// <#Description#>
    ///
    /// - topLeft: <#topLeft description#>
    /// - topMiddle: <#topMiddle description#>
    /// - topRight: <#topRight description#>
    /// - bottomLeft: <#bottomLeft description#>
    /// - bottomMiddle: <#bottomMiddle description#>
    /// - bottomRight: <#bottomRight description#>
    public enum ScreenEdgePosition {

        case topLeft
        case topMiddle
        case topRight
        case bottomLeft
        case bottomMiddle
        case bottomRight

        func calculateOriginWith(presentedFrameSize: CGSize, containerFrame: CGRect) -> CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: containerFrame.minX,
                               y: containerFrame.minY)
            case .topMiddle:
                return CGPoint(x: containerFrame.minX + (containerFrame.width / 2) - (presentedFrameSize.width / 2),
                               y: containerFrame.minY)
            case .topRight:
                return CGPoint(x: containerFrame.maxX,
                               y: containerFrame.minY)
            case .bottomLeft:
                return CGPoint(x: containerFrame.minX,
                               y: containerFrame.maxY)
            case .bottomMiddle:
                return CGPoint(x: containerFrame.minX + (containerFrame.width / 2) - (presentedFrameSize.width / 2),
                               y: containerFrame.maxY)
            case .bottomRight:
                return CGPoint(x: containerFrame.maxX,
                               y: containerFrame.maxY)
            }
        }

    }

}
