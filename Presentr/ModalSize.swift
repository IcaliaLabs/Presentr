//
//  ModalSize.swift
//  Presentr
//
//  Created by Daniel Lozano on 7/6/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
import UIKit

/// Descibes a presented modal's size dimension (width or height).
///
/// - default: Default size. Will use Presentr's default margins to calculate size of presented controller.
/// - half: Half of the screen.
/// - full: Full screen.
/// - fullMinusPadding: Full screen minus custom padding.
/// - percentage: Percentage of full screen.
/// - custom: Custom fixed-point size.
/// - customOrientation: Custom fixed point size, varies depending on orientation.
public enum ModalDimension {

    case `default`
    case half
    case full
    case fullMinusPadding(Float)
    case percentage(Float)
    case custom(Float)
    case customOrientation(sizePortrait: Float, sizeLandscape: Float)

}

struct ModalSize {

    let width: ModalDimension
    let height: ModalDimension

    /// <#Description#>
    ///
    /// - Parameter parentSize: <#parentSize description#>
    /// - Returns: <#return value description#>
    func calculateSize(parentSize: CGSize) -> CGSize {
        return CGSize(width: CGFloat(calculateWidth(parentSize: parentSize)),
                      height: CGFloat(calculateHeight(parentSize: parentSize)))
    }

    /// Calculates the exact width value for the presented view.
    ///
    /// - Parameter parentSize: The container view size for the presentation.
    /// - Returns: Exact width value.
    func calculateWidth(parentSize: CGSize) -> Float {
        switch width {
        case .default:
            return floorf(Float(parentSize.width) - (Presentr.Constants.Values.defaultSideMargin * 2.0))
        case .half:
            return floorf(Float(parentSize.width) / 2.0)
        case .full:
            return Float(parentSize.width)
        case .fullMinusPadding(let padding):
            return floorf(Float(parentSize.width) - padding * 2.0)
        case .percentage(let percentage):
            return floorf(Float(parentSize.width) * percentage)
        case .custom(let size):
            return size
        case .customOrientation(let sizePortrait, let sizeLandscape):
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                return min(Float(UIScreen.main.bounds.width), sizePortrait)
            case .landscapeLeft, .landscapeRight:
                return min(Float(UIScreen.main.bounds.width), sizeLandscape)
            default:
                return min(Float(UIScreen.main.bounds.width), sizePortrait)
            }
        }
    }

    /// Calculates the exact height value for the presented view.
    ///
    /// - Parameter parentSize: The container view size for the presentation.
    /// - Returns: Exact height value.
    func calculateHeight(parentSize: CGSize) -> Float {
        switch height {
        case .default:
            return floorf(Float(parentSize.height) * Presentr.Constants.Values.defaultHeightPercentage)
        case .half:
            return floorf(Float(parentSize.height) / 2.0)
        case .full:
            return Float(parentSize.height)
        case .fullMinusPadding(let padding):
            return floorf(Float(parentSize.height) - padding * 2)
        case .percentage(let percentage):
            return floorf(Float(parentSize.height) * percentage)
        case .custom(let size):
            return size
        case .customOrientation(let sizePortrait, let sizeLandscape):
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                return min(Float(UIScreen.main.bounds.height), sizePortrait)
            case .landscapeLeft, .landscapeRight:
                return min(Float(UIScreen.main.bounds.height), sizeLandscape)
            default:
                return min(Float(UIScreen.main.bounds.height), sizePortrait)
            }
        }
    }

}
