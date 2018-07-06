//
//  Presentr+Equatable.swift
//  Presentr
//
//  Created by Daniel Lozano on 7/6/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

extension PresentationType: Equatable {

    public static func == (lhs: PresentationType, rhs: PresentationType) -> Bool {
        switch (lhs, rhs) {
        case (.alert, .alert):
            return true
        case (.popup, .popup):
            return true
        case (.topHalf, .topHalf):
            return true
        case (.bottomHalf, .bottomHalf):
            return true
        case (.dynamic, .dynamic):
            return true
        case (let .custom(lhsWidth, lhsHeight, lhsPosition), let .custom(rhsWidth, rhsHeight, rhsPosition)):
            return lhsWidth == rhsWidth && lhsHeight == rhsHeight && lhsPosition == rhsPosition
        default:
            return false
        }
    }

}

extension ModalSize: Equatable {

    public static func == (lhs: ModalSize, rhs: ModalSize) -> Bool {
        switch (lhs, rhs) {
        case (.default, .default):
            return true
        case (.half, .half):
            return true
        case (.full, .full):
            return true
        case (let .custom(lhsSize), let .custom(rhsSize)):
            return lhsSize == rhsSize
        default:
            return false
        }
    }

}

extension ModalPosition: Equatable {

    public static func == (lhs: ModalPosition, rhs: ModalPosition) -> Bool {
        switch (lhs, rhs) {
        case (let .origin(lhsOrigin), let .origin(rhsOrigin)):
            return lhsOrigin == rhsOrigin
        case (let .center(lhsCenter), let .center(rhsCenter)):
            return lhsCenter == rhsCenter
        case (let .stickTo(lhsScreenEdge), let .stickTo(rhsScreenEdge)):
            return lhsScreenEdge == rhsScreenEdge
        default:
            return false
        }
    }

}

extension CenterPosition: Equatable {

    public static func == (lhs: CenterPosition, rhs: CenterPosition) -> Bool {
        switch (lhs, rhs) {
        case (.screenCenter, .screenCenter):
            return true
        case (.topCenter, .topCenter):
            return true
        case (.bottomCenter, .bottomCenter):
            return true
        case (let .custom(lhsCenterPoint), let .custom(rhsCenterPoint)):
            return lhsCenterPoint.x == rhsCenterPoint.x && lhsCenterPoint.y == rhsCenterPoint.y
        default:
            return false
        }
    }

}

extension ScreenEdgePosition: Equatable {

    public static func == (lhs: ScreenEdgePosition, rhs: ScreenEdgePosition) -> Bool {
        switch (lhs, rhs) {
        case (.topLeft, .topLeft):
            return true
        case (.topMiddle, .topMiddle):
            return true
        case (.topRight, .topRight):
            return true
        case (.bottomLeft, .bottomLeft):
            return true
        case (.bottomMiddle, .bottomMiddle):
            return true
        case (.bottomRight, .bottomRight):
            return true
        default:
            return false
        }
    }

}
