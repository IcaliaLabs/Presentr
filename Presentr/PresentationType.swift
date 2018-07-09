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
    case bottomCard
    case topHalf
    case bottomHalf
    case fullScreen
    case dynamicSize(position: ModalPosition)
    case custom(width: ModalDimension, height: ModalDimension, position: ModalPosition)

    /// Describes the sizing for each PresentationType.
    var size: ModalSize? {
        switch self {
        case .alert:
            return ModalSize(width: .custom(270), height: .custom(180))
        case .popup:
            return ModalSize(width: .default, height: .default)
        case .bottomCard:
            return ModalSize(width: .full, height: .custom(350))
        case .topHalf, .bottomHalf:
            return ModalSize(width: .full, height: .half)
        case .fullScreen:
            return ModalSize(width: .full, height: .full)
        case .custom(let width, let height, _):
            return ModalSize(width: width, height: height)
        case .dynamicSize(_):
            return nil
        }
    }

    /// Describes the position for each PresentationType.
    var position: ModalPosition {
        switch self {
        case .alert, .popup:
            return .center(.screenCenter)
        case .bottomCard:
            return .stickTo(.bottomMiddle(padding: 0))
        case .topHalf:
            return .center(.topCenter)
        case .bottomHalf:
            return .center(.bottomCenter)
        case .fullScreen:
            return .center(.screenCenter)
        case .dynamicSize(let position):
            return position
        case .custom(_, _, let position):
            return position
        }
    }

    /// Default transition type.
    var defaultTransitionType: TransitionType {
        switch self {
        case .topHalf:
            return .coverVerticalFromTop
        default:
            return .coverVertical
        }
    }

    /// Default rounded corners setting.
    var defaultRoundedCorners: RoundedCorners {
        switch self {
        case .alert, .popup:
            return .all
        case .bottomCard:
            return RoundedCorners(.top, radius: 15)
        default:
            return .none
        }
    }

}
