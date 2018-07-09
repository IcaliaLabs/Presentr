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
    case center(Center)
    case stickTo(ScreenEdge)
    
}

public protocol PositionDescriptor {
    func calculateOriginWith(presentedFrameSize: CGSize, containerFrame: CGRect) -> CGPoint
}

public extension ModalPosition {

    /// Describes the presented view's center position.
    ///
    /// - screenCenter: Center of the screen.
    /// - topCenter: Center of the top half of the screen.
    /// - bottomCenter: Center of the bottom half of the screen.
    /// - custom: A custom center position using a CGPoint which represents the center point of the presented view controller.
    public enum Center {

        case screenCenter
        case topCenter
        case bottomCenter
        case custom(centerPoint: CGPoint)

        /// Calculates the origin point for the presented view's frame.
        ///
        /// - Parameters:
        ///   - presentedFrameSize: The size for the presented view.
        ///   - containerFrame: The frame for the container view the controller is being presented in.
        /// - Returns: CGPoint representing the presented view's frame origin.
        func calculateOriginWith(presentedFrameSize: CGSize, containerFrame: CGRect) -> CGPoint {
            let presentedHalfWidth = presentedFrameSize.width / 2
            let presentedHalfHeight = presentedFrameSize.height / 2

            let containerHalfWidth = containerFrame.width / 2
            let containerHalfHeight = containerFrame.height / 2

            switch self {
            case .screenCenter:
                return CGPoint(x: containerFrame.minX + containerHalfWidth - presentedHalfWidth,
                               y: containerFrame.minY + containerHalfHeight - presentedHalfHeight)
            case .topCenter:
                return CGPoint(x: containerFrame.minX + containerHalfWidth - presentedHalfWidth,
                               y: containerFrame.minY + (containerFrame.height * (1 / 4) - 1) - presentedHalfHeight)
            case .bottomCenter:
                return CGPoint(x: containerFrame.minX + containerHalfWidth - presentedHalfWidth,
                               y: containerFrame.minY + (containerFrame.height * (3 / 4)) - presentedHalfHeight)
            case .custom(let point):
                return point
            }
        }

    }

}

public extension ModalPosition {

    /// <#Description#>
    ///
    /// - topLeft: <#topLeft description#>
    /// - topMiddle: <#topMiddle description#>
    /// - topRight: <#topRight description#>
    /// - bottomLeft: <#bottomLeft description#>
    /// - bottomMiddle: <#bottomMiddle description#>
    /// - bottomRight: <#bottomRight description#>
    public enum ScreenEdge {

        case topLeft(padding: CGFloat)
        case topMiddle(padding: CGFloat)
        case topRight(padding: CGFloat)
        case bottomLeft(padding: CGFloat)
        case bottomMiddle(padding: CGFloat)
        case bottomRight(padding: CGFloat)

        private var padding: CGFloat {
            switch self {
            case .topLeft(let padding):
                return padding
            case .topMiddle(let padding):
                return padding
            case .topRight(let padding):
                return padding
            case .bottomLeft(let padding):
                return padding
            case .bottomMiddle(let padding):
                return padding
            case .bottomRight(let padding):
                return padding
            }
        }

        /// Calculates the origin point for the presented view's frame.
        ///
        /// - Parameters:
        ///   - presentedFrameSize: The size for the presented view.
        ///   - containerFrame: The frame for the container view the controller is being presented in.
        /// - Returns: CGPoint representing the presented view's frame origin.
        func calculateOriginWith(presentedFrameSize: CGSize, containerFrame: CGRect) -> CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: containerFrame.minX + padding,
                               y: containerFrame.minY + padding)
            case .topMiddle:
                return CGPoint(x: containerFrame.minX + (containerFrame.width / 2) - (presentedFrameSize.width / 2),
                               y: containerFrame.minY + padding)
            case .topRight:
                return CGPoint(x: containerFrame.maxX - presentedFrameSize.width - padding,
                               y: containerFrame.minY + padding)
            case .bottomLeft:
                return CGPoint(x: containerFrame.minX + padding,
                               y: containerFrame.maxY - presentedFrameSize.height - padding)
            case .bottomMiddle:
                return CGPoint(x: containerFrame.minX + (containerFrame.width / 2) - (presentedFrameSize.width / 2),
                               y: containerFrame.maxY - presentedFrameSize.height - padding)
            case .bottomRight:
                return CGPoint(x: containerFrame.maxX - presentedFrameSize.width - padding,
                               y: containerFrame.maxY - presentedFrameSize.height - padding)
            }
        }

    }

}
