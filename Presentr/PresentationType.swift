//
//  PresentationType.swift
//  Presentr
//
//  Created by Daniel Lozano on 7/6/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/**
 Basic Presentr type. Its job is to describe the 'type' of presentation. The type describes the size and position of the presented view controller.

 - Alert:      This is a small 270 x 180 alert which is the same size as the default iOS alert.
 - Popup:      This is a average/default size 'popup' modal.
 - TopHalf:    This takes up half of the screen, on the top side.
 - BottomHalf: This takes up half of the screen, on the bottom side.
 - FullScreen: This takes up the entire screen.
 - Custom: Provide a custom width, height and center position.
 */
public enum PresentationType {

    case Alert
    case Popup
    case TopHalf
    case BottomHalf
    case FullScreen
    case Custom(width: ModalSize, height: ModalSize, center: ModalCenterPosition)

    /**
     Describes the sizing for each Presentr type. It is meant to be non device/width specific, except for the .Custom case.

     - returns: A tuple containing two 'ModalSize' enums, describing its width and height.
     */
    func size() -> (width: ModalSize, height: ModalSize) {
        switch self {
        case .Alert:
            return (.Custom(size: 270), .Custom(size: 180))
        case .Popup:
            return (.Default, .Default)
        case .TopHalf, .BottomHalf:
            return (.Full, .Half)
        case .FullScreen:
            return (.Full, .Full)
        case .Custom(let width, let height, _):
            return (width, height)
        }
    }

    /**
     Describes the position for each Presentr type. It is meant to be non device/width specific, except for the .Custom case.

     - returns: Returns a 'ModalCenterPosition' enum describing the center point for the presented modal.
     */
    func position() -> ModalCenterPosition {
        switch self {
        case .Alert, .Popup:
            return .Center
        case .TopHalf:
            return .TopCenter
        case .BottomHalf:
            return .BottomCenter
        case .FullScreen:
            return .Center
        case .Custom(_, _, let center):
            return center
        }
    }

    /**
     Associates each Presentr type with a default transition type, in case one is not provided to the Presentr object.

     - returns: Return a 'TransitionType' which describes a system provided or custom transition animation.
     */
    func defaultTransitionType() -> TransitionType {
        switch self {
        case .TopHalf:
            return .CoverVerticalFromTop
        default:
            return .CoverVertical
        }
    }

}
