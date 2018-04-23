//
//  PresentationType.swift
//  Presentr
//
//  Created by Daniel Lozano on 7/6/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/// Basic Presentr type. Its job is to describe the 'type' of presentation. The type describes the size and position of the presented view controller.
///
/// - alert: This is a small 270 x 180 alert which is the same size as the default iOS alert.
/// - popup: This is a average/default size 'popup' modal.
/// - topHalf: This takes up half of the screen, on the top side.
/// - bottomHalf: This takes up half of the screen, on the bottom side.
/// - fullScreen: This takes up the entire screen.
/// - dynamic: Uses autolayout to calculate width & height. Have to provide center position.
/// - custom: User provided custom width, height & center position.
public enum PresentationType {

    case alert
    case popup
    case topHalf
    case bottomHalf
    case fullScreen
    case custom(layout: ModalLayout)

    var layout : ModalLayout {
        switch self {
        case .alert:
            return ModalLayout(width: .fixed(size: 270),
                               height: .fixed(size: 180),
                               positionReference: .center,
                               position: .center)
        case .popup:
            return ModalLayout(width: .inset(by: 20),
                               height: .inset(by: 20),
                               positionReference: .center,
                               position: .center)
        case .topHalf:
            return ModalLayout(width: .full,
                               height: .half,
                               positionReference: .topMiddle,
                               position: .top)
        case .bottomHalf:
            return ModalLayout(width: .full,
                               height: .half,
                               positionReference: .bottomMiddle,
                               position: .bottom)
        case .fullScreen:
            return ModalLayout(width: .full,
                               height: .full,
                               positionReference: .center,
                               position: .center)
        case .custom(let layout):
            return layout
        }
    }
    


    /// Associates each Presentr type with a default transition type, in case one is not provided to the Presentr object.
    ///
    /// - Returns: Return a 'TransitionType' which describes a transition animation.
    func defaultTransitionType() -> TransitionType {
        switch self {
        case .topHalf:
            return .coverVerticalFromTop
        default:
            return .coverVertical
        }
    }

    /// Default round corners setting.
    var shouldRoundCorners: Bool {
        switch self {
        case .alert, .popup:
            return true
        default:
            return false
        }
    }

}
