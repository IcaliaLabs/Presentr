//
//  Presentr+Equatable.swift
//  Presentr
//
//  Created by Daniel Lozano on 7/6/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

extension PresentationType: Equatable { }
public func ==(lhs: PresentationType, rhs: PresentationType) -> Bool{
    switch (lhs, rhs){
    case (let .Custom(lhsWidth, lhsHeight, lhsCenter), let .Custom(rhsWidth, rhsHeight, rhsCenter)):
        return lhsWidth == rhsWidth && lhsHeight == rhsHeight && lhsCenter == rhsCenter
    case (.Alert, .Alert):
        return true
    case (.Popup, .Popup):
        return true
    case (.TopHalf, .TopHalf):
        return true
    case (.BottomHalf, .BottomHalf):
        return true
    default:
        return false
    }
}

extension ModalSize: Equatable { }
public func ==(lhs: ModalSize, rhs: ModalSize) -> Bool{
    switch (lhs, rhs){
    case (let .Custom(lhsSize), let .Custom(rhsSize)):
        return lhsSize == rhsSize
    case (.Default, .Default):
        return true
    case (.Half, .Half):
        return true
    case (.Full, .Full):
        return true
    default:
        return false
    }
}

extension ModalCenterPosition: Equatable { }
public func ==(lhs: ModalCenterPosition, rhs: ModalCenterPosition) -> Bool{
    switch (lhs, rhs){
    case (let .Custom(lhsCenterPoint), let .Custom(rhsCenterPoint)):
        return lhsCenterPoint.x == rhsCenterPoint.x && lhsCenterPoint.y == rhsCenterPoint.y
    case (.Center, .Center):
        return true
    case (.TopCenter, .TopCenter):
        return true
    case (.BottomCenter, .BottomCenter):
        return true
    default:
        return false
    }
}
